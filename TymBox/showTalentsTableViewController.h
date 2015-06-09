//
//  showTalentsTableViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 3/7/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showTalentsTableViewController : UITableViewController
@property (strong, nonatomic) NSString *selectedIdToShow;

@property (strong, nonatomic) NSString *TalentId;
@property (nonatomic) NSInteger *idValue;
@property (strong,nonatomic) NSString *selectedTalent;
@property(nonatomic,strong) NSString *nameString;
@end
