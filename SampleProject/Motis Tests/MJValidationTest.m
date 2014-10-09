//
//  Motis_Tests.m
//  Motis Tests
//
//  Created by Joan Martin on 18/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSObject+Motis.h"
#import "MJMotisObject.h"
#import "MJMotisObjectNonRestricted.h"
#import "MJMotisObjectWithFormatter.h"


@interface MJValidationTest : XCTestCase

@end

@implementation MJValidationTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - FROM NULL

// ------------------------------------------------------------------------------------------------------------------------ //
// FROM NULL TO ....
// ------------------------------------------------------------------------------------------------------------------------ //

#pragma mark to basic type

- (void)testNullToBasicTypeWithNullDefinition
{
    // check `-setNilValueForKey` method.
    
    MJMotisObject *object = [MJMotisObject new];
    object.boolField = YES;
    [object mts_setValue:[NSNull null] forKey:@"bool"];

    XCTAssert(object.boolField == NO, @"Basic type value must change to the new reseted value.");
}

- (void)testNullToBasicTypeWithoutNullDefinition
{
    // check `-setNilValueForKey` method.
    MJMotisObject *object = [MJMotisObject new];
    object.integerField = 42;
    [object mts_setValue:[NSNull null] forKey:@"integer"];
    
    XCTAssert(object.integerField == 42, @"Basic type value must not change");
}

#pragma mark to object

- (void)testNullToObject
{
    MJMotisObject *object = [MJMotisObject new];
    object.numberField = @(42);
    [object mts_setValue:[NSNull null] forKey:@"number"];
    
    XCTAssertNil(object.numberField, @"Failed to nullify object");
}

- (void)testNilToObject
{
    MJMotisObject *object = [MJMotisObject new];
    object.numberField = @(42);
    [object mts_setValue:nil forKey:@"number"];
    
    XCTAssertNil(object.numberField, @"Failed to nillify object");
}

#pragma mark - FROM NUMBER

// ------------------------------------------------------------------------------------------------------------------------ //
// FROM NUMBER TO ....
// ------------------------------------------------------------------------------------------------------------------------ //

- (NSArray*)mts_arrayWithNumbers
{
    static NSArray *array = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Float types are not supported in JSON, therefore we are only using integers, decimals and exponentials.
        
        array = @[@0, @1, @(-1),
                  @YES, @NO,
                  @(NSIntegerMax), @(NSIntegerMin), @(NSUIntegerMax),
                  @0.1, @0.6, @0.999,
                  ];
    });
    
    return array;
}

#pragma mark to basic types

- (void)testYESBoolToBool
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSNumber *number = @YES;
    object.boolField = NO;
    [object mts_setValue:number forKey:@"bool"];
    XCTAssertEqual(object.boolField, number.boolValue, @"Failed to map number value");
}

- (void)testNOBoolToBool
{
    MJMotisObject *object = [MJMotisObject new];
    NSNumber *number = @NO;
    object.boolField = YES;
    [object mts_setValue:number forKey:@"bool"];
    XCTAssertEqual(object.boolField, number.boolValue, @"Failed to map number value");
}

- (void)testNumberToBool
{
    MJMotisObject *object = [MJMotisObject new];
    
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.boolField = NO;
        [object mts_setValue:number forKey:@"bool"];
        XCTAssertEqual(object.boolField, number.boolValue, @"Failed to map number value");
    }
}

- (void)testNumberToInteger
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.integerField = 0;
        [object mts_setValue:number forKey:@"integer"];
        XCTAssertEqual(object.integerField, number.integerValue, @"Failed to map number value");
    }
}

- (void)testNumberToUnsignedInteger
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.unsignedIntegerField = 0;
        [object mts_setValue:number forKey:@"unsigned_integer"];
        XCTAssertEqual(object.unsignedIntegerField, number.unsignedIntegerValue, @"Failed to map number value");
    }
}

- (void)testNumberToFloat
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.floatField = 0.0f;
        [object mts_setValue:number forKey:@"float"];
        XCTAssertEqual(object.floatField, number.floatValue, @"Failed to map number value");
    }
}

- (void)testNumberToDouble
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.doubleField = 0.0;
        [object mts_setValue:number forKey:@"double"];
        XCTAssertEqual(object.doubleField, number.doubleValue, @"Failed to map number value");
    }
}

#pragma mark to string

- (void)testNumberToString
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.stringField = nil;
        [object mts_setValue:number forKey:@"string"];
        XCTAssertEqualObjects(object.stringField, number.stringValue, @"Failed to map number value");
    }
}

#pragma mark to date

- (void)testNumberToDate
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSTimeInterval timeInterval = 1398333352.0;
    
    [object mts_setValue:@(timeInterval) forKey:@"date"];
    
    NSTimeInterval finalTimeInterval = [object.dateField timeIntervalSince1970];
    
    XCTAssertEqual(timeInterval, finalTimeInterval, @"Failed to map number value to date");
}

