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

#pragma mark - FROM NULL

// ------------------------------------------------------------------------------------------------------------------------ //
// FROM NULL TO ....
// ------------------------------------------------------------------------------------------------------------------------ //

#pragma mark to basic type

// Cannot nillify basic types! objects must implement `setNilValueForKey:` and reset the default value for the given keys.

//- (void)testNullToBool
//{
//    _object.boolField = YES;
//    [_object mjz_setValue:[NSNull null] forKey:@"bool"];
//
//    if (_object.boolField != NO)
//        XCTFail(@"Failed to nillify object");
//}

#pragma mark to object

- (void)testNullToObject
{
    _object.numberField = @(42);
    [_object mjz_setValue:[NSNull null] forKey:@"number"];
    
    if (_object.numberField != nil)
        XCTFail(@"Failed to nullify object");
}

- (void)testNilToObject
{
    _object.numberField = @(42);
    [_object mjz_setValue:nil forKey:@"number"];
    
    if (_object.numberField != nil)
        XCTFail(@"Failed to nillify object");
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
        // Float types are not supported in JSON, therefore we are only using integers, decimals and exponentials.
        
        array = @[@0, @0.1, @0.6, @0.999, @YES, @NO, @(CHAR_MAX), @(CHAR_MIN), @(UCHAR_MAX), @(SHRT_MAX), @(SHRT_MIN), @(INT_MIN), @(INT_MAX), @(UINT_MAX), @(LONG_MAX), @(LONG_MIN), @(LONG_LONG_MAX), @(LONG_LONG_MIN), @(ULONG_LONG_MAX), @(DBL_MAX), @(DBL_MIN), @(DBL_EPSILON)];
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
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToChar
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"char"];
        if (_object.charField != number.charValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsignedChar
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_char"];
        if (_object.unsignedCharField != number.unsignedCharValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToShort
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"short"];
        if (_object.shortField != number.shortValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsignedShort
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_short"];
        if (_object.unsignedShortField != number.unsignedShortValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToInt
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"int"];
        if (_object.intField != number.intValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsignedInt
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_int"];
        if (_object.unsignedIntField != number.unsignedIntValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"long"];
        if (_object.longField != number.longValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsignedLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_long"];
        if (_object.unsignedLongField != number.unsignedLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToLongLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"long_long"];
        if (_object.longLongField != number.longLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsignedLongLong
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"unsigned_long_long"];
        if (_object.unsignedLongLongField != number.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToFloat
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"float"];
        if (_object.floatField != number.floatValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToDouble
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"double"];
        if (_object.doubleField != number.doubleValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

#pragma mark to string

- (void)testNumberToString
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        [_object mjz_setValue:number forKey:@"string"];
        if (![_object.stringField isEqualToString:number.stringValue])
            XCTFail(@"Failed to map number value %@", number.description);
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
        
        _object.boolField = NO;
        [_object mjz_setValue:string forKey:@"bool"];
        
        if (_object.boolField != originalNumber.boolValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToChar
{
    NSArray *numbers = @[@(CHAR_MAX), @(CHAR_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.charField = 0;
        [_object mjz_setValue:string forKey:@"char"];
        
        if (_object.charField != originalNumber.charValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToUnsignedChar
{
    NSArray *numbers = @[@(UCHAR_MAX), @0];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsignedCharField = 0;
        [_object mjz_setValue:string forKey:@"unsigned_char"];
        
        if (_object.unsignedCharField != originalNumber.unsignedCharValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToShort
{
    NSArray *numbers = @[@(SHRT_MAX), @(SHRT_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.shortField = 0;
        [_object mjz_setValue:string forKey:@"short"];
 
        if (_object.shortField != originalNumber.shortValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToUnsignedShort
{
    NSArray *numbers = @[@(USHRT_MAX), @0];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsignedShortField = 0;
        [_object mjz_setValue:string forKey:@"unsigned_short"];
        
        if (_object.unsignedShortField != originalNumber.unsignedShortValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToInt
{
    NSArray *numbers = @[@(INT_MAX), @(INT_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.intField = 0;
        [_object mjz_setValue:string forKey:@"int"];
        
        if (_object.intField != originalNumber.intValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToUnsignedInt
{
    NSArray *numbers = @[@(UINT_MAX), @0];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsignedIntField = 0;
        [_object mjz_setValue:string forKey:@"unsigned_int"];
        
        if (_object.unsignedIntField != originalNumber.unsignedIntValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToLong
{
    NSArray *numbers = @[@(LONG_MAX), @(LONG_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.longField = 0;
        [_object mjz_setValue:string forKey:@"long"];
        
        if (_object.longField != originalNumber.longValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToUnsignedLong
{
    NSArray *numbers = @[@(ULONG_MAX), @0];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsignedLongField = 0;
        [_object mjz_setValue:string forKey:@"unsigned_long"];
        
        if (_object.unsignedLongField != originalNumber.unsignedLongValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToLongLong
{
    NSArray *numbers = @[@(LONG_LONG_MAX), @(LONG_LONG_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.longLongField = 0;
        [_object mjz_setValue:string forKey:@"long_long"];
        
        if (_object.longLongField != originalNumber.longLongValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
    }
}

- (void)testStringNumbersToUnsignedLongLong
{
    NSArray *numbers = @[@(ULONG_LONG_MAX), @0];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsignedLongLongField = 0;
        [_object mjz_setValue:string forKey:@"unsigned_long_long"];
        
        if (_object.unsignedLongLongField != originalNumber.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@", originalNumber.description);
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
        
        if (![_object.numberField isEqualToNumber:originalNumber])
            XCTFail(@"Failed to map string value %@ --> %@", string, _object.numberField.description);
    }
}

#pragma mark to url

- (void)testStringToUrl
{
    NSString *string = @"http://www.google.com";
    [_object mjz_setValue:string forKey:@"url"];
    
    if (![_object.urlField.absoluteString isEqualToString:string])
        XCTFail(@"Failed to map string value %@", string);
}

@end
