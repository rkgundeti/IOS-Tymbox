//
//  selectedObject.m
//  TymBox030915
//
//  Created by Bhagavan on 4/2/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "selectedObject.h"

@implementation selectedObject

@synthesize seekerName;
@synthesize seekerId;
@synthesize imageFile,talentsCount;
@synthesize rate,details,rateType,talentId,talentName,imgUrl;


+ (id) newSeeker:(NSString *)name seekerId:(NSString *)seekerId withImage:(UIImage *)imageFile rate:(NSString *)rate details:(NSString *)details rateType:(NSString *)rateType talentName:(NSString *)talentName talentId:(NSString *)talentId talentsCount:(NSString *)talentsCount imgUrl:(NSString *)imgUrl
{
    selectedObject *newSeeker = [[self alloc]init];
    newSeeker.seekerName = name;
    newSeeker.seekerId = seekerId;
    newSeeker.imageFile = imageFile;
    newSeeker.rate = rate;
    newSeeker.details = details;
    newSeeker.rateType = rateType;
    newSeeker.talentName = talentName;
    newSeeker.talentId = talentId;
    newSeeker.talentsCount = talentsCount;
    newSeeker.imgUrl = imgUrl;
    return newSeeker;
}

@end
