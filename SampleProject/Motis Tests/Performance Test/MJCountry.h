//
//  MJCountry.h
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJCompany.h"

@interface MJCountry : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *companies;

@end
