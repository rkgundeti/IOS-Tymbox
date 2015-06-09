//
//  offerHelpViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 3/23/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"
#import "OfferObject.h"

@interface offerHelpViewController : UIViewController<UITextFieldDelegate>
{
    NSDateFormatter *FormatDate;
    UIDatePicker *datePicker;
    OfferObject *offObject;
}
- (IBAction)ratetxtEndAction:(id)sender;
- (IBAction)expencetxtEndAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oneTxtField;

@property(strong,nonatomic)   OfferObject *offObject;

@property (weak, nonatomic) NSMutableDictionary *ReceivedDictionary;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)helpWithWhatAtion:(id)sender;
@property (strong, nonatomic) TransMasterObj *selectedObj;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UITextField *talentTxtField;
@property (weak, nonatomic) IBOutlet UITextField *seekerTxtField;
- (IBAction)tymBoxAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *MorningTxtField;
@property (weak, nonatomic) IBOutlet UITextField *hoursTxtField;
@property (weak, nonatomic) IBOutlet UITextField *helpWhenTxtField;
- (IBAction)btnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UIButton *calnderBtn;
- (IBAction)tapAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *costTxtField;
@property (weak, nonatomic) IBOutlet UITextField *expenseTxtField;
@property (weak, nonatomic) IBOutlet UITextField *totalTxtField;
@property (weak, nonatomic) IBOutlet UIButton *oneTimeOfferButton;
@property (weak, nonatomic) IBOutlet UIButton *recuringOfferButton;
- (IBAction)offerHelpButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *postCommentsTxtView;
@property(strong,nonatomic) NSString *transType;
@property(strong,nonatomic) NSString *getHelperId;
- (IBAction)pickWindow:(id)sender;



@end
