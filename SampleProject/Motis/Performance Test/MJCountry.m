//
//  MJCountry.m
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJCountry.h"

#import "Motis.h"

@implementation MJCountry

+ (NSDictionary *)mts_mapping
{
    return @{@"id": mts_key(identifier),
             @"country_name": mts_key(name),
             @"country_companies": mts_key(companies),
             };
}

+ (NSDictionary *)mts_arrayClassMapping
{
    return @{mts_key(companies): MJCompany.class};
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[%@ - identifier:%ld - name:%@ - companies:%@]", [super description], (long)_identifier, _name, _companies.description];
}

@end
