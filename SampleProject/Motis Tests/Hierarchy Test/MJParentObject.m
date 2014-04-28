//
//  MJParentObject.m
//  Motis
//
//  Created by Joan Martin on 28/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJParentObject.h"

#import "Motis.h"

@implementation MJParentObject

+ (NSDictionary*)mts_mapping
{
    return @{@"id": mts_key(objectId),
             };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
