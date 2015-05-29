//
//  NSObject+Motis.h
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
 * MACROS
 * *************************************************************************************************************************************** */

/**
 * Use the mts_key(name) macro to create strings for property names.
 **/
#define mts_key(name) NSStringFromSelector(@selector(name))

/**
 * Use this value to define a default value in the value mapping.
 **/
#define MTSDefaultValue [NSNull null]

/* *************************************************************************************************************************************** *
 * Motis Methods
 * *************************************************************************************************************************************** */

#pragma mark - Motis

/**
 * Extends NSObject adding parsing capabilities from JSON dictionaries.
 * To parse and set the object from the JSON dictionary, use the methods `mts_setValue:forKey:` or `mts_setValuesForKeysWithDictionary:`.
 **/
@interface NSObject (Motis)

/** ---------------------------------------------- **
 * @name Object Mapping Methods
 ** ---------------------------------------------- **/

/**
 * Parse and set the value for the given key. This method validates the value.
 * @param value The value to parse and set.
 * @param key The key of the attribute to set the value.
 * @discussion This method will check if the key is mappable using the dictionary specified in `mts_motisMapping`. Once the key mapped, this method will call the KVC method `setValue:forKey` to set the value. If value is nil or [NSNull null], the method will invoke instead `setNilValueForKey:`. If value is an array, `mts_parseArrayValue:forKey:parseKey:` will be invoked for each object.
 **/
- (void)mts_setValue:(id)value forKey:(NSString *)key;

/**
 * Parse and set the key-values of the dictionary. This method will fire validation for each value.
 * @param dictionary The dictionary to parse and set.
 * @discussion This method will call for each dictionary pair key-value the method `mts_setValue:forKey:`.
 **/
- (void)mts_setValuesForKeysWithDictionary:(NSDictionary *)dictionary;

/** ---------------------------------------------- **
 * @name Key-Mapping Getters
 ** ---------------------------------------------- **/

/**
 * Retrieve an object value for a given key. The key is mapped via the motis mapping.
 * @param key The key (will be mapped)
 * @return The corresponding value for the given key if available, otherwise nil.
 **/
- (id)mts_valueForKey:(NSString*)key __attribute((deprecated("This method will be removed from Motis in a future version.")));

/**
 * Returns a dictionary containing the given keys and the corresponding values.
 * @param keys An array with keys.
 * @return The dictionary with key-values.
 * @discussion 
 * This method uses the motis mapping to retrieve the values for the given keys. The keys used in the returned dictionary are the ones specified in the given array.
 * WARNING: this method may not return a JSON serializable dictionary, just returns the object values.
 **/
- (NSDictionary*)mts_dictionaryWithValuesForKeys:(NSArray *)keys __attribute((deprecated("This method will be removed from Motis in a future version.")));

/** ---------------------------------------------- **
 * @name Logging objects
 ** ---------------------------------------------- **/

/**
 * Returns the extended object description.
 * @return The custom extended object description.
 **/
- (NSString*)mts_extendedObjectDescription __attribute((deprecated("Use mts_desription instead.")));

/**
 * Returns the Motis description of the object by enumerating all Motis values recursively.
 * @return The Motis descripton of the object.
 * @discussion This Method describes all objects as well as content of arrays, sets and dictionaries by calling mts_description recursively.
 **/
- (NSString*)mts_description;

@end

/*
 * MOTIS AUTOMATIC VALIDATION
 *
 * Motis object mapping adds automatic validation for your properties. This means the system will try to convert into your property type the input value.
 * The following table indicates the supported validations in the current version:
 *
 +------------+---------------------+------------------------------------------------------------------------------------+
 | JSON Type  | Property Type       | Comments                                                                           |
 +------------+---------------------+------------------------------------------------------------------------------------+
 | string     | NSString            | No validation is requried                                                          |
 | number     | NSNumber            | No validation is requried                                                          |
 | number     | basic type (1)      | No validation is requried                                                          |
 | array      | NSArray             | No validation is requried                                                          |
 | dictionary | NSDictionary        | No validation is requried                                                          |
 | -          | -                   | -                                                                                  |
 | string     | bool                | string parsed with method -boolValue and by comparing with "true" and "false"      |
 | string     | unsigned long long  | string parsed with NSNumberFormatter (allowFloats disabled)                        |
 | string     | basic types (2)     | value generated automatically by KVC (NSString's '-intValue', '-longValue', etc)   |
 | string     | NSNumber            | string parsed with method -doubleValue                                             |
 | string     | NSURL               | created using [NSURL URLWithString:]                                               |
 | string     | NSData              | attempt to decode base64 encoded string                                            |
 | string     | NSDate              | default date format "2011-08-23 10:52:00". Check '+mts_validationDateFormatter.'   |
 | -          | -                   | -                                                                                  |
 | number     | NSDate              | timestamp since 1970                                                               |
 | number     | NSString            | string by calling NSNumber's '-stringValue'                                        |
 | -          | -                   | -                                                                                  |
 | array      | NSMutableArray      | creating new instance from original array                                          |
 | array      | NSSet               | creating new instance from original array                                          |
 | array      | NSMutableSet        | creating new instance from original array                                          |
 | array      | NSOrderedSet        | creating new instance from original array                                          |
 | array      | NSMutableOrderedSet | creating new instance from original array                                          |
 | -          | -                   | -                                                                                  |
 | dictionary | NSMutableDictionary | creating new instance from original dictionary                                     |
 | dictionary | custom NSObject     | Motis recursive call. Check '-mts_willCreateObject..' and '-mtd_didCreateObject:'  |
 | -          | -                   | -                                                                                  |
 | null       | nil                 | if property is type object                                                         |
 | null       | <UNDEFINED>         | if property is basic type (3). Check KVC method '-setNilValueForKey:'              |
 +------------+---------------------+------------------------------------------------------------------------------------+
 *
 * basic type (1) : int, unsigned int, long, unsigned long, long long, unsigned long long, float, double)
 * basic type (2) : int, unsigned int, long, unsigned long, float, double)
 * basic type (3) : any basic type (non-object type).
 *
 */

