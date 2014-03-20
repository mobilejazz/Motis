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
        
        array = @[@0, @1,
                  @YES, @NO,
                  @(UINT8_MAX), @(INT8_MAX), @(INT8_MIN),
                  @(UINT16_MAX), @(INT16_MAX), @(INT16_MIN),
                  @(UINT32_MAX), @(INT32_MAX), @(INT32_MIN),
                  @(UINT64_MAX), @(INT64_MAX), @(INT64_MIN),
                  @0.1, @0.6, @0.999,
                  ];
    });
    
    return array;
}

#pragma mark to basic types

- (void)testNumberToBool
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.boolField = NO;
        [_object mjz_setValue:number forKey:@"bool"];
        if (_object.boolField != number.boolValue)
            XCTFail(@"Failed to map number value %@ --> %d", number.description, _object.boolField);
    }
}

- (void)testNumberToSigned8
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.signed8Field = 0;
        [_object mjz_setValue:number forKey:@"signed_8"];
        if (_object.signed8Field != (SInt8)number.longLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsigned8
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.unsigned8Field = 0;
        [_object mjz_setValue:number forKey:@"unsigned_8"];
        if (_object.unsigned8Field != (UInt8)number.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToSigned16
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.signed16Field = 0;
        [_object mjz_setValue:number forKey:@"signed_16"];
        if (_object.signed16Field != (SInt16)number.longLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsignedUnsigned16
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.unsigned16Field = 0;
        [_object mjz_setValue:number forKey:@"unsigned_16"];
        if (_object.unsigned16Field != (UInt16)number.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToSigned32
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.signed32Field = 0;
        [_object mjz_setValue:number forKey:@"signed_32"];
        if (_object.signed32Field != (SInt32)number.longLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsigned32
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.unsigned32Field = 0;
        [_object mjz_setValue:number forKey:@"unsigned_32"];
        if (_object.unsigned32Field != (UInt32)number.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToSigned64
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.signed64Field = 0;
        [_object mjz_setValue:number forKey:@"signed_64"];
        if (_object.signed64Field != (SInt64)number.longLongValue)
            XCTFail(@"Failed to map number value %@", number.description);
    }
}

- (void)testNumberToUnsigned64
{
    for (NSNumber *number in [self mjz_arrayWithNumbers])
    {
        _object.unsigned64Field = 0;
        [_object mjz_setValue:number forKey:@"unsigned_64"];
        if (_object.unsigned64Field != (UInt64)number.unsignedLongLongValue)
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
            XCTFail(@"Failed to map number value %@ --> %d", originalNumber.description, _object.boolField);
    }
}

- (void)testStringNumbersToSigned8
{
    NSArray *numbers = @[@(INT8_MAX),@(INT8_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.signed8Field = 0;
        [_object mjz_setValue:string forKey:@"signed_8"];
        
        if (_object.signed8Field != (SInt8)originalNumber.longLongValue)
            XCTFail(@"Failed to map number value %@ --> %d", originalNumber.description, _object.signed8Field);
    }
}

- (void)testStringNumbersToUnsigned8
{
    NSArray *numbers = @[@(UINT8_MAX),@(0)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsigned8Field = 0;
        [_object mjz_setValue:string forKey:@"unsigned_8"];
        
        if (_object.unsigned8Field != (UInt8)originalNumber.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@ --> %u", originalNumber.description, _object.unsigned8Field);
    }
}

- (void)testStringNumbersToSigned16
{
    NSArray *numbers = @[@(INT16_MAX),@(INT16_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.signed16Field = 0;
        [_object mjz_setValue:string forKey:@"signed_16"];
        
        if (_object.signed16Field != (SInt16)originalNumber.longLongValue)
            XCTFail(@"Failed to map number value %@ --> %d", originalNumber.description, _object.signed8Field);
    }
}

- (void)testStringNumbersToUnsigned16
{
    NSArray *numbers = @[@(UINT16_MAX),@(0)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsigned16Field = 0;
        [_object mjz_setValue:string forKey:@"unsigned_16"];
        
        if (_object.unsigned16Field != (UInt16)originalNumber.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@ --> %u", originalNumber.description, _object.unsigned16Field);
    }
}

- (void)testStringNumbersToSigned32
{
    NSArray *numbers = @[@(INT32_MAX),@(INT32_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.signed32Field = 0;
        [_object mjz_setValue:string forKey:@"signed_32"];
        
        if (_object.signed32Field != (SInt32)originalNumber.longLongValue)
            XCTFail(@"Failed to map number value %@ --> %ld", originalNumber.description, _object.signed32Field);
    }
}

- (void)testStringNumbersToUnsigned32
{
    NSArray *numbers = @[@(UINT32_MAX),@(0)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsigned32Field = 0;
        [_object mjz_setValue:string forKey:@"unsigned_32"];
        
        if (_object.unsigned32Field != (UInt32)originalNumber.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@ --> %lu", originalNumber.description, _object.unsigned32Field);
    }
}

- (void)testStringNumbersToSigned64
{
    NSArray *numbers = @[@(INT64_MAX),@(INT64_MIN)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.signed64Field = 0;
        [_object mjz_setValue:string forKey:@"signed_64"];
        
        if (_object.signed64Field != (SInt64)originalNumber.longLongValue)
            XCTFail(@"Failed to map number value %@ --> %lld", originalNumber.description, _object.signed64Field);
    }
}

- (void)testStringNumbersToUnsigned64
{
    NSArray *numbers = @[@(UINT64_MAX),@(0)];
    
    for (NSNumber *originalNumber in numbers)
    {
        NSString *string = originalNumber.stringValue;
        
        _object.unsigned64Field = 0;
        [_object mjz_setValue:string forKey:@"unsigned_64"];
        
        if (_object.unsigned64Field != (UInt64)originalNumber.unsignedLongLongValue)
            XCTFail(@"Failed to map number value %@ --> %llu", originalNumber.description, _object.unsigned64Field);
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
