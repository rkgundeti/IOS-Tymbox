//
//  HelperRequestCell.h
//  TymBox
//
//  Created by Vertex Offshore on 4/21/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seekerName;
@property (weak, nonatomic) IBOutlet UILabel *talentName;
@property (weak, nonatomic) IBOutlet UILabel *SeekorHelp;
@property (weak, nonatomic) IBOutlet UILabel *kindOfDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *ratelbl;

@property (weak, nonatomic) IBOutlet UILabel *reqDate;
@end
