//
//  MJMappingFinishedTestObject.m
//  Motis
//
//  Created by Rostyslav Druzhchenko on 12/6/16.
//  Copyright © 2016 Mobile Jazz. All rights reserved.
//

#import "MJMappingFinishedTestObject.h"

#import "Motis.h"

@implementation MJMappingFinishedTestObject

+ (NSDictionary*)mts_mapping
{
    return @{@"a": mts_key(a),
             @"b": mts_key(b)};
}

- (void)mts_setValuesForKeysWithDictionary:(NSDictionary*)dictionary
{
    [super mts_setValuesForKeysWithDictionary:dictionary];
    
    self.c = self.a + self.b;
}

@end
