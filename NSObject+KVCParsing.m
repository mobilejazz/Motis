//
//  NSObject+KVCParsing.m
//  Copyright 2014 Mobile Jazz
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "NSObject+KVCParsing.h"
#import <objc/runtime.h>

#define KVCP_DEBUG 0

#if KVCP_DEBUG
#define KVCPLog(format, ...) NSLog(@"%@",[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
#define KVCPLog(format, ...)
#endif

@interface NSObject (KVCParsing_Validation_Private)

/**
 * Return YES if the value has been automatically validated. The newer value is setted in the pointer.
 * @param ioValue The value to be validated.
 * @param key The property key in which the validated value is going to be assigned.
 * @return YES if automatic validation has been done, NO otherwise.
 * @discussion A return value of NO only indicates that the value couldn't be validated automatically.
 **/
- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue forKey:(NSString*)key;

/**
 * Return YES if the value has been automatically validated. The newer value is setted in the pointer.
 * @param ioValue The value to be validated.
 * @param typeClass The final class for the value.
 * @return YES if automatic validation has been done, NO otherwise.
 * @discussion A return value of NO only indicates that the value couldn't be validated automatically.
 **/
- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue toClass:(Class)typeClass;

@end


#pragma mark - KVCParsing

static char const * const kKVCParsingAllowGenericKVCAccessorsInMappingKey = "MJKVCParsing_allowGenericKVCAccessorsInMapping";

@implementation NSObject (KVCParsing)

#pragma mark Public Methods

- (void)mjz_parseValue:(id)value forKey:(NSString *)key
{
    NSString *mappedKey = [self mjz_mapKey:key];
    
    if (!mappedKey)
    {
        [self mjz_parseValue:value forUndefinedMappingKey:key];
        return;
    }
    
    NSError *error = nil;
    BOOL validated = YES;
    
    if (self.mjz_validatesKVCParsing)
    {
        if ([value isKindOfClass:NSArray.class])
        {
            __block NSMutableArray *modifiedArray = nil;
            
            [value enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id object, NSUInteger idx, BOOL *stop) {
                
                id validatedObject = object;
                
                if (self.mjz_automaticKVCParsingValidationEnabled)
                {
                    Class typeClass = self.mjz_arrayTypeMappingForKVCParsing[mappedKey];
                    if (typeClass)
                        [self mjz_validateAutomaticallyValue:&validatedObject toClass:typeClass];
                }
                
                BOOL validated = [self mjz_validateArrayObject:&validatedObject arrayKey:mappedKey arrayOriginalKey:key];
                
                if (validated)
                {
                    if (validatedObject != object)
                    {
                        if (!modifiedArray)
                            modifiedArray = [value mutableCopy];
                        
                        [modifiedArray replaceObjectAtIndex:idx withObject:validatedObject];
                    }
                }
                else
                {
                    if (!modifiedArray)
                        modifiedArray = [value mutableCopy];
                    
                    [modifiedArray removeObjectAtIndex:idx];
                }
            }];
            if (modifiedArray)
            {
                value = modifiedArray;
            }
        }
        
        // TODO: Automatic validation must be done before or after manual validation?
        // TODO: Automatic validation should be done if value is an array?
        
        if (self.mjz_automaticKVCParsingValidationEnabled)
            [self mjz_validateAutomaticallyValue:&value forKey:mappedKey];
        
        validated = [self mjz_validateValue:&value forKey:mappedKey originalKey:key error:&error];
    }
    
    if (validated)
    {
        if (value != [NSNull null] && value != nil)
            [self setValue:value forKey:mappedKey];
        else
            [self setNilValueForKey:mappedKey];
    }
    else
    {
        // Nothing to do. Value is not setted.
        KVCPLog(@"Value for Key <%@>  is not valid in class %@. Error: %@", key, [self.class description], error);
    }
}

- (void)mjz_parseValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    for (NSString *key in keyedValues)
    {
        id value = keyedValues[key];
        [self mjz_parseValue:value forKey:key];
    }
}

