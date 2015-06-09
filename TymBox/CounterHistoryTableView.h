//
//  CounterHistoryTableView.h
//  TymBox
//
//  Created by Vertex Offshore on 4/23/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"
@interface CounterHistoryTableView : UITableViewController
@property(strong,nonatomic) NSMutableArray *detailArray;
@property (strong, nonatomic) TransMasterObj *counterObj;
@end
