//
//  openInvitationsViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 4/15/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertBoxViewCon.h"
@interface openInvitationsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *custtableView;

@property (strong, nonatomic) CustomAlertBoxViewCon *alertViewController;

@end
