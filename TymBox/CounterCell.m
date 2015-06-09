//
//  CounterCell.m
//  TymBox
//
//  Created by Rama Krishna Gundeti on 01/06/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "CounterCell.h"

@implementation CounterCell
@synthesize talentNamelbl;
@synthesize talentRatelbl;
@synthesize jobDatelbl;
@synthesize userNamelbl;
@synthesize userImg;
@synthesize counterAmtlbl;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
