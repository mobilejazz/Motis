//
//  MJMotisObjectWithFormatter.m
//  Motis
//
//  Created by Joan Martin on 22/05/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJMotisObjectWithFormatter.h"

@implementation MJMotisObjectWithFormatter

+ (NSDateFormatter*)mts_validationDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return formatter;
}

@end
