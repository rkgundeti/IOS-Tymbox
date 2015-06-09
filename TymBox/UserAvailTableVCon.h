//
//  UserAvailTableVCon.h
//  TymBox030915
//
//  Created by Bhagavan on 3/9/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserAvailTableVCon : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *colorsTable;

- (IBAction)showMenu;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIView *nomatchesView;
@property (strong, nonatomic) NSString *actionType;
@property (strong, nonatomic) NSString *selectedHelperId;


@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;

@end
