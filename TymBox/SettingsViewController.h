//
//  SettingsViewController.h
//  TymBox030915
//
//  Created by Bhagavan on 3/23/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController

- (IBAction)showMenu;

@property (weak, nonatomic) IBOutlet UIButton *notificationbtn;
@property (weak, nonatomic) IBOutlet UIButton *bankInfobtn;
@end
