//
//  entryScreenViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface entryScreenViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UIButton *helperButton;
@property (weak, nonatomic) IBOutlet UIButton *seekerButton;
- (IBAction)HelperBtnAction:(id)sender;
- (IBAction)seekerBtnAction:(id)sender;
@property(nonatomic,strong) NSString *check;
@property(nonatomic,strong) NSString *userType;
@property (strong, nonatomic) IBOutlet UILabel *lblQuote;

@end
