//
//  MJAppDelegate.m
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

#import "MJAppDelegate.h"

#import "Motis.h"

#if PERFORMANCE_TEST
#import "MJPerformanceTest.h"
#else
#import "MJVideo.h"
#import "MJUser.h"
#endif

@implementation MJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if PERFORMANCE_TEST
    [self testMotisPerformance];
#else
    [self testMotis]; // <--- UNCOMMENT FOR TESTING
#endif
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = [[UIViewController alloc] init];
    window.backgroundColor = [UIColor whiteColor];
    
    self.window = window;
    [window makeKeyAndVisible];
    
    return YES;
}

#pragma mark Private Methods

#if PERFORMANCE_TEST

- (void)testMotisPerformance
{
    MJPerformanceTest *test = [[MJPerformanceTest alloc] init];
    [test start];
}

#else

- (void)testMotis
{
    // Defining a JSONDictionary
    NSDictionary *JSONDict = @{@"video_id": @"42",
                               @"view_count": @723,
                               @"title": @"Dancing worldwide",
                               @"description": @"Dancing worldwide is the awesomest video ever!",
                               @"last_view_time": @1390767064.0,
                               @"stats": @{@"start_views": @321,
                                           @"end_views": @123,
                                           @"info": @{@"identifier": @"pDL39Ksn3",
                                                      @"date": @1390767064.0,
                                                     },
                                           },
                               @"likes_count": [NSNull null],
                               @"uploader":@{@"user_name":@"Joan",
                                             @"user_id": @7,
                                             @"followers": @209
                                             },
                               @"users_cast":@[@{@"user_name":@"Stefan",
                                                 @"user_id": @19,
                                                 @"followers": @1209
                                                 },
                                               @{@"user_name":@"Hermes",
                                                 @"user_id": @23,
                                                 @"followers": @1455
                                                 },
                                               @{@"user_name":@"Jordi",
                                                 @"user_id": @14,
                                                 @"followers": @452
                                                 },
                                               ],
                               @"privateVideoKey": @(1234), // <-- simulating an unexpected attribute in the JSON
                               };
    
    // Converting the dictionary to real JSON data
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSONDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON STR: %@", jsonStr);
    
    // Reverting the JSONData to a dictionary. Here is where we emulate the reading from a JSON source.
    NSDictionary *receivedJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    // Create an instance of a KVC paraseable object
    MJVideo *video = [[MJVideo alloc] init];
    
    // Setting any value for testing purposes.
    video.privateVideoKey = @"my_private_key";
    video.likesCount = 21;
    
    NSLog(@"BEFORE parsing: %@", video.mts_extendedObjectDescription);
    NSLog(@"video.privateVideoKey: %@",[video.privateVideoKey description]);
    
    [video mts_setValuesForKeysWithDictionary:receivedJSONDict];
    
    NSLog(@"AFTER parsing: %@", video.mts_extendedObjectDescription);
    NSLog(@"video.privateVideoKey: %@",[video.privateVideoKey description]);
}
#endif

@end
