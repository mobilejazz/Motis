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

@property (nonatomic, assign) UInt8 unsigned8Field;
@property (nonatomic, assign) SInt8 signed8Field;
@property (nonatomic, assign) UInt16 unsigned16Field;
@property (nonatomic, assign) SInt16 signed16Field;
@property (nonatomic, assign) UInt32 unsigned32Field;
@property (nonatomic, assign) SInt32 signed32Field;
@property (nonatomic, assign) UInt64 unsigned64Field;
@property (nonatomic, assign) SInt64 signed64Field;

@property (nonatomic, assign) float floatField;
@property (nonatomic, assign) double doubleField;

@property (nonatomic, strong) NSString *stringField;
@property (nonatomic, strong) NSNumber *numberField;
@property (nonatomic, strong) NSURL *urlField;

@end