/* *************************************************************************************************************************************** *
 * Motis Subclassing
 * *************************************************************************************************************************************** */

#pragma mark - Motis_Subclassing

/**
 * Motis Object Subclassing
 *
 * OBJECT MAPPINGS
 *
 * In order to use Motis you must define mappings between JSON keys and object properties by overriding the following methods:
 *
 *  - `+mts_mapping`: Subclasses must override this method and return the mapping between the JSON keys and the object properties. The mapping may contain KeyPath to JSON values.
 *  - `+mts_shouldSetUndefinedKeys`: Optionally, subclasses can override this method to forbid Motis from automatically setting keys not found in the mapping. The default is `NO`, except if you have not defined any mots mapping on the method `+mts_mapping`, in which case will return `YES`.
 *
 * VALIDATION METHODS
 *
 * To support automatic validation you must override:
 *
 *  - `+mts_arrayClassMapping`: If your objects has properties of type `NSArray`, override this method and define a mapping between the array property name and the expected content object class.
 *
 * However, you can validate manually any value before the automatic validation is done. If you implements manually validation for a property, the system won't perform the automatic validation.
 * To implement manual validation you must override:
 *
 *  - `-validate<Key>:error:` For each property to manually validate implement this method with <Key> being the name of the object property. This is a KVC validation method.
 *  - `-mts_validateArrayObject:forArrayKey:`: For those property of type array, implement this method to validate their content.
 *
 * OTHER METHODS TO SUBCLASS
 *
 *  - `-setValue:forUndefinedKey:`: KVC Method to handle undefined keys. By default this method throws an exception. This method is called when a setting a value for an unknown key.
 *  - `-setNilValueForKey:`: KVC Method to nullify a basic type property. By default this method throws an exception. This method is called when a json field with value "null" is received.
 *  - `-mts_ignoredSetValue:forUndefinedMappingKey`: If undefined keys are disabled (`mts_motisShouldSetUndefinedKeys`), this method will be called when a undefined mapping key is found.
 *  - `-mts_invalidValue:forKey:error:`: If value is does not pass valiation, this method is called after aborting the value setting.
 *  - `-mts_invalidValue:forArrayKey:error:`: if an array item does not pass validation, this method is called after aborting the item setting.
 *  - `-mts_checkValueOfKeyForEqualityBeforeAssignment:`: if Motis should avoid calling `-setValue:forKey:` when `-isEqual:` is true.
 **/
@interface NSObject (Motis_Subclassing)

/** ---------------------------------------------- **
 * @name Object Mappings
 ** ---------------------------------------------- **/

/**
 * Returns the mapping to be used in the object mapping stage. The default value is an empty dictionary.
 * @return the mapping in a dictionary.
 * @discussion Subclasses must override this method and specify a custom mapping dictionary for their class level. When needed, motis will collect all mapping dictionaries from each subclass level in the class hierarchy and create the overall mapping. The returned mapping will be cached.
 **/
+ (NSDictionary*)mts_mapping;

/**

 * Returns whether Motis should set keys not found in the mapping. Default value is `NO`. However, if no mapping is defined this method is ignored and Motis will attempt to set values for any key.
 * @return `YES` if Motis should set undefined mapping keys, `NO` if only the keys defined `+mts_mapping` can be set.
 * @discussion Subclasses may override to return `YES`. Remember that when setting values for undefined keys KVC will rise an exception which you can remove by overriding the KVC method `-setValue:forUndefinedKey:.
 **/
+ (BOOL)mts_shouldSetUndefinedKeys;

/** ---------------------------------------------- **
 * @name Automatic Validation
 ** ---------------------------------------------- **/

