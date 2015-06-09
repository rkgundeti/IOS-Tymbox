//
//  ContactObj.h
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ContactObj : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;
@property (nonatomic, strong) NSString *homePhone;
@property (nonatomic, strong) NSString *workPhone;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) UIImage *photo;

+ (id)newContact:(NSString *)name firstName:(NSString *)firstName lastName:(NSString *)lastName homeEmail:(NSString *)homeEmail workEmail:(NSString *)workEmail homePhone:(NSString *)homePhone workPhone:(NSString *)workPhone mobilePhone:(NSString *)mobilePhone userId:(NSString *)userId photo:(UIImage *)photo;

@end
