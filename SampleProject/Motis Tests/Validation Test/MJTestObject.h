//
//  MJTestObject0.h
//  Motis
//
//  Created by Joan Martin on 22/05/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJTestMotisMappingObject;

typedef NS_ENUM(NSUInteger, MJUnsignedEnum)
{
    MJUnsignedEnumZero,
    MJUnsignedEnumOne,
    MJUnsignedEnumTwo,
    MJUnsignedEnumThree
};

typedef NS_ENUM(NSInteger, MJSignedEnum)
{
    MJSignedEnumZero,
    MJSignedEnumOne,
    MJSignedEnumTwo,
    MJSignedEnumThree
};

@interface MJTestObject : NSObject

@property (nonatomic, assign) NSInteger integerField;
@property (nonatomic, assign) NSUInteger unsignedIntegerField;

@property (nonatomic, assign) float floatField;
@property (nonatomic, assign) double doubleField;
@property (nonatomic, assign) BOOL boolField;

@property (nonatomic, strong) NSString *stringField;
@property (nonatomic, strong) NSNumber *numberField;
@property (nonatomic, strong) NSURL *urlField;
@property (nonatomic, strong) NSDate *dateField;

@property (nonatomic, strong) id idField;
@property (nonatomic, strong) id <NSObject> idProtocolField;

@property (nonatomic, strong) NSString *privateStringField;
@property (nonatomic, assign) NSInteger privateIntegerField;

@property (nonatomic, strong) MJTestObject *testObject;
@property (nonatomic, strong) MJTestMotisMappingObject *motisObject;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *objectArray;
@property (nonatomic, strong) NSArray *stringsArray;
@property (nonatomic, strong) NSArray *numbersArray;
@property (nonatomic, strong) NSArray *urlsArray;
@property (nonatomic, strong) NSArray *datesArray;

@property (nonatomic, assign) MJUnsignedEnum unsignedEnum;
@property (nonatomic, assign) MJSignedEnum signedEnum;

@property (nonatomic, assign) NSInteger array0Integer;
@property (nonatomic, assign) NSInteger array1Integer;
@property (nonatomic, assign) NSInteger array2Integer;

@property (nonatomic, strong) NSString *array0String;
@property (nonatomic, strong) NSString *array1String;
@property (nonatomic, strong) NSString *array2String;

@property (nonatomic, strong) MJTestMotisMappingObject *array0Object;
@property (nonatomic, strong) MJTestMotisMappingObject *array1Object;
@property (nonatomic, strong) MJTestMotisMappingObject *array2Object;

@property (nonatomic, assign) NSInteger integerArray0;
@property (nonatomic, assign) NSInteger integerArray1;
@property (nonatomic, assign) NSInteger integerArray2;

@property (nonatomic, strong) NSString *stringArray0;
@property (nonatomic, strong) NSString *stringArray1;
@property (nonatomic, strong) NSString *stringArray2;

@end
