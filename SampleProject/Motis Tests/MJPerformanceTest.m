//
//  MJPerformanceTest.m
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Motis.h"
#import "MJParser.h"

NSString *urlEncoding(NSString* string)
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

NSString* uniqueString()
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString  *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

@interface MJPerformanceTest : XCTestCase

@end

@implementation MJPerformanceTest
{
    NSDictionary *_jsonDictionary;
}

- (id)initWithInvocation:(NSInvocation *)anInvocation
{
    self = [super initWithInvocation:anInvocation];
    if (self)
    {
        [self mts_prepareData];
    }
    return self;
}

- (id)initWithSelector:(SEL)aSelector
{
    self = [super initWithSelector:aSelector];
    if (self)
    {
        [self mts_prepareData];
    }
    return self;
}

- (void)mts_prepareData
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"sample_data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError *error = nil;
    _jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
}

#pragma mark - TESTS

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMotis
{
    MJCountry *country = [[MJCountry alloc] init];
    [country mts_setValuesForKeysWithDictionary:_jsonDictionary];
}

- (void)testParser
{
    MJCountry *country = [MJParser parseCountry:_jsonDictionary];
    (void)country;
}

@end