#pragma mark to id

- (void)testNumberToId
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.idField = nil;
        [object mts_setValue:number forKey:@"id"];
        XCTAssertEqualObjects(object.idField, number, @"Failed to map number value to id");
    }
}

- (void)testNumberToIdProtocol
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        object.idField = nil;
        [object mts_setValue:number forKey:@"id_protocol"];
        XCTAssertEqualObjects(object.idProtocolField, number, @"Failed to map number value to id <Protocol>");
    }
}

#pragma mark - FROM STRING

// ------------------------------------------------------------------------------------------------------------------------ //
// FROM STRING TO ....
// ------------------------------------------------------------------------------------------------------------------------ //

- (NSArray*)mts_arrayWithStrings
{
    static NSArray *array = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *strings = [NSMutableArray array];
        
        // Adding numbers as strings
        for (NSNumber *number in [self mts_arrayWithNumbers])
            [strings addObject:number.stringValue];
        
        array = [strings copy];
    });
    
    return array;
}

#pragma mark to basic types

- (void)testStringNumbersToBool
{
    MJMotisObject *object = [MJMotisObject new];
    for (NSNumber *originalNumber in [self mts_arrayWithNumbers])
    {
        if (originalNumber.integerValue == NSIntegerMin) // <-- Bug on NSIntegerMin with boolValue: [@(NSIntegerMin) boolValue] is 0, when is supposed to be 1.
            continue;
        
        NSString *string = originalNumber.stringValue;
        
        object.boolField = NO;
        [object mts_setValue:string forKey:@"bool"];
        XCTAssertEqual(object.boolField, originalNumber.boolValue, @"Failed to map string number value %@", originalNumber.stringValue);
    }
}

- (void)testFalseStringToBool
{
    MJMotisObject *object = [MJMotisObject new];
    object.boolField = YES;
    [object mts_setValue:@"false" forKey:@"bool"];
    XCTAssertEqual(object.boolField, NO, @"Failed to map number value");
    
    object.boolField = YES;
    [object mts_setValue:@"FALSE" forKey:@"bool"];
    XCTAssertEqual(object.boolField, NO, @"Failed to map number value");
}

- (void)testTrueStringToBool
{
    MJMotisObject *object = [MJMotisObject new];
    object.boolField = NO;
    [object mts_setValue:@"true" forKey:@"bool"];
    XCTAssertEqual(object.boolField, YES, @"Failed to map number value");
    
    object.boolField = NO;
    [object mts_setValue:@"TRUE" forKey:@"bool"];
    XCTAssertEqual(object.boolField, YES, @"Failed to map number value");
}

- (void)testStringNumbersToInteger
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSArray *numbers = @[@(NSIntegerMax), @(NSIntegerMin)];
    
    for (NSNumber *number in numbers)
    {
        NSString *string = number.stringValue;
        
        object.integerField = 0;
        [object mts_setValue:string forKey:@"integer"];
        XCTAssertEqual(object.integerField, number.integerValue, @"Failed to map string number value");
    }
}

- (void)testStringNumbersToUnsignedInteger
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSArray *numbers = @[@(LONG_MAX), @(0)]; // <-- BUG: NSNumberFormatter fails to format numbers bigger than LONG_MAX.
    
    for (NSNumber *number in numbers)
    {
        NSString *string = number.stringValue;
        
        object.unsignedIntegerField = 0;
        [object mts_setValue:string forKey:@"unsigned_integer"];
        XCTAssertEqual(object.unsignedIntegerField, number.unsignedIntegerValue, @"Failed to map string number value");
    }
}

#pragma mark to number

- (void)testStringNumbersToNumber
{
    MJMotisObject *object = [MJMotisObject new];
    
    for (NSNumber *originalNumber in [self mts_arrayWithNumbers])
    {
        NSString *string = originalNumber.stringValue;
        
        object.numberField = nil;
        [object mts_setValue:string forKey:@"number"];
        XCTAssertEqualObjects(object.numberField, originalNumber, @"Failed to map string number value.");
    }
}

- (void)testFalseStringToBoolNumber
{
    MJMotisObject *object = [MJMotisObject new];
    
    object.boolField = YES;
    [object mts_setValue:@"false" forKey:@"number"];
    XCTAssertEqualObjects(object.numberField, @NO, @"Failed to map number value");
    
    object.boolField = YES;
    [object mts_setValue:@"FALSE" forKey:@"number"];
    XCTAssertEqualObjects(object.numberField, @NO, @"Failed to map number value");
}

