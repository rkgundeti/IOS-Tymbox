//
//  selectedObject.h
//  TymBox030915
//
//  Created by Bhagavan on 4/2/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface selectedObject : NSObject

@property (nonatomic, copy) NSString *seekerName;
@property (nonatomic, copy) NSString *seekerId;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) UIImage *imageFile;
@property (nonatomic, copy) NSString *rateType;
@property (nonatomic, copy) NSString *talentName;
@property (nonatomic, copy) NSString *talentId;
@property (nonatomic, copy) NSString *talentsCount;
@property (strong, nonatomic) NSString *imgUrl;

+ (id)newSeeker:(NSString *)name seekerId:(NSString *)seekerId withImage:(UIImage *)imageFile rate:(NSString *)rate details:(NSString *)details rateType:(NSString *)rateType talentName:(NSString *)talentName talentId:(NSString *)talentId talentsCount:(NSString *)talentsCount imgUrl:(NSString *)imgUrl;

@end
