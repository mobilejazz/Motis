//
//  MJProject.h
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJProject : NSObject

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *deliveryDate;
@property (nonatomic, strong) NSURL *website;

@property (nonatomic, assign) NSInteger participantsCount;

@end
