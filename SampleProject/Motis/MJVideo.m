//
//  MJVideo.m
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

#import "MJVideo.h"
#import "MJUser.h"

#import "NSObject+Motis.h"

@implementation MJVideo

#pragma mark Motis Subclassing

// JSON keys to object properties mapping
- (NSDictionary*)mjz_motisMapping
{
    static NSDictionary *mapping = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *JSONMapping = @{@"video_id": NSStringFromSelector(@selector(videoId)),
                                      @"view_count": NSStringFromSelector(@selector(viewCount)),
                                      @"title": NSStringFromSelector(@selector(title)),
                                      @"description": NSStringFromSelector(@selector(videoDescription)),
                                      @"last_view_time": NSStringFromSelector(@selector(lastViewDate)),
                                      @"uploader": NSStringFromSelector(@selector(uploader)),
                                      @"users_cast": NSStringFromSelector(@selector(cast)),
                                      @"likes_count": NSStringFromSelector(@selector(likesCount)),
                                      };
        NSMutableDictionary *mutableMapping = [[super mjz_motisMapping] mutableCopy];
        [mutableMapping addEntriesFromDictionary:JSONMapping];
        mapping = mutableMapping;
    });
    
    return mapping;
}

// Automatic array validation mapping
- (NSDictionary*)mjz_motisArrayClassMapping
{
    static NSDictionary *mapping = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *arrayMapping = @{NSStringFromSelector(@selector(cast)) : MJUser.class,
                                       };
        NSMutableDictionary *mutableMapping = [[super mjz_motisArrayClassMapping] mutableCopy];
        [mutableMapping addEntriesFromDictionary:arrayMapping];
        mapping = mutableMapping;
    });
    
    return mapping;
}

// Only accept values from the mapping
+ (BOOL)mjz_motisShouldSetUndefinedKeys
{
    return NO;
}

// Log undefined mapping keys
- (void)mjz_restrictSetValue:(id)value forUndefinedMappingKey:(NSString *)key
{
    NSLog(@"[%@] Undefined mapping key: <%@> value: <%@>. Value has not been set.", [self.class description], key, [value description]);
}

// This method is called when received "null" in non-object types.
- (void)mjz_nullValueForKey:(NSString *)key
{
    NSLog(@"[%@] Null value received for key: %@. Value should be manually set.",[self.class description], key);
    
    if ([key isEqualToString:@"likesCount"])
        _likesCount = -1; // <-- Generic default value
}

@end
