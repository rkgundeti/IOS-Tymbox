//
//  OfferDetailViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 3/30/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"
@interface OfferDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong) NSString *comingFromCounter;
@property (strong, nonatomic) TransMasterObj *selectedObj;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *onSpecificDatetxtField;
@property (weak, nonatomic) IBOutlet UITextField *dateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *oneTxtField;
@property (weak, nonatomic) IBOutlet UITextField *priceTxtField;
@property (weak, nonatomic) IBOutlet UITextField *expenseTxtField;
@property (weak, nonatomic) IBOutlet UITextField *totalTxtField;
- (IBAction)declineBtnAction:(id)sender;
- (IBAction)counterBtnAction:(id)sender;
- (IBAction)acceptBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *jobCompleteBtn;
- (IBAction)jobCompleteBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *offerDetailTxtView;
- (IBAction)sendUpdateBtnAction:(id)sender;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UITextField *jobTxtField;
@property (weak, nonatomic) IBOutlet UILabel *helperlabel;
@property (weak, nonatomic) IBOutlet UILabel *talentLabel;
@property(strong,nonatomic) NSMutableArray *helperTransactionArray;
@property (weak, nonatomic) IBOutlet UIButton *repriceJOb;
@property(strong,nonatomic) NSString *commitment;
@property(strong,nonatomic) NSString *counter;
@property (weak, nonatomic) IBOutlet UIButton *declineBtn;
@property (weak, nonatomic) IBOutlet UIButton *counterBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelJob;
@property (weak, nonatomic) IBOutlet UIButton *resheduleJob;
@property (weak, nonatomic) IBOutlet UILabel *ULabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@end
