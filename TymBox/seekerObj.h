//
//  seekerObj.h
//  TymBox030915
//
//  Created by Bhagavan on 3/26/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface seekerObj : NSObject{
    NSString *seekerName;
    NSString *seekerId;
    UIImage *imageFile;
}

@property (nonatomic, copy) NSString *seekerName;
@property (nonatomic, copy) NSString *seekerId;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *rateType;
@property (nonatomic, copy) UIImage *imageFile;

+ (id)newSeeker:(NSString *)name seekerId:(NSString *)seekerId withImage:(UIImage *)imageFile rate:(NSString *)rate rateType:(NSString *)rateType;

@end
