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


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - KVCParsing_Private

@interface NSObject (KVCParsing_Private)

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
 * @param key The property key in which the validated value will be assigned, either directly or as part of an array.
 * @return YES if automatic validation has been done, NO otherwise.
 * @discussion A return value of NO only indicates that the value couldn't be validated automatically.
 **/
- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue toClass:(Class)typeClass key:(NSString*)key;

@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - KVCParsing

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
    
    if ([value isKindOfClass:NSArray.class])
    {
        __block NSMutableArray *modifiedArray = nil;
        
        [value enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            
            id validatedObject = object;
            
            NSError *error = nil;
            BOOL validated = [self mjz_validateArrayObject:&validatedObject forArrayKey:mappedKey error:&error];
            
            // Automatic validation only if the value has not been manually validated
            if (object == validatedObject)
            {
                Class typeClass = self.mjz_arrayClassTypeMappingForAutomaticKVCParsingValidation[mappedKey];
                if (typeClass)
                {
                    validated = [self mjz_validateAutomaticallyValue:&validatedObject toClass:typeClass key:mappedKey];
                }
            }
            
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
                
                [self mjz_invalidValue:validatedObject forArrayKey:mappedKey error:error];
            }
        }];
        if (modifiedArray)
        {
            value = modifiedArray;
        }
    }

    id originalValue = value;
    
    NSError *error = nil;
    BOOL validated = [self validateValue:&value forKey:mappedKey error:&error];
    
    // Automatic validation only if the value has not been manually validated
    if (originalValue == value)
    {
        validated = [self mjz_validateAutomaticallyValue:&value forKey:mappedKey];
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
        [self mjz_invalidValue:value forKey:mappedKey error:error];
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

#pragma mark Private Methods

- (NSString*)mjz_mapKey:(NSString*)key
{
    NSString *mappedKey = [[self mjz_mappingForKVCParsing] valueForKey:key];
    
    if (mappedKey)
        return mappedKey;
    
    if ([self.class mjz_mappingClearanceForKVCParsing] == KVCParsingMappingClearanceOpen)
        return key;
    
    return nil;
}

@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - KVCParsing_Subclassing

@implementation NSObject (KVCParsing_Subclassing)


- (NSDictionary*)mjz_mappingForKVCParsing
{
    // Subclasses must override, always adding super to the mapping!
    return @{};
}

+ (KVCParsingMappingClearance)mjz_mappingClearanceForKVCParsing
{
    // Subclasses might override.
    return KVCParsingMappingClearanceOpen;
}

- (NSDictionary*)mjz_arrayClassTypeMappingForAutomaticKVCParsingValidation
{
    // Subclasses might override.
    return @{};
}

- (void)mjz_didCreateObject:(id)object forKey:(NSString *)key
{
    // Subclasses might override.
}

- (BOOL)mjz_validateArrayObject:(inout __autoreleasing id *)ioValue forArrayKey:(NSString *)arrayKey error:(out NSError *__autoreleasing *)outError
{
    // Subclasses might override.
    return YES;
}

- (void)mjz_parseValue:(id)value forUndefinedMappingKey:(NSString*)key
{
    // Subclasses might override.
    KVCPLog(@"Undefined Mapping Key <%@> in class %@.", key, [self.class description]);
}

- (void)mjz_invalidValue:(id)value forKey:(NSString *)key error:(NSError*)error
{
    // Subclasses might override.
    KVCPLog(@"Value for Key <%@> is not valid in class %@. Error: %@", key, [self.class description], error);
}

- (void)mjz_invalidValue:(id)value forArrayKey:(NSString *)key error:(NSError*)error
{
    // Subclasses might override.
    KVCPLog(@"Item for ArrayKey <%@> is not valid in class %@. Error: %@", key, [self.class description], error);
}

@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - KVCParsing_Private

@implementation NSObject (KVCParsing_Private)

- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue forKey:(NSString*)key
{
    objc_property_t property = class_getProperty(self.class, key.UTF8String);
    
    const char * type = property_getAttributes(property);
    
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
    {
        if ([*ioValue isKindOfClass:NSString.class])
        {
            KVCPLog(@"NSString --> BOOL", key);
            BOOL premium = [*ioValue boolValue];
            *ioValue = @(premium);
            return YES;
        }
    }
    
    // Other basic types are already handled by the system.

    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1)
    {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)]; // <-- turns @"NSDate" into NSDate
        Class typeClass = NSClassFromString(typeClassName);
        
        if (typeClass != nil)
        {
            KVCPLog(@"%@ --> %@", key, typeClassName);
            return [self mjz_validateAutomaticallyValue:ioValue toClass:typeClass key:key];
        }
    }
    else
    {
        KVCPLog(@"%@ --> <UNKNOWN>", key);
    }
    
    return NO;
}

- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue toClass:(Class)typeClass key:(NSString*)key
{
    // If types match, just return
    if ([*ioValue isKindOfClass:typeClass])
        return YES;
    
    // Otherwise, lets try to fit the desired class type
    // Because *ioValue comes frome a JSON deserialization, it can only be a string, number, array or dictionary.
    
    if ([*ioValue isKindOfClass:NSString.class]) // <-- STRINGS
    {
        if ([typeClass isSubclassOfClass:NSURL.class])
        {
            *ioValue = [NSURL URLWithString:*ioValue];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSData.class])
        {
            *ioValue = [[NSData alloc] initWithBase64EncodedString:*ioValue options:NSDataBase64DecodingIgnoreUnknownCharacters];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSNumber.class])
        {
            NSNumberFormatter *formatter = [NSObject mjz_decimalFormatter];
            *ioValue = [formatter numberFromString:*ioValue];
            return *ioValue != nil;
        }
        if ([typeClass isSubclassOfClass:NSDate.class])
        {
            NSNumberFormatter *formatter = [NSObject mjz_decimalFormatter];
            *ioValue = [formatter numberFromString:*ioValue];
            if (*ioValue == nil) return NO;

            *ioValue = [NSDate dateWithTimeIntervalSince1970:[*ioValue doubleValue]];
            return *ioValue != nil;
        }
    }
    else if ([*ioValue isKindOfClass:NSNumber.class]) // <-- NUMBERS
    {
        if ([typeClass isSubclassOfClass:NSDate.class])
        {
            *ioValue = [NSDate dateWithTimeIntervalSince1970:[*ioValue doubleValue]];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSString.class])
        {
            *ioValue = [*ioValue stringValue];
            return YES;
        }
    }
    else if ([*ioValue isKindOfClass:NSArray.class]) // <-- ARRAYS
    {
        if ([typeClass isSubclassOfClass:NSMutableArray.class])
        {
            *ioValue = [NSMutableArray arrayWithArray:*ioValue];
            return YES;
        }
        else if ([typeClass isSubclassOfClass:NSMutableSet.class])
        {
            *ioValue = [NSMutableSet setWithArray:*ioValue];
            return YES;
        }
        else if ([typeClass isSubclassOfClass:NSSet.class])
        {
            *ioValue = [NSSet setWithArray:*ioValue];
            return YES;
        }
        else if ([typeClass isSubclassOfClass:NSMutableOrderedSet.class])
        {
            *ioValue = [NSMutableOrderedSet orderedSetWithArray:*ioValue];
            return YES;
        }
        else if ([typeClass isSubclassOfClass:NSOrderedSet.class])
        {
            *ioValue = [NSOrderedSet orderedSetWithArray:*ioValue];
            return YES;
        }
    }
    else if ([*ioValue isKindOfClass:NSDictionary.class]) // <-- DICTIONARIES
    {
        if ([typeClass isSubclassOfClass:NSMutableDictionary.class])
        {
            *ioValue = [NSMutableDictionary dictionaryWithDictionary:*ioValue];
            return YES;
        }
        else if ([typeClass isSubclassOfClass:NSObject.class])
        {
            id instance = [[typeClass alloc] init];
            [instance mjz_parseValuesForKeysWithDictionary:*ioValue];
            [self mjz_didCreateObject:instance forKey:key];
            
            *ioValue = instance;
            return YES;
        }
    }
    
    return NO;
}

#pragma mark Helpers

+ (NSNumberFormatter*)mjz_decimalFormatter
{
    static NSNumberFormatter *decimalFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSNumberFormatter *decimalFormatter = [NSNumberFormatter new];
        decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    });
    return decimalFormatter;
}

@end
