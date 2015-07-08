Motis Object Mapping
==========
[![Version](https://cocoapod-badges.herokuapp.com/v/Motis/badge.png)](http://cocoadocs.org/docsets/Motis) 
[![Platform](https://cocoapod-badges.herokuapp.com/p/Motis/badge.png)](http://cocoadocs.org/docsets/Motis) 
[![Build Status](https://travis-ci.org/mobilejazz/Motis.png)](https://travis-ci.org/mobilejazz/Motis)

![Motis](https://raw.githubusercontent.com/mobilejazz/Motis/master/Images/Motis.png)

Easy JSON to NSObject mapping using Cocoa's key value coding (KVC)

**Motis** is a user-friendly interface with Key Value Coding that provides your NSObjects   tools to map key-values stored in dictionaries into themselves. With **Motis** your objects will be responsible for each mapping (distributed mapping definitions) and you won't have to worry for data validation, as **Motis** will validate your object types for you.

Check our blog post entry [Using KVC to parse JSON](http://blog.mobilejazz.cat/ios-using-kvc-to-parse-json) to get a deeper idea of Motis foundations.

#How To

## Get Motis

If you use Cocoa Pods, you can get Motis by adding to your podfile `pod 'Motis', '~>1.0.2'`. Otherwise, you will need to download the files `NSObject+Motis.h`, `NSObject+Motis.m` and `Motis.h`.

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
    "creation_date" :  "1979-11-07 17:23:51",
    "webiste" : "http://www.domain.com",
    "user_stats" : {
                     "views" : 431,
                     "ranking" : 12,
                   },
    "user_avatars": [{
      "avatar_type": "standard",
      "image_url": "http://www.avatars.com/john.doe"
    }, {
      "avatar_type": "large",
      "image_url": "http://www.avatars.com/john.doe/large"
    }]
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
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, assign) NSInteger ranking;
@property (nonatomic, assign) NSURL *avatar;

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
             @"user_avatars.0.image_url": mts_key(avatar) // <-- KeyPath access using array index
            };
}

@end
```

As shown in the example above, KeyPath access is supported to reference JSON content of dictionaries. KeyPath access supports array index lookups when you need to map values into properties using a fixed array index.

Also, as you might see, we are specifying custom types as `NSDate` or `NSURL`. Motis automatically attempt to convert JSON values to the object defined types. Check below for more information on automatic validation.

####1.1 Mapping Filtering

By default, Motis attempt to set via KVC any property name. Therefore, even if you don't define a mapping in the method `+mts_mapping:` but your JSON dictionary contains keys that match the name of your object properties, motis will assign and validate those values.

This might be problematic if you have no control over your JSON dictionaries. Therefore, Motis will restrict the accepted mapping keys to the ones defined in the Motis mapping. You can change this behaviour by overriding the method `+mts_shouldSetUndefinedKeys`.

```objective-c
+ (BOOL)mts_shouldSetUndefinedKeys
{
    // By default this method return NO unless you haven't defined a mapping.
    // You can override it and return YES to only accept any key.
    return NO; 
}
```
####1.2 Value mapping 

With the method `+mts_valueMappingForKey:` objects can define value mappings. This is very useful when a string value has to be mapped into a enum for example. Check the following example on how to implement this method:

For the following JSON...
```objective-c
{
  {
    "user_name" : "john.doe",
    "user_gender": "male",
  }
}
```
...we define the following class and Motis behaviour:
```objective-c
typedef NS_ENUM(NSUInteger, MJUserGender)
{
    MJUserGenderUndefined,
    MJUserGenderMale,
    MJUserGenderFemale,
};

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assing) MJUserGender gender;
@end

@implementation User
+ (NSDictionary*)mts_mapping
{
    return @{"user_name": mts_key(name),
             "user_gender": mts_key(gender),
            };
}

+ (NSDictionary*)mts_valueMappingForKey:(NSString*)key
{
    if ([key isEqualToString:mts_key(gender)])
    {
        return @{"male": @(MJUserGenderMale),
                 "female": @(MJUserGenderFemale),
                 MTSDefaultValue: @(MJUserGenderUndefined),
                };
    }
    return nil;
}
@end
```
The above code will automatically translate the "male"/"female" values into the enum MJUserGender. Optionally, by using the `MTSDefaultValue` key, we can specify a default value when a value is not contained in the dictionary or is null. If we don't define the `MTSDefalutValue`, then Motis will attempt to set the original received value.

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

Manual validation is performed before automatic validation and gives the user the oportunity of manually validate a value before any automatic validation is done. Of course, if the user validates manually a value for a given Key, any automatic validation will be performed. 

Motis calls the following method to fire manual validation:

```objective-c
- (BOOL)mts_validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing *)outError;
```

The default implementation of this method fires the [KVC validation pattern](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html). To manually validate a value you can implement the KVC validation method for the corresponding key:

```objective-c
- (BOOL)validate<Key>:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
	// Check *ioValue and assign new value to ioValue if needed.
	// Return YES if *ioValue can be assigned to the attribute, NO otherwise
	return YES; 
}
```

However, you can also override the Motis manual validation method listed above and perform your custom manual validation (without using the KVC validation pattern).

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

### Thread Safety

Starting at version 1.0.2, Motis can be used simultaneously in multiple threads (is thread safe).

To understand why Motis had this problem, we need to know that Motis cache Objective-C runtime information to increase efficiency. This caching is done using NSMapTable and NSMutableDictionary instances and these objects are not thread safe while reading and editing its content, causing Motis to fail in thread safety. 

However, it is important to understand that at the very end, Motis is using KVC to access and manipulate objects. Therefore, it is the developer reponsibility to make object getters and setters thread safe, otherwise Motis won't be able to make it for you.

### Motis & Core Data

If your project is using **CoreData** and you are dealing with `NSManagedObject` instances, you can still using Motis to map JSON values into your class instances. However, you will have to take care of a few things:

####1. Don't use KVC validation

CoreData uses KVC validation to validate `NSManagedObject` properties when performing a `-saveContext:` action. Therefore, you must not use KVC validation to check the integrity and consistency of your JSON values. Consequently, you must override the Motis manual validation method in order to not perform KVC validation.

```objective-c
- (BOOL)mts_validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing *)outError
{
    // Do manual validation for the given "inKey"
    return YES;
} 
```

####2. Help Motis create new instances

When parsing the JSON content into an object, Motis might find `NSDictionay` instances that might be converted into new model object instances. By default Motis, doing introspection, creates a new instnace of the corresponding class type and maps the values contained in the found dictionary recursively. However, when using CoreData you must allocate and initialize `NSManagedObject` instances providing a `NSManagedObjectContext`.

Therefore, you must override the method `- (id)mts_willCreateObjectOfClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary forKey:(NSString*)key abort:(BOOL*)abort` and return an instnace of `typeClass` having performed Motis with the `dictionary`.

For example, we could create a new managed object for the corresponding class, perform Motis and return:

```objective-c
- (id)mts_willCreateObjectOfClass:(Class)typeClass withDictionary:(NSDictionary*)dictionary forKey:(NSString*)key abort:(BOOL*)abort
{
    if ([typeClass isSubclassOfClass:NSManagedObject.class])
    {
        // Get the entityName
        NSString *entityName = [typeClass entityName]; // <-- This is a custom method that returns the entity name
        
        // Create a new managed object for the given class (for example).
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
        NSManagedObject *object = [[typeClass alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];
        
        // Perform Motis on the object instance
        [object mts_setValuesForKeysWithDictionary:dictionary];
        
        return object;
    }
    return nil;
}
```
####3. Enable equality check

In order to avoid unnecessary "hasChanges" flags in our managed objects, override the method `-mts_checkValueEqualityBeforeAssignmentForKey:` and return `YES` in order to make Motis check equality before assigning a value via KVC. This way, if a new value is equal (via the `isEqual:` method) to the current already set value, Motis will not make the assigniment.

```objective-c
- (BOOL)mts_checkValueEqualityBeforeAssignmentForKey:(NSString*)key
{
   // Return YES to make Motis check for equality before making an assignment via KVC.
   // Return NO to make Motis always assign a value via KVC without checking for equality before.
   
   return YES;
}
```
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
 
* basic type (1) : int, unsigned int, long, unsigned long, long long, unsigned long long, float, double)
* basic type (2) : int, unsigned int, long, unsigned long, float, double)
* basic type (3) : any basic type (non-object type).
```
