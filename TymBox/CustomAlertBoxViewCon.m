//
//  CustomAlertBoxViewCon.m
//  TymBox030915
//
//  Created by Rama Krishna.G on 11/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "CustomAlertBoxViewCon.h"

@interface CustomAlertBoxViewCon ()

@end

@implementation CustomAlertBoxViewCon
@synthesize doneBtn,messageLabel;

- (void)viewDidLoad
{
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:doneBtn];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:122.0/255.0 green:0.0 blue:1.0 alpha:1.0] forButton:self.cancelBtn];
    
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setRoundedBorder:(float)radius borderWidth:(float)borderWidth color:(UIColor*)color forButton:(UIButton *)button
{
    CALayer * l = [button layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:borderWidth];
    [l setBorderColor:[color CGColor]];
}


- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (IBAction)cancelPopup:(id)sender {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"Close" forKey:@"Info"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeNotification" object: dict];
    
    [self removeAnimate];
}

- (IBAction)closePopup:(id)sender {
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"Ok" forKey:@"Info"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeNotification" object: dict];
    [self removeAnimate];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView withImage:(UIImage *)image withMessage:(NSString *)message animated:(BOOL)animated messageType:(NSString *)msgType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        NSLog(@"msgType====%@",msgType);
        self.doneBtn.alpha = 0;
        self.cancelBtn.alpha = 0;
        if([msgType isEqualToString:@"Info"])
        {
            self.doneBtn.alpha = 1;
            
        }else if([msgType isEqualToString:@"Error"])
        {
            self.cancelBtn.alpha = 1;
        }
        //self.logoImg.image = image;
        self.messageLabel.text = message;
        if (animated) {
            [self showAnimate];
        }
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


