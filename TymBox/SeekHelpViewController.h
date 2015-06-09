//
//  SeekHelpViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 4/2/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeekHelpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *CategoryTxtField;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)unwindToList2:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UITextField *talentTxtField;
@end
