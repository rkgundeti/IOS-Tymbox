//
//  HistoryTVController.m
//  TymBox
//
//  Created by Rama Krishna Gundeti on 01/06/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "HistoryTVController.h"

#import "CounterHistoryCell.h"
#import "TransMasterObj.h"
#import "TransDetObj.h"
#import "CounterHistoryTVCell.h"

@interface HistoryTVController ()
{
    NSMutableArray *detArray;
    TransDetObj *detObj;
    NSString *userId;
    NSString *userName;
}
@end

@implementation HistoryTVController
@synthesize detailArray,counterObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[[userInfoDic valueForKey:@"userId"] stringValue];
    userName=[userInfoDic valueForKey:@"userName"];
    
    detArray = [[NSMutableArray alloc]init];
    NSLog(@"counterObj===%@",counterObj);
    detArray = counterObj.detArray;
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trans_det_ID" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [detArray sortedArrayUsingDescriptors:descriptors];
    
    detArray = [[NSMutableArray alloc]init];
    NSLog(@"counterObj===%@",counterObj);
    detArray = [sortedArray mutableCopy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [detArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CounterHistoryTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.talentNamelbl.text = counterObj.user_Talent_Name;
    
    detObj = [detArray objectAtIndex:indexPath.row];
    //  detObj = [detArray objectAtIndex:indexPath.row];
    
    
    cell.amountlbl.text =[NSString stringWithFormat:@"%@",detObj.price];
    cell.expenselbl.text =[NSString stringWithFormat:@"%@",detObj.expense];
    cell.totallbl.text = [NSString stringWithFormat:@"%@",detObj.total];
    cell.usernamelbl.text = detObj.createdBy;
    
    if(indexPath.row == 0)
    {
        cell.createdBylbl.text = @"Created By";
    }else
    {
        cell.createdBylbl.text = @"Countered By";
    }
    
    
    cell.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"add-friend-bg.png"]];
    // Configure the cell...
    
    return cell;
}


- (IBAction)gobackBtnAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
