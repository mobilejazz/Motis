//
//  Motis_Tests.m
//  Motis Tests
//
//  Created by Joan Martin on 18/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSObject+Motis.h"
#import "MJTestObject.h"
#import "MJTestObject2.h"

@interface MJTestObjectWithFormatter : MJTestObject

@end

@implementation MJTestObjectWithFormatter

+ (NSDateFormatter*)mts_validationDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return formatter;
}

@end

@interface MJValidationTest : XCTestCase

@property (nonatomic, strong) MJTestObject *object;

@end

@implementation MJValidationTest

- (void)setUp
{
    [super setUp];
    
    _object = [[MJTestObject alloc] init];
}

- (void)tearDown
{
    _object = nil;
    
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
    
    _object.boolField = YES;
    [_object mts_setValue:[NSNull null] forKey:@"bool"];

    XCTAssert(_object.boolField == NO, @"Basic type value must change to the new reseted value.");
}

- (void)testNullToBasicTypeWithoutNullDefinition
{
    // check `-setNilValueForKey` method.
    
    _object.integerField = 42;
    [_object mts_setValue:[NSNull null] forKey:@"integer"];
    
    XCTAssert(_object.integerField == 42, @"Basic type value must not change");
}

#pragma mark to object

- (void)testNullToObject
{
    _object.numberField = @(42);
    [_object mts_setValue:[NSNull null] forKey:@"number"];
    
    XCTAssertNil(_object.numberField, @"Failed to nullify object");
}

- (void)testNilToObject
{
    _object.numberField = @(42);
    [_object mts_setValue:nil forKey:@"number"];
    
    XCTAssertNil(_object.numberField, @"Failed to nillify object");
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
        
        array = @[@0, @1,
                  @YES, @NO,
                  @(NSIntegerMax), @(NSIntegerMin), @(NSUIntegerMax),
                  @0.1, @0.6, @0.999,
                  ];
    });
    
    return array;
}

#pragma mark to basic types

- (void)testNumberToBool
{    
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.boolField = NO;
        [_object mts_setValue:number forKey:@"bool"];
        XCTAssertEqual(_object.boolField, number.boolValue, @"Failed to map number value");
    }
}

- (void)testNumberToInteger
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.integerField = 0;
        [_object mts_setValue:number forKey:@"integer"];
        XCTAssertEqual(_object.integerField, number.integerValue, @"Failed to map number value");
    }
}

- (void)testNumberToUnsignedInteger
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.unsignedIntegerField = 0;
        [_object mts_setValue:number forKey:@"unsigned_integer"];
        XCTAssertEqual(_object.unsignedIntegerField, number.unsignedIntegerValue, @"Failed to map number value");
    }
}

- (void)testNumberToFloat
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.floatField = 0.0f;
        [_object mts_setValue:number forKey:@"float"];
        XCTAssertEqual(_object.floatField, number.floatValue, @"Failed to map number value");
    }
}

- (void)testNumberToDouble
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.doubleField = 0.0;
        [_object mts_setValue:number forKey:@"double"];
        XCTAssertEqual(_object.doubleField, number.doubleValue, @"Failed to map number value");
    }
}

#pragma mark to string

- (void)testNumberToString
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.stringField = nil;
        [_object mts_setValue:number forKey:@"string"];
        XCTAssertEqualObjects(_object.stringField, number.stringValue, @"Failed to map number value");
    }
}

#pragma mark to date

- (void)testNumberToDate
{
    NSTimeInterval timeInterval = 1398333352.0;
    
    [_object mts_setValue:@(timeInterval) forKey:@"date"];
    
    NSTimeInterval finalTimeInterval = [_object.dateField timeIntervalSince1970];
    
    XCTAssertEqual(timeInterval, finalTimeInterval, @"Failed to map number value to date");
}

#pragma mark to id

- (void)testNumberToId
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.idField = nil;
        [_object mts_setValue:number forKey:@"id"];
        XCTAssertEqualObjects(_object.idField, number, @"Failed to map number value to id");
    }
}

