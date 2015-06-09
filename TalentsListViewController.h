//
//  TalentsListViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 3/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"

@interface TalentsListViewController : UITableViewController<CustomIOS7AlertViewDelegate>


@property (strong, nonatomic) NSString *selectedCategory;
@property (strong, nonatomic) NSString *selectedCategoryId;

- (IBAction)CancelBtnAction:(id)sender;

@end
