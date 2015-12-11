//
//  MJTestObject.m
//  Motis
//
//  Created by Joan Martin on 18/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJTestMotisMappingObject.h"

#import "NSObject+Motis.h"

@implementation MJTestMotisMappingObject

+ (NSDictionary*)mts_mapping
{
    return @{@"bool": mts_key(boolField),
             
             @"integer": mts_key(integerField),
             @"unsigned_integer": mts_key(unsignedIntegerField),
             
             @"float": mts_key(floatField),
             @"double": mts_key(doubleField),
             
             @"string": mts_key(stringField),
             @"number": mts_key(numberField),
             @"url": mts_key(urlField),
             @"date": mts_key(dateField),
             
             @"id": mts_key(idField),
             @"id_protocol": mts_key(idProtocolField),
             
             @"string1.string2.string3" : mts_key(stringField),
             @"url1.url2.url3" : mts_key(urlField),
             
             @"test_object": mts_key(testObject),
             @"motis_object": mts_key(motisObject),
             
             @"array": mts_key(array),
             @"object_array": mts_key(objectArray),
             @"string_array": mts_key(stringsArray),
             @"number_array": mts_key(numbersArray),
             @"url_array": mts_key(urlsArray),
             @"date_array": mts_key(datesArray),
             
             @"mutable_array": mts_key(mutableArray),
             @"set": mts_key(set),
             @"mutable_set": mts_key(mutableSet),
             @"ordered_set": mts_key(orderedSet),
             @"mutable_ordered_set": mts_key(mutableOrderedSet),
             
             @"unsigned_enum": mts_key(unsignedEnum),
             @"signed_enum": mts_key(signedEnum),
             
             @"array.0.integer": mts_key(array0Integer),
             @"array.1.integer": mts_key(array1Integer),
             @"array.2.integer": mts_key(array2Integer),
             
             @"array.0.string": mts_key(array0String),
             @"array.1.string": mts_key(array1String),
             @"array.2.string": mts_key(array2String),
             
             @"array.0": mts_key(array0Object),
             @"array.1": mts_key(array1Object),
             @"array.2": mts_key(array2Object),
             
             @"integerArray.0": mts_key(integerArray0),
             @"integerArray.1": mts_key(integerArray1),
             @"integerArray.2": mts_key(integerArray2),
             
             @"stringArray.0": mts_key(stringArray0),
             @"stringArray.1": mts_key(stringArray1),
             @"stringArray.2": mts_key(stringArray2),
             
             
             };
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(objectArray): MJTestMotisMappingObject.class,
             mts_key(stringsArray): NSString.class,
             mts_key(numbersArray): NSNumber.class,
             mts_key(urlsArray): NSURL.class,
             mts_key(datesArray): NSDate.class,
             };
}

 + (NSDictionary *)mts_valueMappingForKey:(NSString *)key
{
    if ([key isEqualToString:mts_key(unsignedEnum)])
    {
        return @{@"zero": @(MJUnsignedEnumZero),
                 @"one": @(MJUnsignedEnumOne),
                 @"two": @(MJUnsignedEnumTwo),
                 @"three": @(MJUnsignedEnumThree),
                 MTSDefaultValue: @(MJUnsignedEnumOne),
                 };
    }
    else if ([key isEqualToString:mts_key(signedEnum)])
    {
        return @{@"zero": @(MJSignedEnumZero),
                 @"one": @(MJSignedEnumOne),
                 @"two": @(MJSignedEnumTwo),
                 @"three": @(MJSignedEnumThree),
                 MTSDefaultValue: @(MJSignedEnumTwo),
                 };
    }
    
    return nil;
}

#pragma mark Property Nillification

- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:mts_key(boolField)])
        self.boolField = NO;
}

#pragma mark Loggers

- (void)mts_invalidValue:(id)value forKey:(NSString *)key error:(NSError *)error
{
    NSLog(@"INVALID VALUE %@ FOR KEY %@", [value description], key);
}

@end
