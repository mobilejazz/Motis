//
//  MJParser.m
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJParser.h"

@implementation MJParser

+ (MJCountry*)parseCountry:(NSDictionary*)json
{
    MJCountry *country = [[MJCountry alloc] init];
    
    if ([json objectForKey:@"id"] != [NSNull null])
        country.identifier = [[json objectForKey:@"id"] integerValue];
    else
        country.identifier = 0;
    
    if ([json objectForKey:@"country_name"] != [NSNull null])
        country.name = [json objectForKey:@"country_name"];
    else
        country.name = nil;
    
    if ([json objectForKey:@"country_companies"] != [NSNull null])
    {
        NSArray *rawCompanies = [json objectForKey:@"country_companies"];
        NSMutableArray *companies = [NSMutableArray arrayWithCapacity:rawCompanies.count];
        
        for (NSDictionary *rawCompany in rawCompanies)
        {
            MJCompany *company = [self parseCompany:rawCompany];
            if (company)
                [companies addObject:company];
        }
        
        country.companies = [companies copy];
    }
    else
        country.companies = nil;
    
    return country;
}

+ (MJCompany*)parseCompany:(NSDictionary*)json
{
    // TODO
    return nil;
}

+ (MJPerson*)parsePerson:(NSDictionary*)json
{
    // TODO
    return nil;
}

+ (MJProject*)parseProject:(NSDictionary*)json
{
    // TODO
    return nil;
}

@end
