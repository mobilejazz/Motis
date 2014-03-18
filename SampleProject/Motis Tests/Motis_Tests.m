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

#pragma mark - FROM NUMBER

// ------------------------------------------------------------------------------------------------------------------------ //
// FROM NUMBER TO ....
// ------------------------------------------------------------------------------------------------------------------------ //

- (NSArray*)mjz_arrayWithNumbers
{
    static NSArray *array = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[@0, @0.1f, @0.1, @0.6, @0.999, @YES, @NO, @(CHAR_MAX), @(CHAR_MIN), @(UCHAR_MAX), @(SHRT_MAX), @(SHRT_MIN), @(INT_MIN), @(INT_MAX), @(UINT_MAX), @(LONG_MAX), @(LONG_MIN), @(LONG_LONG_MAX), @(LONG_LONG_MIN), @(ULONG_LONG_MAX), @(FLT_MAX), @(FLT_MIN), @(FLT_EPSILON), @(DBL_MAX), @(DBL_MIN), @(DBL_EPSILON)];
    });
    
    return array;
}

#pragma mark to basic types

- (void)testNumberToBool
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"bool"];
        if (_object.boolField != number.boolValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToChar
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"char"];
        if (_object.charField != number.charValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToUnsignedChar
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_char"];
        if (_object.unsignedCharField != number.unsignedCharValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToShort
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"short"];
        if (_object.shortField != number.shortValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToUnsignedShort
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_short"];
        if (_object.unsignedShortField != number.unsignedShortValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToInt
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"int"];
        if (_object.intField != number.intValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToUnsignedInt
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_int"];
        if (_object.unsignedIntField != number.unsignedIntValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"long"];
        if (_object.longField != number.longValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToUnsignedLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_long"];
        if (_object.unsignedLongField != number.unsignedLongValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToLongLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"long_long"];
        if (_object.longLongField != number.longLongValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToUnsignedLongLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_long_long"];
        if (_object.unsignedLongLongField != number.unsignedLongLongValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToFloat
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"float"];
        if (_object.floatField != number.floatValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

- (void)testNumberToDouble
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"double"];
        if (_object.doubleField != number.doubleValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

#pragma mark to string

- (void)testNumberToString
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"string"];
        if (![_object.stringField isEqualToString:number.stringValue])
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, number.description);
    }
}

#pragma mark - FROM STRING
// ------------------------------------------------------------------------------------------------------------------------ //
// FROM STRING TO ....
// ------------------------------------------------------------------------------------------------------------------------ //

- (NSArray*)mjz_arrayWithStrings
{
    static NSArray *array = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *strings = [NSMutableArray array];
        
        // Adding numbers as strings
        for (NSNumber *number in [self mjz_arrayWithNumbers])
            [strings addObject:number.stringValue];
        
        array = [strings copy];
    });
    
    return array;
}

#pragma mark to basic types

- (void)testStringNumbersToBool
{
    for (NSNumber *originalNumber in [self mjz_arrayWithNumbers])
    {
        NSString *string = originalNumber.stringValue;
        
        _object.numberField = nil;
        [_object mjz_setValue:string forKey:@"bool"];
        
        if (_object.boolField != originalNumber.boolValue)
            XCTFail(@"%s: failed to map number value %@", __PRETTY_FUNCTION__, originalNumber.description);
    }
}

#pragma mark to number

- (void)testStringNumbersToNumber
{
    for (NSNumber *originalNumber in [self mjz_arrayWithNumbers])
    {
        NSString *string = originalNumber.stringValue;
        
        _object.numberField = nil;
        [_object mjz_setValue:string forKey:@"number"];
        
        NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:string];
        NSLog(@"DECIMAL: %@ (%@)", decimal, string);
        
        if (![_object.numberField isEqualToNumber:originalNumber])
        {
            NSLog(@"Number: %@ - %@", _object.numberField, originalNumber);
            XCTFail(@"%s: failed to map string value %@ (%@)", __PRETTY_FUNCTION__, string, _object.numberField.description);
        }
    }
}


@end
