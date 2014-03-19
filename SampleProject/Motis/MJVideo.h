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

/** ********************************************************* **
 *  @name JSON Entity Attributes
 ** ********************************************************* **/

/**
 * Object modeling a video entity.
 **/
@interface MJVideo : NSObject

/**
 * The entity server-side identifier.
 **/
@property (nonatomic, assign) NSInteger videoId;

/**
 * Number of video views.
 **/
@property (nonatomic, assign) NSInteger viewCount;

/**
 * Title of the video.
 **/
@property (nonatomic, strong) NSString *title;

/**
 * Description of the video.
 **/
@property (nonatomic, strong) NSString *videoDescription;

/**
 * Last view date.
 **/
@property (nonatomic, strong) NSDate *lastViewDate;

/**
 * The uploader of the video.
 **/
@property (nonatomic, strong) MJUser *uploader;

/**
 * Cast of the video: array of users appearing in the video.
 **/
@property (nonatomic, strong) NSArray *cast;

/** ********************************************************* **
 *  @name Other attributes
 ** ********************************************************* **/

/**
 * This property is an example of non-JSON field. It is not included in the mapping defined in `mjz_motisMapping`.
 * However, for test purposes, the JSON will include a field of generic type (can be any type) with that key. 
 * Our goal is to avoid setting the property.
 **/
@property (nonatomic, strong) NSString *privateVideoKey;


@end
