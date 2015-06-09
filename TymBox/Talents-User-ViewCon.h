//
//  Talents-User-ViewCon.h
//  TymBox030915
//
//  Created by Rama Krishna.G on 06/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferObject.h"

@interface Talents_User_ViewCon : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *selectedName;
@property (strong, nonatomic) NSString *selectedId;
@property (strong, nonatomic) NSString *selectedTab;
@property (strong,nonatomic) NSMutableArray *seekerArray;
@property (strong,nonatomic) NSMutableArray *filteredseekerArray;

@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;
@property (nonatomic, assign) bool isFiltered;

@property (weak, nonatomic) IBOutlet UITableView *custTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;

@property (strong, nonatomic) OfferObject *offerObj;

@end
