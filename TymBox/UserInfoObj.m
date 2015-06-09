//
//  UserInfoObj.m
//  TymBox
//
//  Created by Rama Krishna Gundeti on 23/05/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "UserInfoObj.h"

@implementation UserInfoObj


@synthesize userName;
@synthesize userId;
@synthesize latitude;
@synthesize longiture;
@synthesize imageFile;
@synthesize distance;

+ (id)newUser:(NSString *)userName userId:(NSString *)userId withImage:(UIImage *)imageFile latitude:(NSString *)latitude longiture:(NSString *)longiture distance:(NSString *)distance
{
    UserInfoObj *newUser = [[self alloc]init];
    newUser.userName = userName;
    newUser.userId = userId;
    newUser.latitude = latitude;
    newUser.longiture = longiture;
    newUser.distance = distance;
    newUser.imageFile = imageFile;

    return newUser;
}

@end
