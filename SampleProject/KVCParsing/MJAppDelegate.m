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

#import "MJVideo.h"
#import "MJUser.h"

#import "NSObject+KVCParsing.h"

@implementation MJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self performKVCParsingTest];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = [[UIViewController alloc] init];
    window.backgroundColor = [UIColor whiteColor];
    
    self.window = window;
    [window makeKeyAndVisible];
    
    return YES;
}

#pragma mark Private Methods

- (void)performKVCParsingTest
{
    // Defining a JSONDictionary
    NSDictionary *JSONDict = @{@"video_id": @42,
                               @"view_count": @723,
                               @"title": @"Flirting with Mobile Jazz",
                               @"description": @"Lorem ipsum sir dolor amet.",
                               @"last_view_time": @1390767064.0,
                               @"uploader":@{@"user_name":@"vilanovi",
                                             @"user_id": @7,
                                             @"followers": @209
                                             }
                               };
    
    // Converting the dictionary to real JSON data
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSONDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON STR: %@", jsonStr);
    
    // Reverting the JSONData to a dictionary. Here is where we emulate the reading from a JSON source.
    NSDictionary *receivedJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    // Create an instance of a KVC paraseable object
    MJVideo *video = [[MJVideo alloc] init];
    
    NSLog(@"Video before parsing: %@", video.mj_extendedObjectDescription);
    [video mj_parseValuesForKeysWithDictionary:receivedJSONDict];
    NSLog(@"Video after parsing: %@", video.mj_extendedObjectDescription);
}

@end