- (void)testNumberToIdProtocol
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.idField = nil;
        [_object mts_setValue:number forKey:@"id_protocol"];
        XCTAssertEqualObjects(_object.idProtocolField, number, @"Failed to map number value to id <Protocol>");
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
    for (NSNumber *originalNumber in [self mts_arrayWithNumbers])
    {
        NSString *string = originalNumber.stringValue;
        
        _object.boolField = NO;
        [_object mts_setValue:string forKey:@"bool"];
        XCTAssertEqual(_object.boolField, originalNumber.boolValue, @"Failed to map string number value");
    }
}

- (void)testStringNumbersToInteger
{
    NSArray *numbers = @[@(NSIntegerMax), @(NSIntegerMin)];
    
    for (NSNumber *number in numbers)
    {
        NSString *string = number.stringValue;
        
        _object.integerField = 0;
        [_object mts_setValue:string forKey:@"integer"];
        XCTAssertEqual(_object.integerField, number.integerValue, @"Failed to map string number value");
    }
}

- (void)testStringNumbersToUnsignedInteger
{
    NSArray *numbers = @[@(LONG_MAX), @(0)]; // <-- BUG: NSNumberFormatter fails to format numbers bigger than LONG_MAX.
    
    for (NSNumber *number in numbers)
    {
        NSString *string = number.stringValue;
        
        _object.unsignedIntegerField = 0;
        [_object mts_setValue:string forKey:@"unsigned_integer"];
        XCTAssertEqual(_object.unsignedIntegerField, number.unsignedIntegerValue, @"Failed to map string number value");
    }
}

#pragma mark to number

- (void)testStringNumbersToNumber
{
    for (NSNumber *originalNumber in [self mts_arrayWithNumbers])
    {
        NSString *string = originalNumber.stringValue;
        
        _object.numberField = nil;
        [_object mts_setValue:string forKey:@"number"];
        XCTAssertEqualObjects(_object.numberField, originalNumber, @"Failed to map string number value.");
    }
}

#pragma mark to url

- (void)testStringToUrl
{
    NSString *string = @"http://www.google.com";
    [_object mts_setValue:string forKey:@"url"];
    XCTAssertEqualObjects(_object.urlField.absoluteString, string, @"Failed to map string value to URL");
}

#pragma mark to date

- (void)testStringFormatToDate_Default
{
    NSString *string = @"2014-04-23 12:00:00";
    [_object mts_setValue:string forKey:@"date"];
    XCTAssertNil(_object.dateField, @"Failed to invalidate string value %@", string);
}

- (void)testStringTimeIntervalToDate_Default
{
    const NSTimeInterval timeInterval = 1398333352.0;
    NSString *string = [NSString stringWithFormat:@"%f", timeInterval];
    [_object mts_setValue:string forKey:@"date"];
    XCTAssertEqual([_object.dateField timeIntervalSince1970], timeInterval, @"Failed to map string value %@", string);
}

- (void)testStringFormatToDate_CustomDateFormatter
{
    _object = [MJTestObjectWithFormatter new];
    NSString *string = @"2014-04-23 12:00:00";
    [_object mts_setValue:string forKey:@"date"];

    NSDateFormatter *formatter = [_object.class mts_validationDateFormatter];
    NSDate *date = [formatter dateFromString:string];
    XCTAssertEqualObjects(_object.dateField, date, @"Failed to map string value %@", string);
}

- (void)testStringTimeIntervalToDate_CustomDateFormatter
{
    _object = [MJTestObjectWithFormatter new];
    
    const NSTimeInterval timeInterval = 1398333352.0;
    
    NSString *string = [NSString stringWithFormat:@"%f", timeInterval];
    [_object mts_setValue:string forKey:@"date"];
    
    XCTAssertNil(_object.dateField, @"Failed to invalidate string value %@", string);
}

#pragma mark to id

- (void)testStringToId
{
    NSString *string = @"Hello World";
    [_object mts_setValue:string forKey:@"id"];
    XCTAssertEqualObjects(_object.idField, string, @"Failed to map string value");
}

- (void)testStringToIdProtocol
{
    NSString *string = @"Hello World";
    [_object mts_setValue:string forKey:@"id_protocol"];
    XCTAssertEqualObjects(_object.idProtocolField, string, @"Failed to map string value");
}

