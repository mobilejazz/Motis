//
//  MJVideo.h
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

@class MJUser;

@interface MJVideo : NSObject

@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, assign) NSInteger viewCount;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *videoDescription;

@property (nonatomic, strong) NSDate *lastViewDate;

@property (nonatomic, strong) MJUser *uploader;

@end
