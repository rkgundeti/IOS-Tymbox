//
//  CounterHistoryCell.h
//  TymBox
//
//  Created by Vertex Offshore on 4/23/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;
@end
