//
//  CounterHistoryTableView.m
//  TymBox
//
//  Created by Vertex Offshore on 4/23/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "CounterHistoryTableView.h"
#import "CounterHistoryCell.h"
#import "TransMasterObj.h"
#import "TransDetObj.h"
@interface CounterHistoryTableView ()
{
    NSMutableArray *detArray;
    TransDetObj *detObj;

}
@end

@implementation CounterHistoryTableView
@synthesize detailArray,counterObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    

    
    detArray = [[NSMutableArray alloc]init];
    
    detArray = counterObj.detArray;
    
   // detObj = [detArray objectAtIndex:0];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [detArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CounterHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
  //  TransDetObj *detObj = [[TransDetObj alloc]init];
    
    detObj = [detArray objectAtIndex:indexPath.row];
  //  detObj = [detArray objectAtIndex:indexPath.row];
    
    
    cell.amountLabel.text =[NSString stringWithFormat:@"%@",detObj.price];
    cell.expenseLabel.text =[NSString stringWithFormat:@"%@",detObj.expense];
    cell.totalLabel.text = [NSString stringWithFormat:@"%@",detObj.total];
    
    cell.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"add-friend-bg.png"]];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
