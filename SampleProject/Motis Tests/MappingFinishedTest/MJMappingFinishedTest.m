//
//  MJMappingFinishedTest.m
//  Motis
//
//  Created by Rostyslav Druzhchenko on 12/6/16.
//  Copyright © 2016 Mobile Jazz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MJMappingFinishedTestObject.h"
#import "Motis.h"

@interface MJMappingFinishedTest : XCTestCase

@end

@implementation MJMappingFinishedTest

- (void)testCustomActionAfterMappingFinished
{
    NSDictionary *dataDictionary = @{@"a" : @4,
                                     @"b" : @5};
    MJMappingFinishedTestObject *object = [MJMappingFinishedTestObject new];
    [object mts_setValuesForKeysWithDictionary:dataDictionary];

    XCTAssertTrue(object.a == 4);
    XCTAssertTrue(object.b == 5);
    XCTAssertTrue(object.c == 9);
}

@end
