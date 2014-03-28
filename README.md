Motis Object Mapping*
==========


Easy JSON to NSObject mapping using Cocoa's key value coding (KVC)

**Motis** is a user-friendly interface with Key Value Coding that provides your NSObjects   tools to map key-values stored in dictionaries into themselves. With **Motis** your objects will be responsible for each mapping (distributed mapping definitions) and you won't have to worry for data validation, as **Motis** will validate your object types for you.

##How To
####1. Define the mapping keys

Your custom object (subclass of `NSObject`) needs to override the method `mts_mapping` and define the mappging from the JSON keys to the Objective-C property names.

```objective-c
- (NSDictionary*)mts_mapping
{
	return @{@"json_attribute_key_1" : @"class_property_name_1",
		@"json_attribute_key_2" : @"class_property_name_2",
		...
		@"json_attribute_key_N" : @"class_property_name_M",
	};
}
```

####2. Map and set your objects

After defining your mappings in step (1) you are ready to go:

```objective-c
- (void)parseTest
{
	// Some JSON object
	NSDictionary *jsonObject = [...];
	
	// Creating an instance of your class
	MyClass instance = [[MyClass alloc] init];
			
	// Parsing and setting the values of the JSON object
	[instance mts_setValuesForKeysWithDictionary:jsonObject];
}
```
	
####3. Value Validation

##### Automatic Validation
**Motis** checks the object type of your values when mapping from a JSON response. The system will try to fit your defined property types (making introspection in your classes). JSON objects contains only strings, numbers, dictionaries and arrays. Automatic validation will try to convert from these types to your property types. If cannot be achieved, the mapping of those property won't be performed and the value won't be set.

Automatic validation is done by default if the user is not validating manually. 

In order to support automatic validation for array content (objects inside of an array), you must override the method `-mts_motisArrayClassMapping` and return a dictionary containing pairs of *array property name* and *class type* for its content.

##### Manual Validation

If you prefer to do manual validation, you can override the KVC validation method for each key:

```objective-c
- (BOOL)validate<Key>:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
	// Check *ioValue and assign new value to ioValue if needed.
	// Return YES if *ioValue can be assigned to the attribute, NO otherwise
	
	return YES; 
}
```

and for array contents:

```objective-c
- (BOOL)mts_validateArrayObject:(inout __autoreleasing id *)ioValue forArrayKey:(NSString *)arrayKey error:(out NSError *__autoreleasing *)outError;
{
	// Check *ioValue and assign new value to ioValue if needed.
	// Return YES if *ioValue can be included into the array, NO otherwise
	
	return YES; 
}
```

---
*Motis was called before KVCParsing.
