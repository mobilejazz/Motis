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
    
    if (json[@"id"] != [NSNull null])
        country.identifier = [json[@"id"] integerValue];
    else
        country.identifier = 0;
    
    if (json[@"country_name"] != [NSNull null])
        country.name = json[@"country_name"];
    else
        country.name = nil;
    
    if (json[@"country_companies"] != [NSNull null])
    {
        NSArray *rawCompanies = json[@"country_companies"];
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
    MJCompany *company = [[MJCompany alloc] init];
    
    if (json[@"id"] != [NSNull null])
        company.identifier = [json[@"id"] integerValue];
    else
        company.identifier = 0;
    
    if (json[@"is_active"] != [NSNull null])
        company.isActive = [json[@"is_active"] boolValue];
    else
        company.isActive = NO;
    
    if (json[@"yearly_income"] != [NSNull null])
        company.yearlyIncome = [json[@"yearly_income"] floatValue];
    else
        company.yearlyIncome = 0.0f;
    
    if (json[@"previous_year_income"] != [NSNull null])
        company.previousYearIncome = [json[@"previous_year_income"] floatValue];
    else
        company.previousYearIncome = 0.0f;
    
    if (json[@"company_name"] != [NSNull null])
        company.name = json[@"company_name"];
    else
        company.name = nil;
    
    if (json[@"company_address"] != [NSNull null])
        company.address = json[@"company_address"];
    else
        company.address = nil;
    
    if (json[@"company_url"] != [NSNull null])
        company.website = [NSURL URLWithString:json[@"company_url"]];
    else
        company.website = nil;
    
    if (json[@"company_ceo"] != [NSNull null])
    {
        NSDictionary *rawCeo = json[@"company_ceo"];
        company.ceoName = rawCeo[@"name"];
        company.ceo = [self parsePerson:rawCeo];
    }
    else
    {
        company.ceoName = nil;
        company.ceo = nil;
    }
    
    if (json[@"company_employees"] != [NSNull null])
    {
        NSArray *rawEmployees = json[@"company_employees"];
        NSMutableArray *employees = [NSMutableArray arrayWithCapacity:rawEmployees.count];
        for (NSDictionary *dict in rawEmployees)
        {
            MJPerson *person = [self parsePerson:dict];
            if (person)
                [employees addObject:person];
        }
        company.employees = [employees copy];
    }
    else
        company.employees = nil;
    
    if (json[@"current_projects"] != [NSNull null])
    {
        NSArray *rawProjects = json[@"current_projects"];
        NSMutableArray *projects = [NSMutableArray arrayWithCapacity:rawProjects.count];
        for (NSDictionary *dict in rawProjects)
        {
            MJProject *project = [self parseProject:dict];
            if (project)
                [projects addObject:project];
        }
        company.currentProjects = [projects copy];
    }
    else
        company.currentProjects = nil;
    
    if (json[@"finished_projects"] != [NSNull null])
    {
        NSArray *rawProjects = json[@"finished_projects"];
        NSMutableArray *projects = [NSMutableArray arrayWithCapacity:rawProjects.count];
        for (NSDictionary *dict in rawProjects)
        {
            MJProject *project = [self parseProject:dict];
            if (project)
                [projects addObject:project];
        }
        company.finishedProjects = [projects copy];
    }
    else
        company.finishedProjects = nil;
    
    return company;
}

+ (MJPerson*)parsePerson:(NSDictionary*)json
{
    MJPerson *person = [[MJPerson alloc] init];
    
    if (json[@"id"] != [NSNull null])
        person.identifier = [json[@"id"] integerValue];
    else
        person.identifier = 0;
    
    if (json[@"name"] != [NSNull null])
        person.name = json[@"name"];
    else
        person.name = nil;
    
    if (json[@"email"] != [NSNull null])
        person.email = json[@"email"];
    else
        person.email = nil;
    
    if (json[@"about"] != [NSNull null])
        person.about = json[@"about"];
    else
        person.about = nil;
    
    if (json[@"age"] != [NSNull null])
        person.age = [json[@"age"] integerValue];
    else
        person.age = 0;
    
    return person;
}

+ (MJProject*)parseProject:(NSDictionary*)json
{    
    MJProject *project = [[MJProject alloc] init];
    
    if (json[@"id"] != [NSNull null])
        project.identifier = [json[@"id"] integerValue];
    else
        project.identifier = 0;
    
    if (json[@"project_name"] != [NSNull null])
        project.name = json[@"project_name"];
    else
        project.name = nil;
    
    if (json[@"delivery_date"] != [NSNull null])
    {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        });
        
        project.deliveryDate = [dateFormatter dateFromString:json[@"delivery_date"]];
    }
    else
        project.deliveryDate = nil;
    
    if (json[@"web"] != [NSNull null])
        project.website = [NSURL URLWithString:json[@"web"]];
    else
        project.website = nil;
    
    if (json[@"people_size"] != [NSNull null])
        project.participantsCount = [json[@"people_size"] integerValue];
    else
        project.participantsCount = 0;

    return project;
}

@end
