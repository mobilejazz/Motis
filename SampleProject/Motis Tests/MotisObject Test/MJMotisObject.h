//
//  MJMotisObject.h
//  Motis
//
//  Created by Joan Martin on 14/10/15.
//  Copyright © 2015 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTSMotisObject.h"

@interface MJMotisObject : MTSMotisObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger integer;

@end
