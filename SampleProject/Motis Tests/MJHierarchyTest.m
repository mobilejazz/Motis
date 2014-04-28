//
//  MJHierarchyTest.m
//  Motis
//
//  Created by Joan Martin on 28/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Motis.h"

#import "MJChildA.h"
#import "MJChildB.h"

@interface MJHierarchyTest : XCTestCase

@end

@implementation MJHierarchyTest
{
    MJParentObject *_parent;
    MJChildA *_childA;
    MJChildB *_childB;
}

- (void)setUp
{
    [super setUp];
    
    _parent = [[MJParentObject alloc] init];
    _childA = [[MJChildA alloc] init];
    _childB = [[MJChildB alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHierarchies
{
    NSDictionary *dictA = @{@"bool": @YES, @"field": @"Hello World"};
    NSDictionary *dictB = @{@"integer": @7, @"field": @[@1,@2]};
    
    _childA.boolField = NO;
    _childA.customField = nil;
    [_childA mts_setValuesForKeysWithDictionary:dictA];
    
    if (_childA.boolField != YES || ![_childA.customField isEqualToString:@"Hello World"])
        XCTFail(@"Incorrect values in Child A");
    
    _childB.integerField = -1;
    _childB.customField = nil;
    [_childB mts_setValuesForKeysWithDictionary:dictB];
    
    if (_childB.integerField != 7 || _childB.customField.count != 2)
        XCTFail(@"Incorrect values in Child B");
}

@end
