//
//  HelperTalentsViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 3/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperTalentsViewController : UITableViewController{

}
- (IBAction)addTalentsAction:(id)sender;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic)  BOOL comingFromShareTymbox;
@end
