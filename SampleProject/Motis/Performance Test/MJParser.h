//
//  MJParser.h
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJCountry.h"
#import "MJCompany.h"
#import "MJPerson.h"
#import "MJProject.h"

@interface MJParser : NSObject

+ (MJCountry*)parseCountry:(NSDictionary*)json;
+ (MJCompany*)parseCompany:(NSDictionary*)json;
+ (MJPerson*)parsePerson:(NSDictionary*)json;
+ (MJProject*)parseProject:(NSDictionary*)json;

@end
