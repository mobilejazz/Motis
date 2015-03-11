//
//  MJTestObject.m
//  Motis
//
//  Created by Joan Martin on 18/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJMotisObject.h"

#import "NSObject+Motis.h"

@implementation MJMotisObject

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
             
             @"unsigned_enum": mts_key(unsignedEnum),
             @"signed_enum": mts_key(signedEnum),
             };
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(objectArray): MJMotisObject.class,
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
