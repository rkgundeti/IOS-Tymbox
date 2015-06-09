//
//  HelperOfferCell.h
//  TymBox
//
//  Created by Vertex Offshore on 4/21/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperOfferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seekerName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *seekerImage;
@property (weak, nonatomic) IBOutlet UILabel *whatYouSent;
@property (weak, nonatomic) IBOutlet UILabel *who;
@property (strong, nonatomic) IBOutlet UILabel *ratelbl;

@end
