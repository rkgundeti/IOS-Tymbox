//
//  CounterTableViewCell.h
//  TymBox
//
//  Created by Vertex Offshore on 4/23/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *who;
@property (weak, nonatomic) IBOutlet UILabel *what;
@property (weak, nonatomic) IBOutlet UILabel *count;

@end
