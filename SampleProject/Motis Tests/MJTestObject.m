//
//  MJTestObject.m
//  Motis
//
//  Created by Joan Martin on 18/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJTestObject.h"

#import "NSObject+Motis.h"

@implementation MJTestObject

- (NSDictionary*)mjz_motisMapping
{
    static NSDictionary *mapping = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{@"bool": @"boolField",
                    
                    @"integer": @"integerField",
                    @"unsigned_integer": @"unsignedIntegerField",
                    
                    @"float": @"floatField",
                    @"double": @"doubleField",
                    
                    @"string": @"stringField",
                    @"number": @"numberField",
                    @"url": @"urlField",
                    };
    });
    
    return mapping;
}

+ (BOOL)mjz_motisShouldSetUndefinedKeys
{
    return NO;
}

- (void)mjz_invalidValue:(id)value forKey:(NSString *)key error:(NSError *)error
{
    NSLog(@"INVALID VALUE %@ FOR KEY %@", [value description], key);
}

- (void)mjz_nullValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"boolField"])
        _boolField = NO;
}

@end
