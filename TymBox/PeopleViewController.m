//
//  PeopleViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "PeopleViewController.h"

@implementation PeopleViewController{

    NSArray *dataArray1;
    NSArray *dataArray2;
}
@synthesize tableView,segmentControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dataArray1 = @[@"Helping: Tim Lauria",@"Helping: Sonya Polaric",@"Helping: Sonya Polaric"];
    dataArray2 = @[@"Outdoors - Snow Plowing",@"Outdoors - Snow Plowing",@"Outdoors - Landscaping"];
  
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)segmentChanged:(id)sender {
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.segmentControl.selectedSegmentIndex?[dataArray2 count]:[dataArray1 count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(self.segmentControl.selectedSegmentIndex){
//        // Create Type cell for selected Index 1
//    }
//    else{
//        // Create Type cell for selected Index 0
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
