//
//  offerHelpTalentsTableViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 3/24/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface offerHelpTalentsTableViewController : UITableViewController
{

}
@property(nonatomic,strong) NSString *selectedCategory;
@property(nonatomic,strong) NSString *selectUserTalentId;
@property(nonatomic,strong) NSString *selectedSeeker;
@property(nonatomic,strong) NSString *selectedSeekerId;
@property(nonatomic,assign) BOOL seekValue;
@property(nonatomic,strong) NSString *value;
@end
