//
//  MJChildA.m
//  Motis
//
//  Created by Joan Martin on 28/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJChildA.h"

#import "Motis.h"

@implementation MJChildA

+ (NSDictionary*)mts_mapping
{
    return @{@"bool": mts_key(boolField),
             @"field": mts_key(customField),
             };
}

@end
