//
//  offerAvalibilityTableViewCell.h
//  TymBox
//
//  Created by Vertex Offshore on 3/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface offerAvalibilityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *morningBtn;
@property (weak, nonatomic) IBOutlet UIButton *afterBtn;
@property (weak, nonatomic) IBOutlet UIButton *eveningBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@end
