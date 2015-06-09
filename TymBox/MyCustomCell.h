//
//  MyCustomCell.h
//  TymBox030915
//
//  Created by Bhagavan on 4/7/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *quantityLObl;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;

@property (strong, nonatomic) IBOutlet UILabel *expenseLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalLbl;
@property (strong, nonatomic) IBOutlet UILabel *modifiedBy;

@end
