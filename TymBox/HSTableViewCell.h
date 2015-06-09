//
//  HSTableViewCell.h
//  TymBox030915
//
//  Created by Rama Krishna.G on 06/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *ratingbtn;

@end
