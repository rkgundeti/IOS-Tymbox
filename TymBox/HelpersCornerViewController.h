//
//  HelpersCornerViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 2/18/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface HelpersCornerViewController : UIViewController
{
 MBProgressHUD *HUD;

}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)offerHelpBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *offerHelpButton;
@property (weak, nonatomic) IBOutlet UIButton *openOffersButton;
@property (weak, nonatomic) IBOutlet UIButton *openInvitationsButton;
@property (weak, nonatomic) IBOutlet UIButton *myCommitmentsButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveFeedbackButton;
@property(strong,nonatomic) NSString *whoIsHe;

@end
