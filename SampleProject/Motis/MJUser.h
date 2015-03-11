//
//  MJUser.h
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

#import <Foundation/Foundation.h>

#import "Motis.h"

typedef NS_ENUM(NSUInteger, MJUserGender)
{
    MJUserGenderUndefined = 0,
    MJUserGenderMale,
    MJUserGenderFemale,
};

typedef NS_ENUM(NSUInteger, MJAwesomenessLevel)
{
    MJAwesomenessLevelZero = 0,
    MJAwesomenessLevelOne,
    MJAwesomenessLevelTwo,
    MJAwesomenessLevelThree,
};

@interface MJUser : NSObject

@property (nonatomic, assign) NSNumber *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger followers;

@property (nonatomic, assign) MJUserGender gender;
@property (nonatomic, assign) MJAwesomenessLevel awesomenessLevel;

@end
