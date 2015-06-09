//
//  ContactTVCell.h
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *contactImage;
@property (strong, nonatomic) IBOutlet UILabel *fullnamelbl;
@property (strong, nonatomic) IBOutlet UILabel *phonelbl;
@property (strong, nonatomic) IBOutlet UILabel *emaillbl;
@end
