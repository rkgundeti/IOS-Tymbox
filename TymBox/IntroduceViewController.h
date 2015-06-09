//
//  IntroduceViewController.h
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "REFrostedViewController.h"

@interface IntroduceViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *chooseTalentTxt;
@property (strong, nonatomic) IBOutlet UITextField *enterSeekerTxt;
@property (strong, nonatomic) IBOutlet UITextField *chooseSeekerTxt;
@property (strong, nonatomic) IBOutlet UITextField *enterHelperTxt;
@property (strong, nonatomic) IBOutlet UITextField *chooseHelperTxt;

//@property (strong, nonatomic) IBOutlet UIView *headerView1;
//
//@property (strong, nonatomic) IBOutlet UIView *headerView2;
//@property (strong, nonatomic) IBOutlet UIView *headerView3;
//@property (strong, nonatomic) IBOutlet UIView *headerView4;

- (IBAction)showMenu;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *chooseContactType;

@property (weak, nonatomic) IBOutlet UISwitch *helperOn;


@property (weak, nonatomic) IBOutlet UISegmentedControl *txtEmailSegment;
@property (weak, nonatomic) IBOutlet UIButton *helperbtn;


@property (weak, nonatomic) IBOutlet UISwitch *seekerOn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *txtEmailSeekerSegment;
@property (weak, nonatomic) IBOutlet UIButton *seekerbtn;

- (IBAction)helperSegment:(id)sender;
- (IBAction)seekerSegment:(id)sender;

- (IBAction)chooseHelperAction:(id)sender;

- (IBAction)chooseSeekerAction:(id)sender;
- (IBAction)introduceActionBtn:(id)sender;

- (IBAction)searchTalents:(id)sender;



@end