/**
 * Return a mapping for enum types.
 * @param key The key of the property.
 * @return The dictionary with the enumeration mapping for the given key.
 * @discussion Using this method it is possible to convert the value received via the mapping.
 **/
+ (NSDictionary*)mts_valueMappingForKey:(NSString*)key;

/**
 * Return a mapping between the array property name to the contained object class type.
 * For example: @{@"myArrayPropertyName": User.class, ... };
 * @return A dictionary with the array content mapping. When needed, motis will collect all mapping dictionaries from each subclass level in the class hierarchy and create the overall mapping.
 **/
+ (NSDictionary*)mts_arrayClassMapping;

/**
 * While validating automatically your JSON objects, Motis object mapping might create new objects. This method is called just before new objects are created.
 * @param typeClass The object class. A new object of this class is going to be created.
 * @param dictionary The JSON-based dictionary which will be parsed into the new object.
 * @param key The property name of the object to assign or the array name where the object will belong to.
 * @param abort A flag boolean. Return YES if you want to abort (because of dictionary incoherences, for example). When aborting the object is not setted or included inside an array.
 * @return A custom object or nil.
 * @discussion If you return nil, Motis object mapping will create automatically the new instance of class typeClass and parse the dictionary into it. Optionally, you can create the object and parse the dictionary manually. You must return the custom object as a return value of this method.
 **/
- (id)mts_willCreateObjectOfClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary forKey:(NSString*)key abort:(BOOL*)abort;

/**
 * The newer created object for the given key.
 * @param object The new object.
 * @param key The property name of the object or the array name where the object belongs to.
 **/
- (void)mts_didCreateObject:(id)object forKey:(NSString *)key;

/**
 * Returns a date formatter for automatic validation from string to date (default is nil).
 * @return The date formatter.
 * @discussion The default date formatter format is nil, meaning that strings will be validated into dates only if they represent a timestamp. Subclasses can override this method and provide a custom date formatter. If different keys have different date formats, you must validate manually the property.
 **/
+ (NSDateFormatter*)mts_validationDateFormatter;

/** ---------------------------------------------- **
 * @name Manual Validation
 ** ---------------------------------------------- **/

/**
 * Method called by `-mts_setValue:forKey:` to validate manually each value. The default implementation fires KVC validation.
 * @param ioValue The value to be validated. You can replace the value by assigning a new object to the pointer.
 * @param inKey The key of the value.
 * @param error The validation error.
 * @return YES if value is accepted, otherwise NO.
 * @discussion Subclasses may override in order to not perform KVC validation. For example, when using CoreData you must override this method and not do KVC validation (as KVC validation is implemented by NSManagedObject and used by NSManagedObjectContext).
 **/
- (BOOL)mts_validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing *)outError;

/**
 * Subclasses may override to validate array values. The default implementation accepts (return YES) the default value.
 * @param ioValue The value to be validated. You can replace the value by assigning a new object to the pointer.
 * @param arrayKey The name of the key in which the containing array will be assigned.
 * @return YES if value is accepted, NO to avoid adding this value inside the array.
 **/
- (BOOL)mts_validateArrayObject:(inout __autoreleasing id *)ioValue forArrayKey:(NSString *)arrayKey error:(out NSError *__autoreleasing *)outError;

/** ---------------------------------------------- **
 * @name Other methods
 ** ---------------------------------------------- **/

/**
 * Notifies ignored values for undefined mapping keys.
 * @param value The value that has not been setted.
 * @param key The key undefined in the mapping.
 * @discussion This method is called when the method `-mts_motisShouldSetUndefinedKeys` return NO and Motis is trying to set a value for an undefined mapping key.
 **/
- (void)mts_ignoredSetValue:(id)value forUndefinedMappingKey:(NSString*)key;

/**
 * If a value does not pass validation, this method is called after aborting the value setting.
 * @param value The invalid value.
 * @param key The key for the value.
 * @param error The validation error.
 **/
- (void)mts_invalidValue:(id)value forKey:(NSString *)key error:(NSError*)error;

/**
 * If a array item does not pass validation, this method is called after aborting the item setting.
 * @param value The invalid array item.
 * @param key The key of the array.
 * @param error The validation error.
 **/
- (void)mts_invalidValue:(id)value forArrayKey:(NSString *)key error:(NSError*)error;

/**
 * Whether or not Motis should, before assigning a value to a key,
 * first get that value and compare it with the value-to-set using
 * [NSObject isEqual:]. By default, this is `NO`.
 * @param key The key of the attribute.
 * @discussion This can be useful when using Motis with Core Data, because Core Data will flag `NSManagedObject` instances as updated, triggering database work, even if no properties have meaningfully changed.
 **/
- (BOOL)mts_checkValueEqualityBeforeAssignmentForKey:(NSString *)key;

@end
