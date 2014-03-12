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

#import "NSObject+KVCParsing.h"

@implementation MJVideo

#pragma mark KVCParsing Subclassing

- (NSDictionary*)mjz_mappingForKVCParsing
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
        
        
        NSDictionary *superMapping = [super mjz_mappingForKVCParsing];
        
        NSMutableDictionary *theMapping = [NSMutableDictionary dictionary];
        
        [theMapping addEntriesFromDictionary:superMapping];
        [theMapping addEntriesFromDictionary:JSONMapping];
        
        mapping = [theMapping copy];
    });
    
    return mapping;
}

- (void)mjz_restrictedValue:(id)value forUndefinedMappingKey:(NSString *)key
{
    NSLog(@"[WARNING]: Undefined mapping key: <%@> value: <%@>. Value has not been setted.", key, [value description]);
}

#pragma mark KVCParsing Validation

// Automatic array validation mapping
- (NSDictionary*)mjz_arrayClassTypeMappingForAutomaticKVCParsingValidation
{
    static NSDictionary *mapping = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *arrayMapping = @{NSStringFromSelector(@selector(cast)) : MJUser.class,
                                      };
        
        NSDictionary *superMapping = [super mjz_mappingForKVCParsing];
        
        NSMutableDictionary *theMapping = [NSMutableDictionary dictionary];
        
        [theMapping addEntriesFromDictionary:superMapping];
        [theMapping addEntriesFromDictionary:arrayMapping];
        
        mapping = [theMapping copy];
    });
    
    return mapping;
}

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
