//
//  TVCellWithOutChilds.h
//  TymBox030915
//
//  Created by Bhagavan on 4/13/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransMasterObj.h"

@interface TVCellWithOutChilds : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerView1;


@property (strong, nonatomic) IBOutlet UILabel *offeredToLbl;
@property (strong, nonatomic) IBOutlet UILabel *offeredTalentLbl;
@property (strong, nonatomic) IBOutlet UILabel *offeredDateLbl;


@property (strong, nonatomic) IBOutlet UILabel *QtyLblValue;
@property (strong, nonatomic) IBOutlet UILabel *PriceLblValue;
@property (strong, nonatomic) IBOutlet UILabel *ExpenseLblValue;
@property (strong, nonatomic) IBOutlet UILabel *TotLblValue;

@end
