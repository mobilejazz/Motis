//
//  MJMotisObjectTest.m
//  Motis
//
//  Created by Joan Martin on 14/10/15.
//  Copyright © 2015 Mobile Jazz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MJMotisObject.h"

@interface MJMotisObjectTest : XCTestCase

@end

@implementation MJMotisObjectTest
{
    MJMotisObject *_motisObject;
}

- (void)setUp
{
    [super setUp];
    
    _motisObject = [[MJMotisObject alloc] init];
    _motisObject.string = @"test";
    _motisObject.integer = 42;
    _motisObject.date = [NSDate date];
    _motisObject.url = [NSURL URLWithString:@"http://www.google.com"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoding
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_motisObject];
    MJMotisObject *motisObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertEqualObjects(_motisObject, motisObject);
}

- (void)testCopying
{
    MJMotisObject *motisObject = [_motisObject copy];
    XCTAssertEqualObjects(_motisObject, motisObject);
}

@end
