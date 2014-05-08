//
//  MJPerformanceTest.m
//  Motis
//
//  Created by Joan Martin on 08/05/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJPerformanceTest.h"

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

#define MJZLog(format, ...) NSLog(@"[PERFORMANCE TEST] %@",[NSString stringWithFormat:format, ## __VA_ARGS__])

@implementation MJPerformanceTest
{
    NSDictionary *_jsonDictionary;
}

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

#pragma mark Public Methods

- (void)start
{
    [self mjz_performTestWithFile:@"data_25MB.json"];
}

#pragma mark Private Methods

- (void)mjz_performTestWithFile:(NSString*)file
{
    MJZLog(@"** START");
    MJZLog(@"* File:\t\t\t%@", file);
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:[file stringByDeletingPathExtension] ofType:[file pathExtension]];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    MJZLog(@"* Size:\t\t\t%.02f KB", ((float)data.length / 1024.0f));
    
    __block NSDictionary *jsonDictionary = nil;
    
    NSTimeInterval deserializingTime = [self mjz_mesureBlock:^{
        NSError *error = nil;
        jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    }];
    
    MJZLog(@"* JSON time:\t%f seconds", deserializingTime);
    
    NSTimeInterval motisTime = [self mjz_mesureBlock:^{
        [self mjz_testMotisWithDictionary:jsonDictionary];
    }];
    MJZLog(@"* Motis time:\t%f seconds", motisTime);
    
    NSTimeInterval parserTime = [self mjz_mesureBlock:^{
        [self mjz_testParserWithDictionary:jsonDictionary];
    }];
    MJZLog(@"* Parser time:\t%f seconds", parserTime);
    
    MJZLog(@"** END");
}

- (void)mjz_testMotisWithDictionary:(NSDictionary*)dictionary
{
    MJCountry *country = [[MJCountry alloc] init];
    [country mts_setValuesForKeysWithDictionary:dictionary];
}

- (void)mjz_testParserWithDictionary:(NSDictionary*)dictionary
{
    MJCountry *country = nil;
    country = [MJParser parseCountry:dictionary];
}

- (NSTimeInterval)mjz_mesureBlock:(void(^)())block
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    block();
    NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate];
    
    return stop - start;
}

@end
