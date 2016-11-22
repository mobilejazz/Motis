//
//  MJCalculatedObject.m
//  Motis
//
//  Created by Rostyslav Druzhchenko on 11/22/16.
//  Copyright © 2016 Mobile Jazz. All rights reserved.
//

#import "MJCalculatedObject.h"

#import "Motis.h"

@implementation MJCalculatedObject

+ (NSDictionary *)mts_mapping {

    return @{ @"a" : mts_key(a),
              @"b" : mts_key(b) };
}

- (void)mts_setValuesForKeysWithDictionaryDidFinish {

    self.c = self.a + self.b;
}

@end
