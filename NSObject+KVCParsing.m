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

static char const * const validatesKVCParsingKey = "MJKVCParsing_validatesKVCParsing";

@implementation NSObject (KVCParsing)

- (void)setMjz_validatesKVCParsing:(BOOL)validateKVCParsing
{
    objc_setAssociatedObject(self, validatesKVCParsingKey, @(validateKVCParsing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mjz_validatesKVCParsing
{
    NSNumber *value = objc_getAssociatedObject(self, validatesKVCParsingKey);
    
    if (!value)
    {
        BOOL defaultValue = YES;
        self.mjz_validatesKVCParsing = defaultValue;
        return defaultValue;
    }
    
    return [value boolValue];
}

#pragma mark Public Methods

- (NSDictionary*)mjz_mappingForKVCParsing
{
    // Subclasses may override, always adding super to the mapping!
    return @{};
}

- (void)mjz_parseValue:(id)value forKey:(NSString *)key
{
    NSString *mappedKey = [self mjz_mapKey:key];
    
    NSError *error = nil;
    BOOL validated = YES;
    
    if (self.mjz_validatesKVCParsing)
        validated =[self mjz_validateValue:&value forKey:mappedKey parseKey:key error:&error];
    
    if (validated)
    {
        if (value != [NSNull null] && value != nil)
            [self setValue:value forKey:mappedKey];
        else
            [self setNilValueForKey:mappedKey];
    }
    else
    {
        NSLog(@"%s :: Value for Key <%@>  is not valid in class %@. Error: %@", __PRETTY_FUNCTION__, key, [self.class description], error);
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

- (BOOL)mjz_validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey parseKey:(NSString*)parseKey error:(out NSError *__autoreleasing *)outError
{
    return [self validateValue:ioValue forKey:inKey error:outError];
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
    
    return key;
}

@end
