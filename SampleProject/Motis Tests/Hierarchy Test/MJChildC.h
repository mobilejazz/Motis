//
//  MJChildC.h
//  Motis
//
//  Created by Finkel, Michael on 7/8/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJParentObject.h"

@interface MJChildC : MJParentObject
@property (nonatomic, assign) BOOL boolField;
@property (nonatomic, strong) NSString *customField;
@end
