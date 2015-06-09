//
//  SeekerPFViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 4/29/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"
@interface SeekerPFViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TransMasterObj *selectedObj;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *seekerName;
@property (weak, nonatomic) IBOutlet UILabel *talentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tymboxDate;
@property (weak, nonatomic) IBOutlet UILabel *actualDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
- (IBAction)postFeedbackBtnAction:(id)sender;
@end
