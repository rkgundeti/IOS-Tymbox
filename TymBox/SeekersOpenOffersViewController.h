//
//  SeekersOpenOffersViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 4/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeekersOpenOffersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)SegmentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

@end
