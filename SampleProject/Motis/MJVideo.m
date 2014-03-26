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
+ (NSDictionary*)mts_motisMapping
{
    return @{@"video_id": NSStringFromSelector(@selector(videoId)),
             @"view_count": NSStringFromSelector(@selector(viewCount)),
             @"title": NSStringFromSelector(@selector(title)),
             @"description": NSStringFromSelector(@selector(videoDescription)),
             @"last_view_time": NSStringFromSelector(@selector(lastViewDate)),
             @"uploader": NSStringFromSelector(@selector(uploader)),
             @"users_cast": NSStringFromSelector(@selector(cast)),
             @"likes_count": NSStringFromSelector(@selector(likesCount)),
             };
}

// Automatic array validation mapping
+ (NSDictionary*)mts_motisArrayClassMapping
{
    return @{NSStringFromSelector(@selector(cast)) : MJUser.class};
}

// Only accept values from the mapping
+ (BOOL)mts_motisShouldSetUndefinedKeys
{
    return NO;
}

// Log undefined mapping keys
- (void)mts_restrictSetValue:(id)value forUndefinedMappingKey:(NSString *)key
{
    NSLog(@"[%@] Undefined mapping key: <%@> value: <%@>. Value has not been set.", [self.class description], key, [value description]);
}

// This method is called when received "null" in non-object types.
- (void)mts_nullValueForKey:(NSString *)key
{
    NSLog(@"[%@] Null value received for key: %@. Value should be manually set.",[self.class description], key);
    
    if ([key isEqualToString:@"likesCount"])
        _likesCount = -1; // <-- Generic default value
}


#pragma mark Validation
//
//- (BOOL)mts_validateUser:(inout __autoreleasing id *)ioValue error:(out NSError *__autoreleasing *)outError
//{
//    if ([*ioValue isKindOfClass:MJUser.class])
//    {
//        return YES;
//    }
//    else if ([*ioValue isKindOfClass:NSDictionary.class])
//    {
//        MJUser *user = [[MJUser alloc] init];
//        [user mts_setValuesForKeysWithDictionary:*ioValue];
//        *ioValue = user;
//        
//        return *ioValue != nil;
//    }
//    
//    return NO;
//}
//
//- (BOOL)validateUploader:(inout __autoreleasing id *)ioValue error:(out NSError *__autoreleasing *)outError
//{
//    return [self mts_validateUser:ioValue error:outError];
//}
//
//- (BOOL)validateCast:(inout __autoreleasing id *)ioValue error:(out NSError *__autoreleasing *)outError
//{
//    if ([*ioValue isKindOfClass:NSArray.class])
//    {
//        __block NSMutableArray *array = nil;
//        
//        [*ioValue enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            if ([obj isKindOfClass:MJUser.class])
//            {
//                // Nothing to do
//            }
//            else
//            {
//                if (!array)
//                    array = [*ioValue mutableCopy];
//                
//                id object = obj;
//                BOOL valid = [self mts_validateUser:&object error:nil];
//                
//                if (valid)
//                    [array replaceObjectAtIndex:idx withObject:object];
//                else
//                    [array removeObjectAtIndex:idx];
//            }
//        }];
//        
//        if (array)
//            *ioValue = [array copy];
//
//        return YES;
//    }
//    
//    return NO;
//}
//
//- (BOOL)mts_validateArrayObject:(inout __autoreleasing id *)ioValue forArrayKey:(NSString *)arrayKey error:(out NSError *__autoreleasing *)outError
//{
//    if ([arrayKey isEqualToString:@"cast"])
//    {
//        return [self mts_validateUser:ioValue error:outError];
//    }
//    
//    return NO;
//}

@end
