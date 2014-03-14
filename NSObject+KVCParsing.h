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
 * To parse and set the object from the JSON dictionary, use the methods `parseValue:forKey:` or `parseValuesForKeysWithDictionary:`.
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
 * @name Logging objects
 ** ---------------------------------------------- **/

/**
 * Returns the extended object description.
 * @return The custom extended object description.
 **/
- (NSString*)mjz_extendedObjectDescription;

@end


/* *************************************************************************************************************************************** *
 * KVCParsing Subclassing
 * *************************************************************************************************************************************** */

#pragma mark - KVCParsing_Subclassing

/**
 * The mapping clearance behaviour.
 **/
typedef NS_ENUM(NSUInteger, KVCParsingMappingClearance)
{
    /**
     * Only those keys defined in the mapping `mjz_mappingForKVCParsing` can be used while performing KVCParsing.
     **/
    KVCParsingMappingClearanceRestricted,
    
    /**
     * Any key can be used while performing KVCParsing.
     **/
    KVCParsingMappingClearanceOpen,
};

/**
 * KVCParsing Object Subclassing
 *
 * PARSING MAPPINGS
 *
 * In order to use KVCParsign you must define mappings between JSON keys and object properties by overriding the following methods:
 *
 *  - `mjz_mappingForKVCParsing`: Subclasses must override this method and return the mapping between the JSON keys and the object properties.
 *  - `mjz_mappingClearanceForKVCParsing`: Optionally, subclasses can override this method and define a custom clearance for the mapping. The default is `KVCParsingMappingClearanceOpen`.
 *
 *
 * VALIDATION METHODS
 *
 * KVCParsing adds automatic validation for your properties. This means the system will try to convert into your property type the input value.
 * To support automatic validation you must override:
 *
 *  - `mjz_arrayClassTypeMappingForAutomaticKVCParsingValidation`: If your objects has properties of type `NSArray`, override this method and define a mapping between the array property name and the expected content object class.
 *
 * However, you can validate manually any value before the automatic validation is done. If you implements manually validation for a property, the system won't perform the automatic validation.
 * To implement manual validation you must override:
 *
 *  - `validate<Key>:error:` For each property to manually validate implement this method with <Key> being the name of the object property. This is a KVC validation method.
 *  - `mjz_validateArrayObject:forArrayKey:`: For those property of type array, implement this method to validate their content.
 *
 *
 * OTHER METHODS TO SUBCLASS
 *
 *  - `setValue:forUndefinedKey:`: KVC Method to handle undefined keys. By default this method throws an exception.
 *  - `mjz_parseValue:forUndefinedMappingKey`: If mapping clearance is restricted (`KVCParsingMappingClearanceRestricted`), this method will be called when a undefined mapping key is found.
 *  - `mjz_invalidValue:forKey:error:`: If value is does not pass valiation, this method is called after aborting the value setting.
 *  - `mjz_invalidValue:forArrayKey:error:`: if an array item does not pass validation, this method is called after aborting the item setting.
 **/
@interface NSObject (KVCParsing_Subclassing)

/** ---------------------------------------------- **
 * @name KVCParsing Mappings
 ** ---------------------------------------------- **/

/**
 * Returns the mapping to be used in the parsing. The default value is an empty dictionary.
 * @return the mapping in a dictionary.
 * @discussion Subclasses must override this method and specify a custom mapping dictionary. As a good practice, always add the [super mappingForKVCParsing] dictionary inside the custom dictionary.
 **/
- (NSDictionary*)mjz_mappingForKVCParsing;

/**
 * Returns the object class mapping clearance. Default value is `KVCParsingMappingClearanceOpen`.
 * @return The mapping key clearance.
 * @discussion Subclasses may override and return a custom clearance.
 **/
+ (KVCParsingMappingClearance)mjz_mappingClearanceForKVCParsing;

/** ---------------------------------------------- **
 * @name Automatic Validation
 ** ---------------------------------------------- **/

/**
 * Return a mapping between the array property name to the contained object class type.
 * For example: @{@"myArrayPropertyName": User.class, ... };
 * @return A dictionary with the array content mapping.
 **/
- (NSDictionary*)mjz_arrayClassTypeMappingForAutomaticKVCParsingValidation;

/**
 * While validating automatically your JSON objects, KVCParsing might create new objects. This method is called just before new objects are created.
 * @param typeClass The object class. A new object of this class is going to be created.
 * @param dictionary The JSON-based dictionary which will be parsed into the new object.
 * @param key The property name of the object to assign or the array name where the object will belong to.
 * @param abort A flag boolean. Return YES if you want to abort (because of dictionary incoherences, for example). When aborting the object is not setted or included inside an array.
 * @return A custom object or nil.
 * @discussion If you return nil, KVCParsing will create automatically the new instance of class typeClass and parse the dictionary into it. Optionally, you can create the object and parse the dictionary manually. You must return the custom object as a return value of this method.
 **/
- (id)mjz_willCreateObjectOfClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary forKey:(NSString*)key abort:(BOOL*)abort;

/**
 * The newer created object for the given key.
 * @param object The new object.
 * @param key The property name of the object or the array name where the object belongs to.
 **/
- (void)mjz_didCreateObject:(id)object forKey:(NSString *)key;

/** ---------------------------------------------- **
 * @name Manual Validation
 ** ---------------------------------------------- **/

/**
 * Subclasses may override to parse the objects of array values. The default implementation accepts (return YES) the default value.
 * @param ioValue The value to be validated. You can replace the value by assigning a new object to the pointer.
 * @param arrayKey The name of the key in which the containing array will be assigned.
 * @return YES if value is accepted, NO to avoid adding this value inside the array.
 **/
- (BOOL)mjz_validateArrayObject:(inout __autoreleasing id *)ioValue forArrayKey:(NSString *)arrayKey error:(out NSError *__autoreleasing *)outError;

/** ---------------------------------------------- **
 * @name Other methods
 ** ---------------------------------------------- **/

/**
 * Notifies restricted values for undefined mapping keys.
 * @param value The value that has not been setted.
 * @param key The key undefined in the mapping.
 **/
- (void)mjz_parseValue:(id)value forUndefinedMappingKey:(NSString*)key;

/**
 * If a value does not pass validation, this method is called after aborting the value setting.
 * @param value The invalid value.
 * @param key The key for the value.
 * @param error The validation error.
 **/
- (void)mjz_invalidValue:(id)value forKey:(NSString *)key error:(NSError*)error;

/**
 * If a array item does not pass validation, this method is called after aborting the item setting.
 * @param value The invalid array item.
 * @param key The key of the array.
 * @param error The validation error.
 **/
- (void)mjz_invalidValue:(id)value forArrayKey:(NSString *)key error:(NSError*)error;

@end
