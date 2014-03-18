//
//  MJTestObject.h
//  Motis
//
//  Created by Joan Martin on 18/03/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJTestObject : NSObject

@property (nonatomic, assign) BOOL boolField;
@property (nonatomic, assign) char charField;
@property (nonatomic, assign) unsigned char unsignedCharField;
@property (nonatomic, assign) short shortField;
@property (nonatomic, assign) unsigned short unsignedShortField;
@property (nonatomic, assign) int intField;
@property (nonatomic, assign) unsigned int unsignedIntField;
@property (nonatomic, assign) long longField;
@property (nonatomic, assign) unsigned long unsignedLongField;
@property (nonatomic, assign) long long longLongField;
@property (nonatomic, assign) unsigned long long unsignedLongLongField;
@property (nonatomic, assign) float floatField;
@property (nonatomic, assign) double doubleField;

@property (nonatomic, strong) NSString *stringField;
@property (nonatomic, strong) NSNumber *numberField;

@end
