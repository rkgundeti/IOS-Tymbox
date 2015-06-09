//
//  seekerObj.m
//  TymBox030915
//
//  Created by Bhagavan on 3/26/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "seekerObj.h"

@implementation seekerObj
@synthesize seekerName;
@synthesize seekerId;
@synthesize imageFile;
@synthesize rateType;
@synthesize rate;

+ (id) newSeeker:(NSString *)name seekerId:(NSString *)seekerId withImage:(UIImage *)imageFile rate:(NSString *)rate rateType:(NSString *)rateType
{
    seekerObj *newSeeker = [[self alloc]init];
    newSeeker.seekerName = name;
    newSeeker.seekerId = seekerId;
    newSeeker.imageFile = imageFile;
    newSeeker.rate = rate;
    newSeeker.rateType = rateType;
    return newSeeker;
}

@end
