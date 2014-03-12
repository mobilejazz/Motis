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


/* *************************************************************************************************************************************** *
 * KVCParsing Methods
 * *************************************************************************************************************************************** */

#pragma mark - KVCParsing

/**
 * KVCParsing
 *
 * Extends NSObject adding parsing capabilities from JSON dictionaries.
 *
 * To parse and set the object from the JSON dictionary, use the methods `parseValue:forKey:` or `parseValuesForKeysWithDictionary:`.
 * Also, objects can validate values by implementing the KVC validation method `validate<Key>:error:`.
 *
 * Objects also might want to override KVC method `setValue:forUndefinedKey:` to handle undefined keys (and maybe remove the default thrown exception).
 **/
@interface NSObject (KVCParsing)

/** ---------------------------------------------- **
 * @name Parsing Methods
 ** ---------------------------------------------- **/

/**
 * Parse and set the value for the given key. This method validates the value.
 * @param value The value to parse and set.
 * @param key The key of the attribute to set the value.
 * @discussion This method will check if the key is mappable using the dictionary specified in `mappingForKVCParsing`. Once the key mapped, this method will call the KVC method `setValue:forKey` to set the value. If value is nil or [NSNull null], the method will invoke instead `setNilValueForKey:`. If value is an array, `mjz_parseArrayValue:forKey:parseKey:` will be invoked for each object.
 **/
- (void)mjz_parseValue:(id)value forKey:(NSString *)key;

/**
 * Parse and set the key-values of the dictionary. This method will fire validation for each value.
 * @param dictionary The dictionary to parse and set.
 * @discussion This method will call for each dictionary pair key-value the method `parseValue:forKey:`.
 **/
- (void)mjz_parseValuesForKeysWithDictionary:(NSDictionary *)dictionary;

/** ---------------------------------------------- **
 * @name Define Mapping Behaviour
 ** ---------------------------------------------- **/

/**
 * If NO, the parsing methods will only parse the keys defined in `mjz_mappingForKVCParsing`. Undefined keys will be discarded and reported. If YES, any key contained or not in `mjz_mappingForKVCParsing` will be parsed. Default value is NO.
 **/
@property (nonatomic, readwrite) BOOL mjz_allowGenericKVCAccessorsInMapping;

/**
 * Returns the mapping to be used in the parsing. The default value is an empty dictionary.
 * @return the mapping in a dictionary.
 * @discussion Subclasses must override this method and specify a custom mapping dictionary. As a good practice, always add the [super mappingForKVCParsing] dictionary inside the custom dictionary.
 **/
- (NSDictionary*)mjz_mappingForKVCParsing;

/** ---------------------------------------------- **
 * @name Logging objects
 ** ---------------------------------------------- **/

/**
 * Returns the extended object description.
 * @return The custom extended object description.
 **/
- (NSString*)mjz_extendedObjectDescription;

/** ---------------------------------------------- **
 * @name Get notified
 ** ---------------------------------------------- **/

/**
 * Notifies restricted values for undefined mapping keys.
 * @param value The value that has not been setted.
 * @param key The key undefined in the mapping.
 * @discussion This method is only called when `mjz_allowGenericKVCAccessorsInMapping` is set to NO and a undefined mapping key is found.
 **/
- (void)mjz_parseValue:(id)value forUndefinedMappingKey:(NSString*)key;

@end


/* *************************************************************************************************************************************** *
 * KVCParsing Validation
 * *************************************************************************************************************************************** */

#pragma mark - KVCParsing_Validation

/**
 * KVCParsing Object Validation. 
 *
 * While parsing, you can validate your objects just before setting the object properties.
 * You can decide if a value type is correct or not and replace a value with another one.
 *
 * The validation is done via KVC-Validation: you must override the method `validate<Key>:error:` for each key to be validated.
 * Optionally, you can override the generic KVC method 'validateValue:forKey:error:` or the custom method `mjz_validateValue:forKey:originalKey:error:`. A call to `super` must be done for those keys that are not handled.
 *
 * Validation is enabled by default, but you can disable it by setting the property `mjz_validatesKVCParsing` to NO.
 **/
@interface NSObject (KVCParsing_Validation)

/** ---------------------------------------------- **
 * @name Enabling / Disabling validation
 ** ---------------------------------------------- **/

/**
 * If YES, parsing values will trigger KVC-validation. Default value is YES.
 **/
@property (nonatomic, readwrite) BOOL mjz_validatesKVCParsing;

/** ---------------------------------------------- **
 * @name Automatic Validation
 ** ---------------------------------------------- **/

/**
 * If YES, automatic validation is performed before regular KVC validation. Default value is YES.
 * @discussion Automatic validation is only performed if validation is enabled (if `mjz_validatesKVCParsing` is set to YES).
 **/
@property (nonatomic, readwrite) BOOL mjz_automaticKVCParsingValidationEnabled;

/**
 * Return a mapping between the array property name to the contained object class type.
 * For example: @{@"myArrayPropertyName": User.class, ... };
 **/
- (NSDictionary*)mjz_arrayClassTypeMappingForAutomaticKVCParsingValidation;

/**
 * Returns a set of Class items. Each class type included in this set won't be parsed automatically. Default value returns an empty set.
 **/
- (NSSet*)mjz_disabledClassTypesForAutomaticKVCParsingValidation;

/** ---------------------------------------------- **
 * @name Manual Validation
 ** ---------------------------------------------- **/

/**
 * As an extended KVC feature, this method is called to fire the KVC validation automatically (you should not call it). This method calls the KVC validation method `validateValue:forKey:error`. Subclasses may override and use the `parseKey` (the not mapped key) for its own purpuses.
 * @param ioValue The value to be validated. You can replace the value by assigning a new object to the pointer.
 * @param inKey The name of the key on which the value will be assigned.
 * @param originalKey The original key name, before mapping.
 * @param outError Validation error.
 * @return YES, if value is valid or validated. NO if value not valid.
 * @discussion It is recomended to validate your attributes by overriding the KVC method `validate<Key>:error:` for each attribute to be validated.
 **/
- (BOOL)mjz_validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey originalKey:(NSString*)originalKey error:(out NSError *__autoreleasing *)outError;

/**
 * Subclasses may override to parse the objects of array values. The default implementation accepts (return YES) the default value.
 * @param ioValue The value to be validated. You can replace the value by assigning a new object to the pointer.
 * @param arrayKey The name of the key in which the containing array will be assigned.
 * @param arrayOriginalKey The original key, before mapping.
 * @return YES if value is accepted, NO to avoid adding this value inside the array.
 **/
- (BOOL)mjz_validateArrayObject:(inout __autoreleasing id *)ioValue arrayKey:(NSString *)arrayKey arrayOriginalKey:(NSString*)arrayOriginalKey;

@end
