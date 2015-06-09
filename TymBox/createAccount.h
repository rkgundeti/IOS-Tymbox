//
//  createAccount.h
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface createAccount : UIViewController

{
   // NSString *selectedGender;
    NSDateFormatter *FormatDate;
    UIDatePicker *datePicker;

}
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (strong, nonatomic) IBOutlet NSString *selectedGender;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UITextField *birthYearTxtField;
@property (strong, nonatomic) NSString *accessToken;
- (IBAction)signupAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
- (IBAction)genderSegmentAction:(id)sender;
@end
