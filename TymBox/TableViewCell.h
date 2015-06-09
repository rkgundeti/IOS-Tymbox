//
//  TableViewCell.h
//  TableViewInsideCell
//
//  Created by Bushra on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"

@interface TableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource> {
    NSDictionary *data;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerView1;

@property (nonatomic, retain) IBOutlet UITableView *tableViewInsideCell;
@property (nonatomic, retain) NSDictionary *data;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UILabel *offeredToLbl;
@property (strong, nonatomic) IBOutlet UILabel *offeredTalentLbl;
@property (strong, nonatomic) IBOutlet UILabel *offeredDateLbl;

@property (strong, nonatomic) TransMasterObj *mainObj;


@end
