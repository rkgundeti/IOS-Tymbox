//
//  HelperPeopleViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 4/13/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelperPeopleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *custtableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *peopleSegment;
- (IBAction)indexChanged:(id)sender;

@property (strong,nonatomic) NSMutableArray *filteredDataArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;
@property (nonatomic, assign) bool isFiltered;


@property (nonatomic, retain) NSArray *imageURLs;

@end
