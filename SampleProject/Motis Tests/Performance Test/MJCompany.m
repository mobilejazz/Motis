//
//  MJCompany.m
//  Motis
//
//  Created by Joan Martin on 18/04/14.
//  Copyright (c) 2014 Mobile Jazz. All rights reserved.
//

#import "MJCompany.h"

#import "Motis.h"

@implementation MJCompany

+ (NSDictionary *)mts_mapping
{
    return @{@"id": mts_key(identifier),
             @"is_active": mts_key(isActive),
             @"yearly_income": mts_key(yearlyIncome),
             @"previous_year_income": mts_key(previousYearIncome),
             @"company_name": mts_key(name),
             @"company_address": mts_key(address),
             @"company_url": mts_key(website),
             @"company_ceo.name": mts_key(ceoName),
             @"company_ceo": mts_key(ceo),
             @"company_employees": mts_key(employees),
             @"current_projects": mts_key(currentProjects),
             @"finished_projects": mts_key(finishedProjects),
            };
}

+ (NSDictionary *)mts_arrayClassMapping
{
    return @{mts_key(employees): MJPerson.class,
             mts_key(currentProjects): MJProject.class,
             mts_key(finishedProjects): MJProject.class,
             };
}

+ (BOOL)mts_shouldSetUndefinedKeys
{
    return NO;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[%@ - identifier:%ld - isActive:%ld - yearlyIncome:%f - previousYearIncome:%f - name:%@]", [super description], (long)_identifier, (long)_isActive, _yearlyIncome, _previousYearIncome, _name];
}

@end