#pragma mark - FROM DICTIONARY

// ------------------------------------------------------------------------------------------------------------------------ //
// FROM DICTIONARY
// ------------------------------------------------------------------------------------------------------------------------ //

#pragma mark to object

- (void)testDictionaryToObject
{
    // TODO
}

- (void)testDictionaryToObjectWithRecursiveObject
{
    // TODO
}

- (void)testDictionaryToObjectWithRecursiveArray
{
    // TODO
}

#pragma mark - UNDEFINED MAPPINGS

// MJTestObject overrides the method "-mts_motisShouldSetUndefinedKeys" and returns NO.
// MJTestObject2 overrides the method "-mts_motisShouldSetUndefinedKeys" and returns YES.

// ------------------------------------------------------------------------------------------------------------------------ //
// WITH UNDEFINED PROPERTIES
// ------------------------------------------------------------------------------------------------------------------------ //

- (void)testUndefinedMappingWithUndefinedProperty
{
    MJTestObject2 *object = [MJTestObject2 new];
    
    @try
    {
        [object mts_setValue:@"hello world" forKey:@"lorem_ipsum_sir_dolor_amet"];
    }
    @catch (NSException *exception)
    {
        XCTAssertNotNil(exception, @"Object must throw exception if key is unknown");
    }
}

- (void)testUndefinedMappingWithUndefinedPropertyRestricted
{
    @try
    {
        [_object mts_setValue:@"hello world" forKey:@"lorem_ipsum_sir_dolor_amet"];
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
    MJTestObject2 *object = [MJTestObject2 new];
    
    object.privateIntegerField = 42;
    [object mts_setValue:@0 forKey:@"privateIntegerField"];
    XCTAssertEqual(object.privateIntegerField, 0, @"Object must assign values for undefined mappings");
}

- (void)testUndefinedMappingWithDefinedPropertyRestricted
{
    _object.privateIntegerField = 42;
    [_object mts_setValue:@0 forKey:@"privateIntegerField"];
    XCTAssertEqual(_object.privateIntegerField, 42, @"Object must not assign values for undefined mappings");
}

#pragma mark - KEYPATH

// ------------------------------------------------------------------------------------------------------------------------ //
// KEY PATH TEST
// ------------------------------------------------------------------------------------------------------------------------ //

/*
 * The defined mapping is "string1.string2.string3" and points to a NSString property.
 * In this test we are mapping a dictionary {string1:{string2:{string3:"HELLO"}}} to our object.
 */
- (void)testKeyPath
{
    _object.stringField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"Hello";
    
    dictionary = @{@"string1": @{@"string2": @{@"string3": string}}};
    [_object mts_setValuesForKeysWithDictionary:dictionary];
    XCTAssertEqualObjects(_object.stringField, string, @"KeyPath acces failed");
}

/*
 * The defined mapping is "url1.url2.url3" and points to a NSURL property.
 * In this test we are mapping a dictionary {url1:{url2:{url3:"http://website.com"}}} to our object and we are testing automatic validation (from NSString to NSURL).
 */
- (void)testKeyPathValidation
{
    _object.urlField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"http://www.mobilejazz.cat";
    
    dictionary = @{@"url1": @{@"url2": @{@"url3": string}}};
    [_object mts_setValuesForKeysWithDictionary:dictionary];
    
    XCTAssertEqualObjects(_object.urlField.class, NSURL.class, @"KeyPath validation failed");
}

/*
 * The defined mapping is "string1.string2.string3" and points to a NSString property.
 * In this test we are mapping a dictionary {string1:{string2:"HELLO"}} to our object.
 * When motis will try to map the keyPath "string1.string2.string3", will have to abort thus "HELLO" is not a dictionary and motis cannot access to "string3" property.
 */
- (void)testKeyPathIncorrectAccess
{
    _object.stringField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"Hello";
    
    dictionary = @{@"string1": @{@"string2": string}};
    [_object mts_setValuesForKeysWithDictionary:dictionary];
    XCTAssertNil(_object.stringField, @"KeyPath acces failed");
}

@end
