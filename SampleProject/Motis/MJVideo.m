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
                                      };
        NSMutableDictionary *mutableMapping = [[super mjz_motisMapping] mutableCopy];
        [mutableMapping addEntriesFromDictionary:JSONMapping];
        mapping = mutableMapping;
    });
    
    return mapping;
}

+ (MJZMotisMappingClearance)mjz_motisMappingClearance
{
    return MJZMotisMappingClearanceRestricted;
}

- (void)mjz_restrictSetValue:(id)value forUndefinedMappingKey:(NSString *)key
{
    NSLog(@"[WARNING]: Undefined mapping key: <%@> value: <%@>. Value has not been setted.", key, [value description]);
}

#pragma mark Motis Validation

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

//- (id)mjz_willCreateObjectForKey:(NSString*)key ofClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary abort:(BOOL*)abort
//{
//    // Subclasses might override.
//    NSLog(@"WILL CREATE: %@ OF CLASS %@", key, NSStringFromClass(typeClass));
//    return nil;
//}

// Automatic validation does the job!
//- (BOOL)validateUploader:(id *)ioValue error:(NSError * __autoreleasing *)outError
//{
//    if ([*ioValue isKindOfClass:[NSDictionary class]])
//    {
//        MJUser *user = [[MJUser alloc] init];
//        [user mjz_parseValuesForKeysWithDictionary:*ioValue];
//        
//        *ioValue = user;
//    }
//    
//    return YES;
//}

// Automatic validation does the job!
//- (BOOL)validateLastViewDate:(id *)ioValue error:(NSError * __autoreleasing *)outError
//{
//    if ([*ioValue isKindOfClass:NSNumber.class])
//    {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[*ioValue doubleValue]];
//        *ioValue = date;
//    }
//    
//    return YES;
//}

// Automatic array validation does the job!
//- (BOOL)mjz_validateArrayObject:(inout __autoreleasing id *)ioValue arrayKey:(NSString *)arrayKey arrayOriginalKey:(NSString *)arrayOriginalKey
//{
//    if ([arrayKey isEqualToString:@"cast"])
//    {
//        if ([*ioValue isKindOfClass:NSDictionary.class])
//        {
//            MJUser *user = [[MJUser alloc] init];
//            [user mjz_parseValuesForKeysWithDictionary:*ioValue];
//            
//            *ioValue = user;
//        }
//    }
//    
//    return YES;
//}

@end
