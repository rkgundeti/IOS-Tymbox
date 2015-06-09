//
//  Offer-Seeker-ViewCon.h
//  TymBox030915
//
//  Created by Rama Krishna.G on 04/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Offer_Seeker_ViewCon : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *selectedMenu;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *filteredDataArray;
//@property (strong, nonatomic) IBOutlet UIView *headerVies;

@property (nonatomic, retain) NSArray *imageURLs;

- (IBAction)seekerTalentSegAction:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *seekerTalentSegment;

@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;
@property (nonatomic, assign) bool isFiltered;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (assign, nonatomic) BOOL comingFromMenu;

@property (weak, nonatomic) IBOutlet UISegmentedControl *helperTalentSegment;
- (IBAction)helperTalentSegAction:(id)sender;
@end
