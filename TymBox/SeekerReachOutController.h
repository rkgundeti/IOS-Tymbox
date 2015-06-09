//
//  SeekerReachOutController.h
//  TymBox
//
//  Created by Vertex Offshore on 4/2/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"
@interface SeekerReachOutController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray *helperDetailsArray;
@property (weak, nonatomic) IBOutlet UITextField *specificDateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *dateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *oneTxtFiels;
@property (weak, nonatomic) IBOutlet UITextField *jobTxtField;
@property (weak, nonatomic) IBOutlet UITextField *willingToPayTxtField;
@property (weak, nonatomic) IBOutlet UITextField *expenseTxtField;
@property (weak, nonatomic) IBOutlet UITextView *reachoutTxtView;
@property (weak, nonatomic) IBOutlet UITextField *toatlTxtField;
@property (weak, nonatomic) NSMutableDictionary *sendDictionary;
@property(strong,nonatomic) NSString *transType;
@property (strong, nonatomic) TransMasterObj *selectedObj;
@property (weak, nonatomic) IBOutlet UILabel *helperNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedTalent;


- (IBAction)ratetxtEndAction:(id)sender;
- (IBAction)expencetxtEndAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *avalibilityBtnAction;
- (IBAction)windiwBtnAction:(id)sender;


- (IBAction)reachOutAction:(id)sender;
@end




