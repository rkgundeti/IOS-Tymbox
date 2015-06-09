//
//  MyCustomCell.m
//  TymBox030915
//
//  Created by Bhagavan on 4/7/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "MyCustomCell.h"

@implementation MyCustomCell
@synthesize quantityLObl,priceLbl,expenseLbl,totalLbl,modifiedBy;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
