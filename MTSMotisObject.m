//
//  MTSSerializableObject.m
//  Copyright 2015 Mobile Jazz
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

#import "MTSMotisObject.h"

@implementation MTSMotisObject

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSArray *persistentKeys = [self.class mts_motisPropertyNames];
        
        for (NSString *key in persistentKeys)
        {
            id value = [aDecoder decodeObjectForKey:key];
            
            if (value)
                [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *persistentKeys = [self.class mts_motisPropertyNames];
    
    for (NSString *key in persistentKeys)
    {
        id value = [self valueForKey:key];
        if (value)
            [aCoder encodeObject:value forKey:key];
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    id object = [[self.class alloc] init];
    
    NSArray *persistentKeys = [self.class mts_motisPropertyNames];
    for (NSString *key in persistentKeys)
    {
        id value = [self valueForKey:key];
        if (value)
            [object setValue:value forKey:key];
    }
    
    return object;
}

@end


@implementation MTSMotisObject (Subclassing)

+ (NSArray*)mts_motisPropertyNames
{
    return [self.class mts_motisKeys];
}

#pragma mark Private Methods

+ (NSArray*)mts_motisKeys
{
    static NSMutableDictionary *classKeys = nil;
    
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        classKeys = [NSMutableDictionary dictionary];
    });
    
    NSString *className = NSStringFromClass(self);
    NSArray *keys = classKeys[className];
    
    if (!keys)
    {
        Class superClass = [self superclass];
        
        NSMutableArray *array = nil;
        
        if ([superClass isSubclassOfClass:MTSMotisObject.class])
            array = [[superClass mts_motisKeys] mutableCopy];
        else
            array = [NSMutableArray array];
        
        [array addObjectsFromArray:[[self mts_mapping] allValues]];
        
        keys = [array copy];
        classKeys[className] = keys;
    }
    return keys;
}

@end
