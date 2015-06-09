//
//  HistoryTVController.h
//  TymBox
//
//  Created by Rama Krishna Gundeti on 01/06/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"

@interface HistoryTVController : UITableViewController

@property(strong,nonatomic) NSMutableArray *detailArray;
@property (strong, nonatomic) TransMasterObj *counterObj;

- (IBAction)gobackBtnAction:(id)sender;

@end
