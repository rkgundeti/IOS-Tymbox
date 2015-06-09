//
//  ProfileViewController.h
//  TymBox030915
//
//  Created by Bhagavan on 3/23/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RadioButton.h"
#import "CustomAlertBoxViewCon.h"

@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) CustomAlertBoxViewCon *popViewController;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *pinCode;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *UID;
@property (strong, nonatomic) NSString *UDID;
@property (weak, nonatomic) IBOutlet UIImageView *PhotoImg;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
- (IBAction)showCalendar:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userNametxt;
@property (weak, nonatomic) IBOutlet UILabel *emailIdlbl;
@property (weak, nonatomic) IBOutlet UITextField *phonetxt;
@property (weak, nonatomic) IBOutlet UILabel *addresslbl;
@property (weak, nonatomic) IBOutlet UIButton *addressbtn;
@property (weak, nonatomic) IBOutlet UITextField *yeartxt;
@property (strong, nonatomic) NSString *strGender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderstr;
- (IBAction)genderAction:(id)sender;
- (IBAction)updateAction:(id)sender;
- (IBAction)addAddressAction:(id)sender;
- (IBAction)chnageImage:(id)sender;


- (IBAction)profileAction:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *profileSwitch;
- (IBAction)onRadioAction:(id)sender;

@property (nonatomic, strong) IBOutlet RadioButton* privateButton;
@property (weak, nonatomic) IBOutlet RadioButton *publicButton;


@property (strong, nonatomic) NSString *navigateFrom;


@end
