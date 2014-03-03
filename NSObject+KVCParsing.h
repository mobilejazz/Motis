//
//  NSObject+KVCParsing.h
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

/**
 * Extends NSObject adding parsing capabilities from JSON dictionaries.
 * Objects must override the method `mappingForKVCParsing` method and define the mapping from the JSON keys to the Object property names.
 * To parse and set the object from the JSON dictionary, use the methods `parseValue:forKey:` or `parseValuesForKeysWithDictionary:`.
 * Also, objects can validate values by implementing the KVC validation method `validate<Key>:error:`.
 *
 * Objects also might want to override KVC method `setValue:forUndefinedKey:` to handle undefined keys (and maybe remove the default thrown exception).
 */
@interface NSObject (KVCParsing)

/**
 * If YES, parsing values will trigger KVC-validation. Default value is YES.
 */
@property (nonatomic, readwrite) BOOL validatesKVCParsing;

/**
 * If YES the `-description` method will display the values for the keys specified in method `mappingForKVCParsing`. Default is NO.
 * @return YES if active, NO otherwise.
 */
+ (BOOL)extendObjectDescription;

/**
 * Enable or disable the extendedObjectDescription.
 * @param extendedObjectDescription YES to activate, NO to desactivate
 * @discussion By enabling the extendedObjectDescription, this category implements a swizzeling from the existing `-description` method to a customized one. Subclasses won't be able to override the description method.
 */
+ (void)setExtendObjectDescription:(BOOL)extendObjectDescription;

/**
 * Returns the extended object description.
 * @return The custom extended object description.
 */
- (NSString*)extendedObjectDescription;

/**
 * Returns the mapping to be used in the parsing. The default value is an empty dictionary.
 * @return the mapping in a dictionary.
 * @discussion Subclasses might override this method and specify a custom mapping dictionary. As a good practice, always add the [super mappingForKVCParsing] dictionary inside the custom dictionary.
 */
- (NSDictionary*)mappingForKVCParsing;

/**
 * Parse and set the value for the given key. This method validates the value.
 * @param value The value to parse and set.
 * @param key The key of the attribute to set the value.
 * @discussion This method will check if the key is mappable using the dictionary specified in `mappingForKVCParsing`. Once the key mapped, this method will call the KVC method `setValue:forKey` to set the value. If value is nil or [NSNull null], the method will invoke instead `setNilValueForKey:`.
 */
- (void)parseValue:(id)value forKey:(NSString *)key;

/**
 * Parse and set the key-values of the dictionary. This method will fire validation for each value.
 * @param dictionary The dictionary to parse and set.
 * @discussion This method will call for each dictionary pair key-value the method `parseValue:forKey:`.
 */
- (void)parseValuesForKeysWithDictionary:(NSDictionary *)dictionary;

/**
 * As an extended KVC feature, this method is called to fire the KVC validation automatically (you should not call it). This method calls the KVC validation method `validateValue:forKey:error`. Subclasses may override and use the `parseKey` (the not mapped key) for its own purpuses.
 * @param ioValue The value to be validated
 * @param inKey The name of the key on which the value will be assigned.
 * @param parseKey The original key name, before mapping.
 * @param outError Validation error.
 * @return YES, if value is valid or validated. NO if value not valid.
 * @discussion It is recomended to validate your attributes using overriding the KVC method `validate<Key>:error:` for each attribute to validate.
 */
- (BOOL)validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey parseKey:(NSString*)parseKey error:(out NSError *__autoreleasing *)outError;

@end
