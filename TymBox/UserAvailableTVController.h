//
//  UserAvailableTVController.h
//  TymBox030915
//
//  Created by Bhagavan on 3/11/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAvailableTVController : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *Day;

@property (weak, nonatomic) IBOutlet UIButton *morningSelect;
@property (weak, nonatomic) IBOutlet UIButton *afternoonSelect;
@property (weak, nonatomic) IBOutlet UIButton *eveningSelect;

@end
