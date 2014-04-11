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

@interface Motis_Tests : XCTestCase

@property (nonatomic, strong) MJTestObject *object;

@end

@implementation Motis_Tests

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

    if (_object.boolField != NO)
        XCTFail(@"Basic type value must change to the new reseted value.");
}

- (void)testNullToBasicTypeWithoutNullDefinition
{
    // check `-setNilValueForKey` method.
    
    _object.integerField = 42;
    [_object mts_setValue:[NSNull null] forKey:@"integer"];
    
    if (_object.integerField != 42)
        XCTFail(@"Basic type value must not change");
}

#pragma mark to object

- (void)testNullToObject
{
    _object.numberField = @(42);
    [_object mts_setValue:[NSNull null] forKey:@"number"];
    
    if (_object.numberField != nil)
        XCTFail(@"Failed to nullify object");
}

- (void)testNilToObject
{
    _object.numberField = @(42);
    [_object mts_setValue:nil forKey:@"number"];
    
    if (_object.numberField != nil)
        XCTFail(@"Failed to nillify object");
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
        if (_object.boolField != number.boolValue)
            XCTFail(@"Failed to map number value %@ (%d) --> %d", number.description, number.boolValue, _object.boolField);
    }
}

- (void)testNumberToInteger
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.integerField = 0;
        [_object mts_setValue:number forKey:@"integer"];
        if (_object.integerField != number.integerValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsignedInteger
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        _object.unsignedIntegerField = 0;
        [_object mts_setValue:number forKey:@"unsigned_integer"];
        if (_object.unsignedIntegerField != number.unsignedIntegerValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToFloat
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        [_object mts_setValue:number forKey:@"float"];
        if (_object.floatField != number.floatValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToDouble
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        [_object mts_setValue:number forKey:@"double"];
        if (_object.doubleField != number.doubleValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

#pragma mark to string

- (void)testNumberToString
{
    for (NSNumber *number in [self mts_arrayWithNumbers])
    {
        [_object mts_setValue:number forKey:@"string"];
        if (![_object.stringField isEqualToString:number.stringValue])
            XCTFail(@"Failed to map number value %@", number.description);
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
        
        if (_object.boolField != originalNumber.boolValue)
            XCTFail(@"Failed to map number value %@ --> %d", originalNumber.description, _object.boolField);
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
        
        if (_object.integerField != number.integerValue)
            XCTFail(@"Failed to map number value %@ --> %ld", string, (long)_object.integerField);
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
        
        if (_object.unsignedIntegerField !=  number.unsignedIntegerValue)
            XCTFail(@"Failed to map number value %@ --> %llu", string, (unsigned long long)_object.unsignedIntegerField);
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
        
        if (![_object.numberField isEqualToNumber:originalNumber])
            XCTFail(@"Failed to map string value %@ --> %@", string, _object.numberField.description);
    }
}

#pragma mark to url

- (void)testStringToUrl
{
    NSString *string = @"http://www.google.com";
    [_object mts_setValue:string forKey:@"url"];
    
    if (![_object.urlField.absoluteString isEqualToString:string])
        XCTFail(@"Failed to map string value %@", string);
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
    
    BOOL foundException = NO;
    
    @try
    {
        [object mts_setValue:@"hello world" forKey:@"lorem_ipsum_sir_dolor_amet"];
    }
    @catch (NSException *exception)
    {
        foundException = YES;
    }
    
    if (!foundException)
        XCTFail(@"Object must throw exception if key is unknown");
}

- (void)testUndefinedMappingWithUndefinedPropertyRestricted
{
    @try
    {
        [_object mts_setValue:@"hello world" forKey:@"lorem_ipsum_sir_dolor_amet"];
    }
    @catch (NSException *exception)
    {
        XCTFail(@"Object must not throw exception if key is unknown");
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
    
    if (object.privateIntegerField != 0)
        XCTFail(@"Object must assign values for undefined mappings");
}

- (void)testUndefinedMappingWithDefinedPropertyRestricted
{
    _object.privateIntegerField = 42;
    
    [_object mts_setValue:@0 forKey:@"privateIntegerField"];
    
    if (_object.privateIntegerField != 42)
        XCTFail(@"Object must not assign values for undefined mappings");
}

#pragma mark - KEYPATH

// ------------------------------------------------------------------------------------------------------------------------ //
// KEY PATH TEST
// ------------------------------------------------------------------------------------------------------------------------ //

- (void)testKeyPath
{
    _object.stringField = nil;
    
    NSDictionary *dictionary = nil;
    NSString *string = @"Hello";
    
    dictionary = @{@"string1": @{@"string2": @{@"string3": string}}};
    [_object mts_setValuesForKeysWithDictionary:dictionary];
    
    if (![_object.stringField isEqualToString:string])
        XCTFail(@"KeyPath acces failed");
}

@end
