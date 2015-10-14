//
//  MTSSerializableObject.h
//  Copyright 2015 Mobile Jazz
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

/**
 * This class is a helper that allow to use NSCoding and NSCopying reusing the Motis mapping definitions.
 * This behavior will only apply to properties defined inside a Motis mapping (`+mts_mapping`).
 *
 * NOTE: This class is not needed to perform JSON mapping as the category NSObject+Motis can do it over any NSObject.
 *
 * To use it, subclass this class and define the Motis mapping.
 * List of used properties can be extended by subclassing the method `+mts_motisPropertyNames`.
 **/
@interface MTSMotisObject : NSObject <NSCoding, NSCopying>

@end

/**
 * Subclasses can optionally override the methods listed in this category.
 **/
@interface MTSMotisObject (Subclassing)

/**
 * Returns the list of Motis properties that will be used for NSCoding and NSCopying.
 *
 * @discussion
 * Subclasses can override this method and return a different subset of properties.
 * Default implementation return property names defined in the Motis Mapping (`+mts_mapping`).
 **/
+ (NSArray*)mts_motisPropertyNames;

@end