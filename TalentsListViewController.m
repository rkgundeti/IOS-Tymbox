//
//  TalentsListViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "TalentsListViewController.h"
#import "ShowProcessing.h"
#import "CustomIOS7AlertView.h"
#import "MBProgressHUD.h"
ShowProcessing *show;
//CustomIOS7AlertView *alertView;
@interface TalentsListViewController ()
{
    NSArray *TalentsList;
    NSMutableSet* _collapsedSections;
    NSMutableArray *resultArray;
    NSMutableDictionary *resultDictionary;
    
    NSMutableArray *categoryArray;
    NSMutableArray *categoryId;
    NSArray *jsonArray;
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;

}
@end

@implementation TalentsListViewController
@synthesize selectedCategory,selectedCategoryId;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collapsedSections = [NSMutableSet new];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    
    self.title = @"Select Category";
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
  //  [self.view setBackgroundColor:[UIColor clearColor]];
    //Start an activity indicator here
    [self getMainCategories];

    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        //Call your function or whatever work that needs to be done
//        //Code in this part is run on a background thread
//        [self getMainCategories];
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            
//            //Stop your activity indicator or anything else with the GUI
//            //Code here is run on the main thread
//            
//        });
//    });
    
   // TalentsList= @[@"Auto",@"Business",@"Education",@"Home",@"Party Time",@"Pet",];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getMainCategories{
    
   
   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    

    
    
        
               //Call your function or whatever work that needs to be done
                //Code in this part is run on a background thread
        categoryArray = [NSMutableArray array];
        categoryId = [NSMutableArray array];
        // [alertView show];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
//        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.42:8080/TymBoxWeb/CategoryServlet"]];
       // http://192.168.0.187:8080/TymBoxWeb/CategoryServlet
        
       
        
         NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/CategoryServlet"]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        int i;
        for (i=0; i<[jsonArray count]; i++) {
            [categoryArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"categryName"]];
            [categoryId addObject:[[jsonArray objectAtIndex:i] valueForKey:@"ID"]];
            
        }
           dispatch_async(dispatch_get_main_queue(), ^(void) {
        
                   // [show ProcessingStop];
                   // [alertView close];
                    //Stop your activity indicator or anything else with the GUI
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadData];
                    
        
            });
         });

    
    NSLog(@"%@",categoryArray);
     NSLog(@"%@",categoryId);
    

    

}


//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [_collapsedSections containsObject:@(section)] ? 0 : 10;
//}
//
//-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows {
//    NSMutableArray* indexPaths = [NSMutableArray new];
//    for (int i = 0; i < numberOfRows; i++) {
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
//        [indexPaths addObject:indexPath];
//    }
//    return indexPaths;
//}
//
//-(void)sectionButtonTouchUpInside:(UIButton*)sender {
//    sender.backgroundColor = [UIColor greenColor];
//    [self.tableView beginUpdates];
//    int section = sender.tag;
//    bool shouldCollapse = ![_collapsedSections containsObject:@(section)];
//    if (shouldCollapse) {
//        int numOfRows = [self.tableView numberOfRowsInSection:section];
//        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
//        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//        [_collapsedSections addObject:@(section)];
//    }
//    else {
//        int numOfRows = 10;
//        NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//        [_collapsedSections removeObject:@(section)];
//    }
//    [self.tableView endUpdates];
//    //[_tableView reloadData];
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIButton* result = [UIButton buttonWithType:UIButtonTypeCustom];
//    [result addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//    result.backgroundColor = [UIColor blueColor];
//    [result setTitle:[NSString stringWithFormat:@"Section %d", section] forState:UIControlStateNormal];
//    result.tag = section;
//    return result;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell* result =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    result.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
//    return result;
//}
//

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
    return [categoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TalentsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [categoryArray objectAtIndex:indexPath.row];
    cell.imageView.image= [UIImage imageNamed:@"talents.png"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedCategory = categoryArray[indexPath.row];
    
    self.selectedCategoryId = [categoryId[indexPath.row] stringValue];
    
   // NSInteger *check =[self getCategoryId:self.selectedCategory];
    //self.selectedCategoryId=
    //[self dissmissModelView];
    [self performSegueWithIdentifier:@"talentSelected" sender:self];
     //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    
    else
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
}
-(void)dissmissModelView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"DismissModalviewController");
    
    //raise notification about dismiss
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"MODELVIEW DISMISS"
     object:self.selectedCategory];
}
//-(NSInteger*)getCategoryId:(NSString*)title
//{
//    
//    for (int i=0; i< [jsonArray count]; i++)
//    {
//        NSString *TITle = [[jsonArray objectAtIndex:i] objectForKey:@"categryName"];
//        
//        if([TITle isEqual:title])
//        {
//            return [[[jsonArray objectAtIndex:i] objectForKey:@"ID"] integerValue];
//        }
//    }
//    return nil;
//}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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

- (IBAction)CancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
