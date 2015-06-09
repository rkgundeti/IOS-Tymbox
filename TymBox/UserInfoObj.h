//
//  UserInfoObj.h
//  TymBox
//
//  Created by Rama Krishna Gundeti on 23/05/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UserInfoObj : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longiture;
@property (nonatomic, copy) UIImage *imageFile;
@property (nonatomic, copy) NSString *distance;

+ (id)newUser:(NSString *)userName userId:(NSString *)userId withImage:(UIImage *)imageFile latitude:(NSString *)latitude longiture:(NSString *)longiture distance:(NSString *)distance;

@end
