//
//  MJProject.m
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJProject.h"

#import "Motis.h"

@implementation MJProject

+ (NSDictionary *)mts_mapping
{
    return @{@"id": mts_key(identifier),
             @"project_name": mts_key(name),
             @"delivery_date": mts_key(deliveryDate),
             @"web": mts_key(website),
             @"people_size": mts_key(participantsCount),
             };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

@end
