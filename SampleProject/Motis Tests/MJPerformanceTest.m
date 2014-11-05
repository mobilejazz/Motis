//
//  MJPerformanceTest.m
//  Motis
//
//  Created by Joan Martin on 05/11/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>
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

- (void)setUp
{
    [super setUp];

    static NSData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *file = @"data_25MB.json";
        NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:[file stringByDeletingPathExtension] ofType:[file pathExtension]];
        data = [NSData dataWithContentsOfFile:path];
    });
    
    NSError *error = nil;
    _jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
}

- (void)tearDown
{
    _jsonDictionary = nil;
    [super tearDown];
}

- (void)testPerformanceMotis
{
    MJCountry *country = [[MJCountry alloc] init];
    [self measureBlock:^{
        [country mts_setValuesForKeysWithDictionary:_jsonDictionary];
    }];
}

- (void)testPerformanceParser
{
    [self measureBlock:^{
        MJCountry *country = nil;
        country = [MJParser parseCountry:_jsonDictionary];
    }];
}

@end
