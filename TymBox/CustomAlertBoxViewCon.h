//
//  CustomAlertBoxViewCon.h
//  TymBox030915
//
//  Created by Rama Krishna.G on 11/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface CustomAlertBoxViewCon : UIViewController


@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (void)showInView:(UIView *)aView withImage:(UIImage *)image withMessage:(NSString *)message animated:(BOOL)animated messageType:(NSString *)msgType;

@end
