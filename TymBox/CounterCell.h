//
//  CounterCell.h
//  TymBox
//
//  Created by Rama Krishna Gundeti on 01/06/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *talentNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *talentRatelbl;
@property (strong, nonatomic) IBOutlet UILabel *jobDatelbl;
@property (strong, nonatomic) IBOutlet UILabel *userNamelbl;
@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *counterAmtlbl;
@property (strong, nonatomic) IBOutlet UIButton *counterBtn;

@end