- (void)setMjz_allowGenericKVCAccessorsInMapping:(BOOL)allowGenericKVCAccessorsInMapping
{
    objc_setAssociatedObject(self, kKVCParsingAllowGenericKVCAccessorsInMappingKey, @(allowGenericKVCAccessorsInMapping), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mjz_allowGenericKVCAccessorsInMapping
{
    NSNumber *value = objc_getAssociatedObject(self, kKVCParsingAllowGenericKVCAccessorsInMappingKey);
    
    if (!value)
    {
        BOOL defaultValue = NO;
        self.mjz_allowGenericKVCAccessorsInMapping = defaultValue;
        return defaultValue;
    }
    
    return [value boolValue];
}

- (NSDictionary*)mjz_mappingForKVCParsing
{
    // Subclasses must override, always adding super to the mapping!
    return @{};
}

- (NSString*)mjz_extendedObjectDescription
{
    NSString *description = self.description;
    NSArray *keys = [[self mjz_mappingForKVCParsing] allValues];
    if (keys.count > 0)
    {
        NSDictionary *keyValues = [self dictionaryWithValuesForKeys:keys];
        return [NSString stringWithFormat:@"%@ - Mapped Values: %@", description, [keyValues description]];
    }
    return description;
}

- (void)mjz_parseValue:(id)value forUndefinedMappingKey:(NSString*)key
{
    // Subclasses may override.
}

#pragma mark Private Methods

- (NSString*)mjz_mapKey:(NSString*)key
{
    NSString *mappedKey = [[self mjz_mappingForKVCParsing] valueForKey:key];
    
    if (mappedKey)
        return mappedKey;
    
    if (self.mjz_allowGenericKVCAccessorsInMapping)
        return key;
    
    return nil;
}

@end


#pragma mark - KVCParsing_Validation

static char const * const kKVCParsingValidatesKVCParsingKey = "MJKVCParsing_validatesKVCParsing";
static char const * const kKVCParsingAutomaticKVCparsingValidationEnabledKey = "MJKVCParsing_automaticKVCParsingValidationEnabled";

@implementation NSObject (KVCParsing_Validation)

#pragma mark Public Methods

- (void)setMjz_validatesKVCParsing:(BOOL)validateKVCParsing
{
    objc_setAssociatedObject(self, kKVCParsingValidatesKVCParsingKey, @(validateKVCParsing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mjz_validatesKVCParsing
{
    NSNumber *value = objc_getAssociatedObject(self, kKVCParsingValidatesKVCParsingKey);
    
    if (!value)
    {
        BOOL defaultValue = YES;
        self.mjz_validatesKVCParsing = defaultValue;
        return defaultValue;
    }
    
    return [value boolValue];
}

- (void)setMjz_automaticKVCParsingValidationEnabled:(BOOL)automaticKVCParsingValidationEnabled
{
    objc_setAssociatedObject(self, kKVCParsingAutomaticKVCparsingValidationEnabledKey, @(automaticKVCParsingValidationEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mjz_automaticKVCParsingValidationEnabled
{
    NSNumber *value = objc_getAssociatedObject(self, kKVCParsingAutomaticKVCparsingValidationEnabledKey);
    
    if (!value)
    {
        BOOL defaultValue = YES;
        self.mjz_automaticKVCParsingValidationEnabled = defaultValue;
        return defaultValue;
    }
    
    return [value boolValue];
}

- (NSDictionary*)mjz_arrayTypeMappingForKVCParsing
{
    // Subclasses might override.
    return @{};
}

- (NSSet*)mjz_disabledClassTypesForAutomaticParsing
{
    // Subclasses might override.
    return [NSSet set];
}

- (BOOL)mjz_validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey originalKey:(NSString*)originalKey error:(out NSError *__autoreleasing *)outError
{
    return [self validateValue:ioValue forKey:inKey error:outError];
}

- (BOOL)mjz_validateArrayObject:(inout __autoreleasing id *)ioValue arrayKey:(NSString *)arrayKey arrayOriginalKey:(NSString*)arrayOriginalKey;
{
    // Subclasses might override.
    return YES;
}

@end

@implementation NSObject (KVCParsing_Validation_Private)

- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue forKey:(NSString*)key
{
    objc_property_t property = class_getProperty(self.class, key.UTF8String);
    
    const char * type = property_getAttributes(property);
    
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if (strcmp(rawPropertyType, @encode(unsigned)) == 0)
    {
        KVCPLog(@"%@ --> UNSIGNED", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithUnsignedInt:[*ioValue unsignedIntValue]];
            return YES;
        }
    }
    else if (strcmp(rawPropertyType, @encode(unsigned long)) == 0)
    {
        KVCPLog(@"%@ --> UNSIGNED LONG", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithUnsignedLong:[*ioValue unsignedLongValue]];
            return YES;
        }
    }
    else if (strcmp(rawPropertyType, @encode(unsigned long long)) == 0)
    {
        KVCPLog(@"%@ --> UNSIGNED LONG LONG", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithUnsignedLongLong:[*ioValue unsignedLongLongValue]];
            return YES;
        }
    }
    if (strcmp(rawPropertyType, @encode(int)) == 0)
    {
        KVCPLog(@"%@ --> INT", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithInt:[*ioValue intValue]];
            return YES;
        }
    }
    else if (strcmp(rawPropertyType, @encode(long)) == 0)
    {
        KVCPLog(@"%@ --> LONG", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithLong:[*ioValue longValue]];
            return YES;
        }
    }
    else if (strcmp(rawPropertyType, @encode(long long)) == 0)
    {
        KVCPLog(@"%@ --> LONG LONG", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithLongLong:[*ioValue longLongValue]];
            return YES;
        }
    }
    else if (strcmp(rawPropertyType, @encode(float)) == 0)
    {
        KVCPLog(@"%@ --> FLOAT", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithFloat:[*ioValue floatValue]];
            return YES;
        }
    }
    else if (strcmp(rawPropertyType, @encode(double)) == 0)
    {
        KVCPLog(@"%@ --> DOBULE", key);
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSNumber numberWithDouble:[*ioValue doubleValue]];
            return YES;
        }
    }
    else if (strcmp(rawPropertyType, @encode(id)) == 0)
    {
        KVCPLog(@"%@ --> ID", key);
        // Unknown object. Cannot validate.
        return NO;
    }
    else if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1)
    {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)]; // <-- turns @"NSDate" into NSDate
        Class typeClass = NSClassFromString(typeClassName);
        
        if (typeClass != nil)
        {
            KVCPLog(@"%@ --> %@", key, typeClassName);
            return [self mjz_validateAutomaticallyValue:ioValue toClass:typeClass];
        }
    }
    else
    {
        KVCPLog(@"%@ --> <UNKNOWN>", key);
    }
    
    return NO;
}

- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue toClass:(Class)typeClass
{
    // ----------
    // Check if the receiver type (typeClass) can be automatically validated:
    
//    if ([[self mjz_disabledClassTypesForAutomaticParsing] containsObject:typeClass])
//        return NO;
    
    NSArray *forbidenClasses = [[self mjz_disabledClassTypesForAutomaticParsing] allObjects];
    for (Class forbidenClass in forbidenClasses)
    {
        if ([typeClass isSubclassOfClass:forbidenClass])
            return NO;
    }
    
    // ----------
    // Start checking the type of the receiver (typeClass) with the type of the container (*ioValue)
    
    if ([typeClass isSubclassOfClass:NSDictionary.class] ||
        [typeClass isSubclassOfClass:NSArray.class] ||
        [typeClass isSubclassOfClass:NSSet.class])
    {
        // Cannot do anything.
        return NO;
    }
    else if ([typeClass isSubclassOfClass:NSDate.class])
    {
        if ([*ioValue isKindOfClass:NSNumber.class])
        {
            *ioValue = [NSDate dateWithTimeIntervalSince1970:[*ioValue doubleValue]];
        }
        else if ([*ioValue isKindOfClass:NSString.class])
        {
            // TODO: Parse standard JSON format into date.
        }
    }
    else if ([typeClass isSubclassOfClass:NSURL.class])
    {
        if ([*ioValue isKindOfClass:NSString.class])
        {
            *ioValue = [NSURL URLWithString:*ioValue];
            return YES;
        }
    }
    //else if ()
    //{
    //    TODO: add more automatic parsing for multiple object types here
    //}
    else
    {
        // if container is a NSDictionary, parse the new object using the same technique.
        if ([*ioValue isKindOfClass:NSDictionary.class])
        {
            id instance = [[typeClass alloc] init];
            [instance mjz_parseValuesForKeysWithDictionary:*ioValue];
            
            *ioValue = instance;
            return YES;
        }
    }
    
    return NO;
}

@end
