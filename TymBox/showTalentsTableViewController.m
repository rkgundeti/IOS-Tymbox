//
//  showTalentsTableViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/7/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "showTalentsTableViewController.h"
#import "MBProgressHUD.h"
@interface showTalentsTableViewController ()
{
   
    
    NSMutableArray *categoryArray;
    NSMutableArray *categoryId;
    NSArray *jsonArray;
    
}
@end
@implementation showTalentsTableViewController
@synthesize selectedIdToShow,idValue,nameString,selectedTalent,TalentId;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"Select Talent";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];

  //  [self.view setBackgroundColor:[UIColor clearColor]];
    
    NSLog(@"%@",nameString);
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //Start an activity indicator here
    [self getMainCategories];
    
    
   }
-(void)getMainCategories{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        categoryArray = [NSMutableArray array];
        categoryId = [NSMutableArray array];
        
        
      //  http://192.168.0.187:8080
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
//        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.42:8080/TymBoxWeb/TalentServlet?cid=%@",selectedIdToShow]];
         NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/TalentServlet?cid=%@",selectedIdToShow]];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        int i;
        for (i=0; i<[jsonArray count]; i++) {
            [categoryArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"talentName"]];
            [categoryId addObject:[[jsonArray objectAtIndex:i] valueForKey:@"talentId"]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            //Stop your activity indicator or anything else with the GUI
            [self.tableView reloadData];
            
        });
    });
    
    
    NSLog(@"%@",categoryArray);
    NSLog(@"%@",categoryId);
    
    
    
    
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
    self.selectedTalent = categoryArray[indexPath.row];
    self.TalentId = categoryId[indexPath.row];
    
    NSLog(@"%@",self.selectedTalent);
    //self.selectedTalent = [categoryId[indexPath.row] stringValue];
    
    // NSInteger *check =[self getCategoryId:self.selectedCategory];
    //self.selectedCategoryId=
    
    [self performSegueWithIdentifier:@"manSelected" sender:self];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    
    else
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
}
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//}


@end
