//
//  SeekHelpEntryScreen.h
//  TymBox
//
//  Created by Vertex Offshore on 5/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeekHelpEntryScreen : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)segmentSelection:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
