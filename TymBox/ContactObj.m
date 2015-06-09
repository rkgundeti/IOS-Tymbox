//
//  ContactObj.m
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "ContactObj.h"
#import "ContactObj.h"

@implementation ContactObj

@synthesize firstName,lastName,fullName,homeEmail,workEmail,homePhone,workPhone;

+(id)newContact:(NSString *)name firstName:(NSString *)firstName lastName:(NSString *)lastName homeEmail:(NSString *)homeEmail workEmail:(NSString *)workEmail homePhone:(NSString *)homePhone workPhone:(NSString *)workPhone mobilePhone:(NSString *)mobilePhone userId:(NSString *)userId photo:(UIImage *)photo
{
    ContactObj *newContact = [[self alloc]init];
    newContact.fullName = name;
    newContact.firstName = firstName;
    newContact.lastName = lastName;
    newContact.workPhone = workPhone;
    newContact.homePhone = homePhone;
    newContact.workEmail = workEmail;
    newContact.mobilePhone=mobilePhone;
    newContact.workPhone = workPhone;
    newContact.userId = userId;
    newContact.photo = photo;
    
    return newContact;
}
@end
