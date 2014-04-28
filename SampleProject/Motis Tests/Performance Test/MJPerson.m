//
//  MJPerson.m
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJPerson.h"

#import "Motis.h"

@implementation MJPerson

+ (NSDictionary *)mts_mapping
{
    return @{@"id": mts_key(identifier),
             @"name": mts_key(name),
             @"email": mts_key(email),
             @"about": mts_key(about),
             @"age": mts_key(age),
             };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
