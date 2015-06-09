//
//  MyTalentsViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 2/27/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCatTalentObj.h"


@interface MyTalentsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{

    UIPickerView *TalentsSelectPickerView;
    NSMutableArray *TalentsList;
    
    NSDateFormatter *FormatDate;
   
   
    __weak IBOutlet UITextView *snippetTxtView;

}
@property (assign, nonatomic) BOOL comingFromOfferHelp;
@property (strong, nonatomic) NSMutableDictionary *existsTalents;

@property (strong, nonatomic) IBOutlet UIButton *talentsButton;
@property (strong, nonatomic) IBOutlet UIButton *addTalentsBtn;

@property (strong, nonatomic) NSString *addorUpdateAction;
@property (strong, nonatomic) UserCatTalentObj *selectedTalentObj;
@property (strong, nonatomic) IBOutlet UIView *talentsBtn;
@property (weak, nonatomic) IBOutlet UITextField *perTxtField;
@property (weak, nonatomic) IBOutlet UITextView *snippetTxtView;
@property(nonatomic,assign) BOOL update;
@property (weak, nonatomic) IBOutlet UITextField *rateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *snippetTxtField;
- (IBAction)cancelBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *talentLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldTalent;

- (IBAction)talentsBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTalentTxtFeild;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@property (nonatomic, retain) UIPickerView *TalentsSelectPickerView;
@property (nonatomic, retain)  NSArray *TalentsList;
@property (weak, nonatomic) IBOutlet UIButton *displayAllTheTalentsBtn;
- (IBAction)displayAllTheTalentsBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
- (IBAction)AddTalentsBtnAction:(id)sender;

- (IBAction)unwindToList2:(UIStoryboardSegue *)segue;
@end
