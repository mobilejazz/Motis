Motis Object Mapping*
==========


Easy JSON to NSObject mapping using Cocoa's key value coding (KVC)

**Motis** is a user-friendly interface with Key Value Coding that provides your NSObjects   tools to map key-values stored in dictionaries into themselves. With **Motis** your objects will be responsible for each mapping (distributed mapping definitions) and you won't have to worry for data validation, as **Motis** will validate your object types for you.

##How To
####1. Define the mapping keys

Your custom object (subclass of `NSObject`) needs to override the method `+mts_mapping` and define the mappging from the JSON keys to the Objective-C property names.

```objective-c
+ (NSDictionary*)mts_mapping
{
	return @{@"json_key_1" : @"propertyName1",
	  	     @"json_key_2" : @"propertyName2",
		     @"json_key_3.json_key_4" : @"propertyName3",
		     ...
	};
}
```

You can also use KeyPath to reference JSON content of dictionaries.

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

In order to support automatic validation for array content (objects inside of an array), you must override the method `+mts_arrayClassMapping` and return a dictionary containing pairs of *array property name* and *class type* for its content.

For more information about automatic validations, check the bottom table of this document.

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
#### 4. Appendix
 
##### Automatic Validation 
The following table indicates the supported validations in the current Motis version:

```
+------------+---------------------+------------------------------------------------------------------------------------+
| JSON Type  | Property Type       | Comments                                                                           |
+------------+---------------------+------------------------------------------------------------------------------------+
| string     | NSString            | No validation is requried                                                          |
| number     | NSNumber            | No validation is requried                                                          |
| number     | basic type (1)      | No validation is requried                                                          |
| array      | NSArray             | No validation is requried                                                          |
| dictionary | NSDictionary        | No validation is requried                                                          |
| -          | -                   | -                                                                                  |
| string     | bool                | string parsed with NSNumberFormatter (allowFloats enabled)                         |
| string     | unsigned long long  | string parsed with NSNumberFormatter (allowFloats disabled)                        |
| string     | basic types (2)     | value generated automatically by KVC (NSString's '-intValue', '-longValue', etc)   |
| string     | NSNumber            | string parsed with NSNumberFormatter (allowFloats enabled)                         |
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
| null       | undefined           | if property is basic type (3). Check KVC method '-setNilValueForKey:'              |
+------------+---------------------+------------------------------------------------------------------------------------+

basic type (1) : int, unsigned int, long, unsigned long, long long, unsigned long long, float, double
basic type (2) : int, unsigned int, long, unsigned long, float, double
basic type (3) : any basic type
```

--- 
*Motis was called before KVCParsing.
