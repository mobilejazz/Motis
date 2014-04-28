//
//  MJChildB.m
//  Motis
//
//  Created by Joan Martin on 28/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJChildB.h"

#import "Motis.h"

@implementation MJChildB

+ (NSDictionary*)mts_mapping
{
    return @{@"integer": mts_key(integerField),
             @"field": mts_key(customField),
             };
}

@end
