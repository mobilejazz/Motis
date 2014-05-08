Motis Object Mapping*
==========
![Motis](https://raw.githubusercontent.com/mobilejazz/Motis/master/Images/Motis.png)

Easy JSON to NSObject mapping using Cocoa's key value coding (KVC)

**Motis** is a user-friendly interface with Key Value Coding that provides your NSObjects   tools to map key-values stored in dictionaries into themselves. With **Motis** your objects will be responsible for each mapping (distributed mapping definitions) and you won't have to worry for data validation, as **Motis** will validate your object types for you.

Check our blog post entry [Using KVC to parse JSON](http://blog.mobilejazz.cat/ios-using-kvc-to-parse-json) to get a deeper idea of Motis foundations.

#How To

## Get Motis

If you use Cocoa Pods, you can get Motis by adding to your podfile `pod 'Motis', '~>0.4.2'`. Otherwise, you will need to download the files `NSObject+Motis.h`, `NSObject+Motis.m` and `Motis.h`.

##Using Motis

1. Import the file `#import <Motis/Motis.h>`
2. Setup your motis objects (see below).
3. Get some JSON to be mapped in your model objects.
4. Call `mts_setValuesForKeysWithDictionary:` on your model object, using as argument the JSON dictionary to be mapped. 
```objective-c
- (void)motisTest
{
	// Some JSON object
	NSDictionary *jsonObject = [...];
	
	// Creating an instance of your class
	MyClass instance = [[MyClass alloc] init];
			
	// Parsing and setting the values of the JSON object
	[instance mts_setValuesForKeysWithDictionary:jsonObject];
}
```

## Setup Motis Objects

###1. Define the motis mapping dictionary

Your custom object (subclass of `NSObject`) needs to override the method `+mts_mapping` and define the mappging from the JSON keys to the Objective-C property names.

For example, if receiving the following JSON:

```objective-c
{
  {
    "user_name" : "john.doe",
    "user_id" : 42,
    "creation_date" :  "1979-11-07 17:23:51"
    "webiste" : "http://www.domain.com"
    "user_stats" : {
                     "views" : 431,
                     "ranking" : 12,
                   } 
  }
}
```

Then, in our `User` class entity (`NSObject` subclass) we would define the `+mts_mapping` method as follows:

```objective-c

// --- User.h --- //

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSIntger userId;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSURL *website;
@property (nonatomic, assing) NSInteger views;
@property (nonatomic, assing) NSInteger ranking;

@end

// --- User.m --- //

@implementation User

+ (NSDictionary*)mts_mapping
{
    return @{@"user_name": mts_key(name),
             @"user_id": mts_key(userId),
             @"creation_date": mts_key(creationDate),
             @"website": mts_key(website),
             @"user_stats.views": mts_key(views),  // <-- KeyPath access
             @"user_stats.ranking": mts_key(ranking), // <-- KeyPath access
            };
}

@end
```

As shown in the example above, KeyPath access is supported to reference JSON content of dictionaries.

Also, as you might see, we are specifying custom types as `NSDate` or `NSURL`. Motis automatically attempt to convert JSON values to the object defined types. Check below for more information on automatic validation.

####1.1 Mapping Filtering

By default, Motis attempt to set via KVC any property name. Therefore, even if you don't define a mapping in the method `+mts_mapping:` but your JSON dictionary contains keys that match the name of your object properties, motis will assign and validate those values.

This might be problematic if you have no control over your JSON dictionaries. Therefore, Motis can restrict the accepted mapping keys to the ones defined in the motis mapping. You can active this behaviour by overriding the method `+mts_shouldSetUndefinedKeys` and return NO (default is YES).

```objective-c
+ (BOOL)mts_shouldSetUndefinedKeys
{
    // By default this method return YES.
    // You can override it and return NO to only accept the keys defined in mts_mapping.
    return NO; 
}
```

###2. Value Validation

####2.1 Automatic Validation

**Motis** checks the object type of your values when mapping from a JSON response. The system will try to fit your defined property types (making introspection in your classes). JSON objects contains only strings, numbers, dictionaries and arrays. Automatic validation will try to convert from these types to your property types. If cannot be achieved, the mapping of those property won't be performed and the value won't be set.

For example, if you specify a property type as a `NSURL` and your JSON is sending a string value, Motis will convert the string into a NSURL automatically. However, if your property type is a "UIImage" and your json is sending a number, Motis will ignore the value and won't set it. Automatic validation done for types as `NSURL`, `NSData`, `NSDate`, `NSNumber`, and a few more. For more information check the table on the bottom of this file.

Automatic validation will be performed always unless the user is validating manually, thus in this case the user will be responsible of validating correctly the values.

#####2.1.1 Automatic Date Validation

Whenever you specify a property type as a `NSDate`, Motis will attempt to convert the received JSON value in to a date.

1. If the JSON value is a number or an string containing a number, Motis will create the date considering that the number is the number of seconds elapsed since 1979-1-1. 
2. If the JSON value is a string, Motis will use the `NSDateFormatter` returned by the method `+mts_validationDateFormatter`. Motis does not implement any defautl date formatter (therefore, this method return nil by default). It is your responsibility to provide a default date formatter.

However, if you have multiple formats for different keys, you will have to validate your dates using manual validation (see below).

#####2.1.2 Automatic Array Validation

In order to support automatic validation for array content (objects inside of an array), you must override the method `+mts_arrayClassMapping` and return a dictionary containing pairs of *array property name* and *class type* for its content.

For example, having the following JSON:

```objective-c
{
  "user_name": "john.doe",
  "user_id" : 42,
  ...
  "user_followers": [
                      {
                        "user_name": "william",
                        "user_id": 55,
                        ...
                      },
                      {
                        "user_name": "jenny",
                        "user_id": 14,
                        ...
                      },
                      ...
                    ]
}

```

Therefore, our `User` class has an `NSArray` property called `followers` that contain a list of objects of type `User`, we would override the method and implement it as it follows:

```objective-c
@implementation User

+ (NSDictionary*)mts_mapping
{
    return @{@"user_name": mts_key(name),
             @"user_id": mts_key(userId),
             ...
             @"user_followers": mts_key(followers),
            };
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(followers): User.class}; 
}

@end
```
#####2.1.3 Automatic Object Creation

When validating autmatically, Motis might attempt to create new instances of your custom objects. For example, if a JSON value is a dictionary and the key-associated property type is a custom object, Motis will try to create recursively a new object of the corresponding type and set it via `-mts_setValuesForKeysWithDictionary:`.

This automatic "object creation", that is also done for contents of an array, can be customized and tracked by using the following two methods: one "will"-styled method to notify the user that an object will be created and one "did"-styled method to notify the user that an object has been created.

```objective-c
@implementation User

- (id)mts_willCreateObjectOfClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary forKey:(NSString*)key abort:(BOOL*)abort
{
    // Return "nil" if you want Motis to handle the object creation and mapping.
    // Otherwise, create/reuse an object of the given "typeClass" and map the values from the dictionary and return it.
    // If you set "abort" to yes, the value for the given "key" won't be set.

    // This method is also used for array contents. In this case, "key" will be the name of the array.
} 

- (void)mts_didCreateObject:(id)object forKey:(NSString *)key
{
    // Motis notifies you the new created object.
    // This method is also used for array contents. In this case, "key" will be the name of the array.
}

@end
```
####2.2 Manual Validation

If you prefer to do manual validation, you can override the KVC validation method for each key. Remember that by doing manual validation, automatic validation won't be performed and you will be fully responsible of the validation for those values you are valiating manually.

For example:

```objective-c
- (BOOL)validate<Key>:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
	// Check *ioValue and assign new value to ioValue if needed.
	// Return YES if *ioValue can be assigned to the attribute, NO otherwise
	return YES; 
}
```

#####2.2.1 Manual Array Validation

You can also perform manual validation on array content. When mapping an array, motis will attempt to validate array content for the type define in the method `+mts_arrayClassMapping`. However, you can perform the validation manually if you prefer. By validating manually, automatic validation won't be performed.

To manually validate array content you must override the following method:

```objective-c
- (BOOL)mts_validateArrayObject:(inout __autoreleasing id *)ioValue forArrayKey:(NSString *)arrayKey error:(out NSError *__autoreleasing *)outError;
{
	// Check *ioValue and assign new value to ioValue if needed.
	// Return YES if *ioValue can be included into the array, NO otherwise
	
	return YES; 
}
```



---
## Appendix
 
### Automatic Validation 
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
