//
//  MJPerson.h
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJPerson : NSObject

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *about;

@property (nonatomic, assign) NSInteger age;

@end
