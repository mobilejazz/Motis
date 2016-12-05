//
//  MJDidFinishTest.m
//  Motis
//
//  Created by Rostyslav Druzhchenko on 11/22/16.
//  Copyright © 2016 Mobile Jazz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MJCalculatedObject.h"
#import "Motis.h"

@interface MJDidFinishTest : XCTestCase

@end

@implementation MJDidFinishTest

- (void)setUp
{
    [super setUp];
}

- (void)testDidFinishSum
{
    NSDictionary *dict = @{ @"a" : @3,
                            @"b" : @5 };

    MJCalculatedObject *object = [MJCalculatedObject new];
    [object mts_setValuesForKeysWithDictionary:dict];

    XCTAssertTrue(object.a == 3);
    XCTAssertTrue(object.b == 5);
    XCTAssertTrue(object.c == 8);
}

@end
