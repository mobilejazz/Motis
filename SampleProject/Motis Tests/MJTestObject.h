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

@property (nonatomic, assign) NSInteger integerField;
@property (nonatomic, assign) NSUInteger unsignedIntegerField;

@property (nonatomic, assign) float floatField;
@property (nonatomic, assign) double doubleField;

@property (nonatomic, strong) NSString *stringField;
@property (nonatomic, strong) NSNumber *numberField;
@property (nonatomic, strong) NSURL *urlField;
@property (nonatomic, strong) NSDate *dateField;

@property (nonatomic, strong) id idField;
@property (nonatomic, strong) id <NSObject> idProtocolField;


// This property is not included in the mapping
@property (nonatomic, strong) NSString *privateStringField;
@property (nonatomic, assign) NSInteger privateIntegerField;

@end
