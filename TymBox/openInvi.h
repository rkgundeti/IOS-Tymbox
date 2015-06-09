//
//  openInvi.h
//  TymBox
//
//  Created by Vertex Offshore on 4/15/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface openInvi : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (strong, nonatomic) IBOutlet UILabel *statusLbl;

@end
