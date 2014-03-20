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
                    
                    @"unsigned_8":  @"unsigned8Field",
                    @"signed_8":    @"signed8Field",
                    @"unsigned_16": @"unsigned16Field",
                    @"signed_16":   @"signed16Field",
                    @"unsigned_32": @"unsigned32Field",
                    @"signed_32":   @"signed32Field",
                    @"unsigned_64": @"unsigned64Field",
                    @"signed_64":   @"signed64Field",
                    
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

- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"setting nil value for key : %@", key);
}

- (void)mjz_invalidValue:(id)value forKey:(NSString *)key error:(NSError *)error
{
    NSLog(@"INVALID VALUE %@ FOR KEY %@", [value description], key);
}

@end
