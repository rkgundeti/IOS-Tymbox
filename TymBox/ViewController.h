//
//  ViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 2/5/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
//#import "ShowProcessing.h"
@class GPPSignInButton;
@interface ViewController : UIViewController<NSURLConnectionDelegate,MBProgressHUDDelegate,FBLoginViewDelegate,GPPSignInDelegate,UIAlertViewDelegate>
{
    NSMutableData *_responseData;
    NSString *access_Token;
    MBProgressHUD *HUD;
   // ShowProcessing *show;
}
-(void)perform;
- (void)signOut;
- (void)createFaceBookAccount;
@property(assign,nonatomic) BOOL fbLoginPlz;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (strong, nonatomic) NSString *accToken;
@property (nonatomic,assign) BOOL  pressedFbLogin;
@property (strong, nonatomic) NSDictionary *fbUserDictionary;
@property (strong, nonatomic) NSString *FBFullNameString;
@property (strong, nonatomic) NSString *FBEmailIdString;
@property (strong, nonatomic) NSString *logINUserName;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)LoginBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@property (strong, nonatomic) IBOutlet UIButton *faceBookLoginButton;
- (IBAction)facebookLoginBtnTouched:(id)sender;

@property (weak, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

