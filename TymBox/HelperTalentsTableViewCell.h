//
//  HelperTalentsTableViewCell.h
//  TymBox
//
//  Created by Vertex Offshore on 3/16/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperTalentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *talentName;
@property (weak, nonatomic) IBOutlet UILabel *rateTxtField;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@end
