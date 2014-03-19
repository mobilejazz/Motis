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
                    @"char": @"charField",
                    @"unsigned_char": @"unsignedCharField",
                    @"short": @"shortField",
                    @"unsigned_short": @"unsignedShortField",
                    @"int": @"intField",
                    @"unsigned_int": @"unsignedIntField",
                    @"long": @"longField",
                    @"unsigned_long": @"unsignedLongField",
                    @"long_long": @"longLongField",
                    @"unsigned_long_long": @"unsignedLongLongField",
                    @"float": @"floatField",
                    @"double": @"doubleField",
                    @"string": @"stringField",
                    @"number": @"numberField",
                    @"url": @"urlField",
                    };
    });
    
    return mapping;
}

+ (MJZMotisMappingClearance)mjz_motisMappingClearance
{
    return MJZMotisMappingClearanceRestricted;
}

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"setting nil value for key : %@", key);
}

- (void)mjz_invalidValue:(id)value forKey:(NSString *)key error:(NSError *)error
{
    NSLog(@"INVALID VALUE %@ FOR KEY %@", [value description], key);
}

@end
