//
//  HPTableViewCell.h
//  TymBox
//
//  Created by Vertex Offshore on 4/13/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *helperImage;
@property (weak, nonatomic) IBOutlet UILabel *helperName;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;
@property (strong, nonatomic) IBOutlet UIButton *requestsentBtn;
@property (strong, nonatomic) IBOutlet UIButton *pendingBtn;
@property (strong, nonatomic) IBOutlet UIButton *friendBtn;

@end
