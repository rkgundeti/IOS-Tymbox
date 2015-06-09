//
//  HPTableViewCell.m
//  TymBox
//
//  Created by Vertex Offshore on 4/13/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "HPTableViewCell.h"

@implementation HPTableViewCell
@synthesize helperImage,helperName,addFriendBtn,requestsentBtn,pendingBtn,friendBtn;
- (void)awakeFromNib {
    // Initialization code
    addFriendBtn.layer.cornerRadius = 2;
    addFriendBtn.layer.borderWidth = 1;
    addFriendBtn.layer.borderColor = addFriendBtn.tintColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