- (void)testTrueStringToBoolNumber
{
    MJMotisObject *object = [MJMotisObject new];
    
    object.boolField = NO;
    [object mts_setValue:@"true" forKey:@"number"];
    XCTAssertEqualObjects(object.numberField, @YES, @"Failed to map number value");
    
    object.boolField = NO;
    [object mts_setValue:@"TRUE" forKey:@"number"];
    XCTAssertEqualObjects(object.numberField, @YES, @"Failed to map number value");
}

#pragma mark to url

- (void)testStringToUrl
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSString *string = @"http://www.google.com";
    [object mts_setValue:string forKey:@"url"];
    XCTAssertEqualObjects(object.urlField.absoluteString, string, @"Failed to map string value to URL");
}

#pragma mark to date

- (void)testStringFormatToDate_Default
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSString *string = @"2014-04-23 12:00:00";
    [object mts_setValue:string forKey:@"date"];
    XCTAssertNil(object.dateField, @"Failed to invalidate string value %@", string);
}

- (void)testStringTimeIntervalToDate_Default
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSTimeInterval timeInterval = 1398333352.0;
    NSString *string = [NSString stringWithFormat:@"%f", timeInterval];
    [object mts_setValue:string forKey:@"date"];
    XCTAssertEqual([object.dateField timeIntervalSince1970], timeInterval, @"Failed to map string value %@", string);
}

- (void)testStringFormatToDate_CustomDateFormatter
{
    MJMotisObjectWithFormatter *object = [MJMotisObjectWithFormatter new];
    
    NSString *string = @"2014-04-23 12:00:00";
    [object mts_setValue:string forKey:@"date"];

    NSDateFormatter *formatter = [object.class mts_validationDateFormatter];
    NSDate *date = [formatter dateFromString:string];
    XCTAssertEqualObjects(object.dateField, date, @"Failed to map string value %@", string);
}

- (void)testStringTimeIntervalToDate_CustomDateFormatter
{
    MJMotisObjectWithFormatter *object = [MJMotisObjectWithFormatter new];
    
    const NSTimeInterval timeInterval = 1398333352.0;
    
    NSString *string = [NSString stringWithFormat:@"%f", timeInterval];
    [object mts_setValue:string forKey:@"date"];
    
    XCTAssertNil(object.dateField, @"Failed to invalidate string value %@", string);
}

#pragma mark to id

- (void)testStringToId
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSString *string = @"Hello World";
    [object mts_setValue:string forKey:@"id"];
    XCTAssertEqualObjects(object.idField, string, @"Failed to map string value");
}

- (void)testStringToIdProtocol
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSString *string = @"Hello World";
    [object mts_setValue:string forKey:@"id_protocol"];
    XCTAssertEqualObjects(object.idProtocolField, string, @"Failed to map string value");
}

#pragma mark - FROM DICTIONARY

// ------------------------------------------------------------------------------------------------------------------------ //
// FROM DICTIONARY
// ------------------------------------------------------------------------------------------------------------------------ //

#pragma mark to object

- (void)testDictionaryToObject
{
    MJMotisObject *object = [MJMotisObject new];
    
    NSDictionary *dict = @{@"string": @"hello world",
                           @"integer": @123,
                           @"bool": @YES,
                           };

    [object mts_setValue:dict forKey:@"motis_object"];
    
    XCTAssertEqualObjects(object.motisObject.stringField, dict[@"string"], @"Failed to map motis object string value.");
    XCTAssertEqual(object.motisObject.integerField, [dict[@"integer"] integerValue], @"Failed to map motis object integer value.");
    XCTAssertEqual(object.motisObject.boolField, [dict[@"bool"] boolValue], @"Failed to map motis object bool value.");
}

#pragma mark - UNDEFINED MAPPINGS

// ------------------------------------------------------------------------------------------------------------------------ //
// WITHOUT A MOTIS-PREPARED OBJECT
// ------------------------------------------------------------------------------------------------------------------------ //

- (void)testUndefinedMapping
{
    MJTestObject *object = [MJTestObject new];
    
    NSString *string = @"Hello World";
    [object mts_setValue:string forKey:@"stringField"];
    XCTAssertEqualObjects(object.stringField, string, @"By default, object must assign values if JSON keys and property match.");
}

// ------------------------------------------------------------------------------------------------------------------------ //
// WITH UNDEFINED PROPERTIES
// ------------------------------------------------------------------------------------------------------------------------ //

- (void)testUndefinedMappingWithUndefinedProperty
{
    MJTestObject *object = [MJTestObject new];
    
    BOOL thrownException = NO;
    
    @try
    {
        [object mts_setValue:@"hello world" forKey:@"lorem_ipsum_sir_dolor_amet"];
    }
    @catch (NSException *exception)
    {
        thrownException = exception != nil;
    }
    
    XCTAssertEqual(thrownException, YES, @"Object must throw exception if key is unknown");
}

