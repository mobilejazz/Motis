//
//  MJUser.m
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

#import "MJUser.h"

#import "Motis.h"

@implementation MJUser

+ (NSDictionary*)mts_mapping
{
    return  @{@"user_name": mts_key(username),
              @"user_id": mts_key(userId),
              @"followers": mts_key(followers),
              @"user_gender": mts_key(gender),
              @"awesomeness_level": mts_key(awesomenessLevel),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

+ (NSDictionary*)mts_valueMappingForKey:(NSString*)key
{
    if ([key isEqualToString:mts_key(gender)])
    {
        return @{@"male": @(MJUserGenderMale),
                 @"female": @(MJUserGenderFemale),
                 MTSDefaultValue: @(MJUserGenderUndefined),
                 };
    }
    else if ([key isEqualToString:mts_key(awesomenessLevel)])
    {
        return @{@1: @(MJAwesomenessLevelZero),
                 @2: @(MJAwesomenessLevelOne),
                 @3: @(MJAwesomenessLevelTwo),
                 @4: @(MJAwesomenessLevelThree),
                 MTSDefaultValue: @(MJAwesomenessLevelOne),
                 };
    }
    
    return nil;
}

@end
