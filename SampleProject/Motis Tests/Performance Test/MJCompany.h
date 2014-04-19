//
//  MJCompany.h
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJPerson.h"
#import "MJProject.h"

@interface MJCompany : NSObject

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) CGFloat yearlyIncome;
@property (nonatomic, assign) CGFloat previousYearIncome;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSURL *website;

@property (nonatomic, strong) NSString *ceoName;

@property (nonatomic, strong) MJPerson *ceo;
@property (nonatomic, strong) NSArray *employees;

@property (nonatomic, strong) NSArray *currentProjects;
@property (nonatomic, strong) NSArray *finishedProjects;

@end
