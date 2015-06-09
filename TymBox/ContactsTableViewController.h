//
//  ContactsTableViewController.h
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewController : UITableViewController <UISearchControllerDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) NSString *selectedHelper;
@property (strong, nonatomic) NSString *selectedUserType;
@property (strong, nonatomic) NSString *selectType;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (strong,nonatomic) NSMutableArray *filteredseekerArray;
@property (strong, nonatomic) IBOutlet UISearchBar *contactSearchBar;

@property (nonatomic, assign) bool isFiltered;

@end
