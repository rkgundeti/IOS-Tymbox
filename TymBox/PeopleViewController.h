//
//  PeopleViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)segmentChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
