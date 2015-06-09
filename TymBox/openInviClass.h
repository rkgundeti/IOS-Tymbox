//
//  openInviClass.h
//  TymBox
//
//  Created by Vertex Offshore on 4/15/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface openInviClass : NSObject
@property(nonatomic,strong) NSString *invitationuserId;
@property(nonatomic,strong) NSString *dBId;
@property(nonatomic,strong) NSString *invitationuserName;
@property (strong,nonatomic) NSString *referType;
@property (strong, nonatomic) NSString *acceptedBy;
@property (strong, nonatomic) NSString *helperStatus;
@property (strong, nonatomic) NSString *seekerStatus;
@property (nonatomic, copy) UIImage *imageFile;
@property (strong, nonatomic) NSString *imgUrl;

@end