- (void)testUndefinedMappingWithUndefinedPropertyRestricted
{
    MJMotisObject *object = [MJMotisObject new];
    
    @try
    {
        [object mts_setValue:@"hello world" forKey:@"lorem_ipsum_sir_dolor_amet"];
    }
    @catch (NSException *exception)
    {
        XCTAssertNil(exception, @"Object must not throw exception if key is unknown");
    }
}

// ------------------------------------------------------------------------------------------------------------------------ //
// WITH DEFINED PROPERTIES
// ------------------------------------------------------------------------------------------------------------------------ //

- (void)testUndefinedMappingWithDefinedProperty
{
    MJMotisObjectNonRestricted *object = [MJMotisObjectNonRestricted new];
    
    object.privateIntegerField = 42;
    [object mts_setValue:@0 forKey:@"privateIntegerField"];
    XCTAssertEqual(object.privateIntegerField, 0, @"Object must assign values for undefined mappings");
}

- (void)testUndefinedMappingWithDefinedPropertyRestricted
{
    MJMotisObject *object = [MJMotisObject new];
    
    object.privateIntegerField = 42;
    [object mts_setValue:@0 forKey:@"privateIntegerField"];
    XCTAssertEqual(object.privateIntegerField, 42, @"Object must not assign values for undefined mappings");
}

#pragma mark - DICTIONARY SET

// ------------------------------------------------------------------------------------------------------------------------ //
// DICTIONARY SET TEST
// ------------------------------------------------------------------------------------------------------------------------ //

#pragma mark Mappings

- (void)testDictionarySetForUndefinedMapping
{
    MJTestObject *object = [MJTestObject new];
    NSString *string = @"Hello World";
    
    [object mts_setValuesForKeysWithDictionary:@{@"stringField": string}];
    
    XCTAssertEqualObjects(object.stringField, string, @"ERROR!");
}

- (void)testDictionarySetForDefinedMapping
{
    MJMotisObject *object = [MJMotisObject new];
    NSString *string = @"Hello World";
    
    [object mts_setValuesForKeysWithDictionary:@{@"string": string}];
    
    XCTAssertEqualObjects(object.stringField, string, @"ERROR!");
}

#pragma mark KeyPath

// ------------------------------------------------------------------------------------------------------------------------ //
// KEY PATH TEST
// ------------------------------------------------------------------------------------------------------------------------ //

- (void)testKeyPathInNonRestrictedMotisObject
{
    MJMotisObjectNonRestricted *object = [MJMotisObjectNonRestricted new];
    
    object.stringField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"Hello";
    
    dictionary = @{@"string1": @{@"string2": @{@"string3": string}}};
    
    BOOL thrownException = NO;
    
    @try
    {
        [object mts_setValuesForKeysWithDictionary:dictionary];
    }
    @catch (NSException *exception)
    {
        thrownException = exception != nil;
        XCTAssertEqualObjects(object.stringField, string, @"KeyPath acces failed");
    }
    
    XCTAssertEqual(thrownException, YES, @"Object must throw exception if key is unknown");
}

/*
 * The defined mapping is "string1.string2.string3" and points to a NSString property.
 * In this test we are mapping a dictionary {string1:{string2:{string3:"HELLO"}}} to our object.
 */
- (void)testKeyPath
{
    MJMotisObject *object = [MJMotisObject new];
    
    object.stringField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"Hello";
    
    dictionary = @{@"string1": @{@"string2": @{@"string3": string}}};
    [object mts_setValuesForKeysWithDictionary:dictionary];
    XCTAssertEqualObjects(object.stringField, string, @"KeyPath acces failed");
}

/*
 * The defined mapping is "url1.url2.url3" and points to a NSURL property.
 * In this test we are mapping a dictionary {url1:{url2:{url3:"http://website.com"}}} to our object and we are testing automatic validation (from NSString to NSURL).
 */
- (void)testKeyPathValidation
{
    MJMotisObject *object = [MJMotisObject new];
    
    object.urlField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"http://www.mobilejazz.cat";
    
    dictionary = @{@"url1": @{@"url2": @{@"url3": string}}};
    [object mts_setValuesForKeysWithDictionary:dictionary];
    
    XCTAssertEqualObjects(object.urlField.class, NSURL.class, @"KeyPath validation failed");
}

/*
 * The defined mapping is "string1.string2.string3" and points to a NSString property.
 * In this test we are mapping a dictionary {string1:{string2:"HELLO"}} to our object.
 * When motis will try to map the keyPath "string1.string2.string3", will have to abort thus "HELLO" is not a dictionary and motis cannot access to "string3" property.
 */
- (void)testKeyPathIncorrectAccess
{
    MJMotisObject *object = [MJMotisObject new];
    
    object.stringField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"Hello";
    
    dictionary = @{@"string1": @{@"string2": string}};
    [object mts_setValuesForKeysWithDictionary:dictionary];
    XCTAssertNil(object.stringField, @"KeyPath acces failed");
}

@end
