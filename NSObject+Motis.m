//
//  NSObject+Motis.m
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

#import "NSObject+Motis.h"
#import <objc/runtime.h>

#define MOTIS_DEBUG 0

#if MOTIS_DEBUG
#define MLog(format, ...) NSLog(@"%@",[NSString stringWithFormat:format, ## __VA_ARGS__]);
#else
#define MLog(format, ...)
#endif


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - Motis_Private

@interface NSObject (Motis_Private)

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
- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue toClass:(Class)typeClass forKey:(NSString*)key;

@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - Motis

@implementation NSObject (Motis)

#pragma mark Public Methods

- (void)mjz_setValue:(id)value forKey:(NSString *)key
{
    NSString *mappedKey = [self mjz_mapKey:key];
    
    if (!mappedKey)
    {
        [self mjz_restrictSetValue:value forUndefinedMappingKey:key];
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
                Class typeClass = self.mjz_motisArrayClassMapping[mappedKey];
                if (typeClass)
                {
                    validated = [self mjz_validateAutomaticallyValue:&validatedObject toClass:typeClass forKey:mappedKey];
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

- (void)mjz_setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    for (NSString *key in keyedValues)
    {
        id value = keyedValues[key];
        [self mjz_setValue:value forKey:key];
    }
}

- (NSString*)mjz_extendedObjectDescription
{
    NSString *description = self.description;
    NSArray *keys = [[self mjz_motisMapping] allValues];
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
    NSString *mappedKey = [[self mjz_motisMapping] valueForKey:key];
    
    if (mappedKey)
        return mappedKey;
    
    if ([self.class mjz_motisShouldSetUndefinedKeys])
        return key;
    
    return nil;
}

@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - Motis_Subclassing

@implementation NSObject (Motis_Subclassing)


- (NSDictionary*)mjz_motisMapping
{
    // Subclasses must override, always adding super to the mapping!
    return @{};
}

+ (BOOL)mjz_motisShouldSetUndefinedKeys
{
    // Subclasses might override.
    return YES;
}

- (NSDictionary*)mjz_motisArrayClassMapping
{
    // Subclasses might override.
    return @{};
}

- (id)mjz_willCreateObjectOfClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary forKey:(NSString*)key abort:(BOOL*)abort;
{
    // Subclasses might override.
    return nil;
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

- (void)mjz_restrictSetValue:(id)value forUndefinedMappingKey:(NSString*)key
{
    // Subclasses might override.
    MLog(@"Undefined Mapping Key <%@> in class %@.", key, [self.class description]);
}

- (void)mjz_invalidValue:(id)value forKey:(NSString *)key error:(NSError*)error
{
    // Subclasses might override.
    MLog(@"Value for Key <%@> is not valid in class %@. Error: %@", key, [self.class description], error);
}

- (void)mjz_invalidValue:(id)value forArrayKey:(NSString *)key error:(NSError*)error
{
    // Subclasses might override.
    MLog(@"Item for ArrayKey <%@> is not valid in class %@. Error: %@", key, [self.class description], error);
}

@end


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------ //


#pragma mark - Motis_Private

@implementation NSObject (Motis_Private)

- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue forKey:(NSString*)key
{
    objc_property_t property = class_getProperty(self.class, key.UTF8String);
    
    const char * type = property_getAttributes(property);
    
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) // if property is a pointer to a class
    {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        Class typeClass = NSClassFromString(typeClassName);
        
        if (typeClass != nil)
        {
            MLog(@"%@ --> %@", key, typeClassName);
            return [self mjz_validateAutomaticallyValue:ioValue toClass:typeClass forKey:key];
        }
        
        return NO;
    }
    else // if property is a basic type
    {
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        
        if ([*ioValue isKindOfClass:NSNumber.class])
        {
            // Conversion from NSNumber to basic types is already handled by the system.
            return YES;
        }
        else if ([*ioValue isKindOfClass:NSString.class])
        {
            if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
            {
                if ([*ioValue isKindOfClass:NSString.class])
                {
                    MLog(@"NSString --> BOOL", key);
                    BOOL premium = [*ioValue boolValue];
                    *ioValue = @(premium);
                }
            }
            
            // Other conversions from NSString to basic types are already handled by the system.
            
            return YES;
        }
        else // If not a number and not a string, types cannot match.
        {
            return NO;
        }
    }
}

- (BOOL)mjz_validateAutomaticallyValue:(inout __autoreleasing id *)ioValue toClass:(Class)typeClass forKey:(NSString*)key
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
            return *ioValue != nil;
        }
    }
    else if ([*ioValue isKindOfClass:NSArray.class]) // <-- ARRAYS
    {
        if ([typeClass isSubclassOfClass:NSMutableArray.class])
        {
            *ioValue = [NSMutableArray arrayWithArray:*ioValue];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSMutableSet.class])
        {
            *ioValue = [NSMutableSet setWithArray:*ioValue];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSSet.class])
        {
            *ioValue = [NSSet setWithArray:*ioValue];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSMutableOrderedSet.class])
        {
            *ioValue = [NSMutableOrderedSet orderedSetWithArray:*ioValue];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSOrderedSet.class])
        {
            *ioValue = [NSOrderedSet orderedSetWithArray:*ioValue];
            return *ioValue != nil;
        }
    }
    else if ([*ioValue isKindOfClass:NSDictionary.class]) // <-- DICTIONARIES
    {
        if ([typeClass isSubclassOfClass:NSMutableDictionary.class])
        {
            *ioValue = [NSMutableDictionary dictionaryWithDictionary:*ioValue];
            return *ioValue != nil;
        }
        else if ([typeClass isSubclassOfClass:NSObject.class])
        {
            BOOL abort = NO;
            id instance = [self mjz_willCreateObjectOfClass:typeClass withDictionary:*ioValue forKey:key abort:&abort];

            if (abort)
                return NO;
            
            if (!instance)
            {
                instance = [[typeClass alloc] init];
                [instance mjz_setValuesForKeysWithDictionary:*ioValue];
            }
            
            [self mjz_didCreateObject:instance forKey:key];
            
            *ioValue = instance;
            return *ioValue != nil;
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
        decimalFormatter = [NSNumberFormatter new];
        decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    });
    return decimalFormatter;
}

@end
