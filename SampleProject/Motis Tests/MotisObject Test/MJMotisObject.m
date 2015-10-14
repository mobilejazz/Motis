//
//  MJMotisObject.m
//  Motis
//
//  Created by Joan Martin on 14/10/15.
//  Copyright © 2015 Mobile Jazz. All rights reserved.
//

#import "MJMotisObject.h"
#import "NSObject+Motis.h"

@implementation MJMotisObject

+ (NSDictionary*)mts_mapping
{
    return @{@"string": mts_key(string),
             @"date": mts_key(date),
             @"url": mts_key(url),
             @"integer": mts_key(integer),
             };
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
        return NO;
    
    MJMotisObject *obj = object;
    
    if (![obj.string isEqualToString:_string])
        return NO;
    
    if (![obj.date isEqualToDate:_date])
        return NO;
    
    if (![obj.url isEqual:_url])
        return NO;
    
    if (obj.integer != _integer)
        return NO;
    
    return YES;
}

@end
