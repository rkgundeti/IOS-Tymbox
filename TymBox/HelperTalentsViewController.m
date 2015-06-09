//
//  HelperTalentsViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "HelperTalentsViewController.h"
#import "MyTalentsViewController.h"
#import "SWRevealViewController.h"
#import "HelperTalentsTableViewCell.h"
#import "MBProgressHUD.h"
#import "MyTalentsViewController.h"
#import "UserCatTalentObj.h"
@interface HelperTalentsViewController ()
{

    NSMutableArray *categoryArray;
    NSMutableArray *categoryId;
    NSMutableArray *rateArray;
    NSArray *jsonArray;
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;
    MBProgressHUD *hud;
    NSString *userID;
    BOOL update;
    
    NSMutableArray *userCatTalents;
    NSMutableDictionary *existsTalentsIds;
    
     UserCatTalentObj *selectedTalent;
   
                            //                                    stringForKey:@"preferenceName"];

}
@end

@implementation HelperTalentsViewController
@synthesize comingFromShareTymbox;

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getMainCategories];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userID=[userInfoDic valueForKey:@"userId"];
    
    if (!comingFromShareTymbox) {
        SWRevealViewController *reveal = self.revealViewController;
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:reveal action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = barBtn;
    }
    
   
   // [self getMainCategories];
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    categoryArray = [[NSMutableArray alloc] initWithObjects:@"Hi", nil];
//    categoryId =  [[NSMutableArray alloc] initWithObjects:@"Hi", nil];
//    rateArray =   [[NSMutableArray alloc] initWithObjects:@"Hi", nil];
    
  //  [self.view setBackgroundColor:[UIColor clearColor]];
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        UserCatTalentObj * talent = [[UserCatTalentObj alloc] init];
        talent = [userCatTalents objectAtIndex:indexPath.row];
        
        NSString *strSeletedTransId = [NSString stringWithFormat:@"%@",talent.userTalentId];
        [self deleteTalentService:strSeletedTransId];
        
        [userCatTalents removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[MyTalentsViewController class]]) {
        MyTalentsViewController *colorsViewConroller = segue.sourceViewController;
//        if (colorsViewConroller.selectedTalent) {
//            searchTalentTxtFeild.text = colorsViewConroller.selectedTalent;
//            NSLog(@"%@",colorsViewConroller.selectedTalent);
//        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getMainCategories{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        categoryArray = [NSMutableArray array];
        categoryId = [NSMutableArray array];
        rateArray = [NSMutableArray array];
        
        userCatTalents = [[NSMutableArray alloc]init];
        existsTalentsIds = [[NSMutableDictionary alloc]init];
       
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;

          NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",userID]];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        if (!responseData)
        {
            NSLog(@"Download Error: %@", error.localizedDescription);
            
        }
        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (jsonArray == nil) {
            NSLog(@"JSON Error: %@", error);
        }
        else{
        int i;
//        for (i=0; i<[jsonArray count]; i++) {
//            [categoryArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"categoryName"]];
//            [categoryId addObject:[[jsonArray objectAtIndex:i] valueForKey:@"talentName"]];
//            [rateArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"rate"]];
//
//            
//        }
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                
                UserCatTalentObj *c = [[UserCatTalentObj alloc] init];
                
                //NSDictionary *dict = [Response_array objectAtIndex:0];
                //NSLog(@"dict is %@",dict);
                
                NSLog(@"dict===%@",[dict objectForKey:@"categoryName"]);
                c.categoryName = [dict objectForKey:@"categoryName"];
                c.rate = [dict objectForKey:@"rate"];
                c.rateType = [dict objectForKey:@"rateType"];
                c.talentId = [dict objectForKey:@"talentId"];
                c.talentName = [dict objectForKey:@"talentName"];
                c.userId = [dict objectForKey:@"userId"];
                c.userName = [dict objectForKey:@"userName"];
                c.userTalentId = [dict objectForKey:@"userTalentId"];
                c.comments = [dict objectForKey:@"description"];
                
                [userCatTalents addObject:c];
                
                NSString *key = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"talentId"],[dict objectForKey:@"rateType"]];
                
                [existsTalentsIds setObject:[dict objectForKey:@"talentId"] forKey:key];
                
                /*
                 c.talentname = [NSString stringWithFormat:@"Talent : %d",i];
                 c.rating = i;
                 
                 [uTalents addObject:c];
                 */
                
            }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            //Stop your activity indicator or anything else with the GUI
            //[alert dismissViewControllerAnimated:YES completion:nil];
            [self.tableView reloadData];
            
            
        });
        }
    });
    
    
    NSLog(@"%@",categoryArray);
    NSLog(@"%@",categoryId);
    
    
    
    
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
    return [userCatTalents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HelperTalentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UserCatTalentObj * talent = [[UserCatTalentObj alloc] init];
    talent = [userCatTalents objectAtIndex:indexPath.row];
    
    //    cell.category.text= [categoryArray objectAtIndex:indexPath.row];
    //    cell.talentName.text = [categoryId objectAtIndex:indexPath.row];
    //    //cell.rateTxtField.text= [rateArray objectAtIndex:indexPath.row];
    //     cell.rateTxtField.text=  [NSString stringWithFormat:@"%@",[rateArray objectAtIndex:indexPath.row]];
    
    cell.category.text= talent.categoryName;
    cell.talentName.text= talent.talentName;
    cell.rateTxtField.text=[NSString stringWithFormat:@"%@/%@",talent.rate,talent.rateType];
    
    cell.imageView.image= [UIImage imageNamed:@"talents.png"];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //cell.textLabel.text = [categoryArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)deleteBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    UserCatTalentObj * talent = [[UserCatTalentObj alloc] init];
    talent = [userCatTalents objectAtIndex:senderButton.tag];
    
    NSString *strSeletedTransId = [NSString stringWithFormat:@"%@",talent.userTalentId];
    [self deleteTalentService:strSeletedTransId];
    //[self checkWebService];
    [self.tableView reloadData];
}
-(void) deleteTalentService:(NSString *)transId{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *serviceString;
        NSString *strTransId = transId;
        
        serviceString=[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/DeleteUserTalent?UserTalentID=%@&Active=0",strTransId];
        
        NSLog(@"service====%@",serviceString);
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSString *escapedUrlString = [serviceString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url=[NSURL URLWithString:escapedUrlString];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSString *msg;
        
        msg=@"Talent deleted..";
        
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        if (!responseData)
        {
            NSLog(@"Download Error: %@", error.localizedDescription);
            
        }
        NSDictionary *jsonDictionary;
        jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (jsonDictionary == nil) {
            NSLog(@"JSON Error: %@", error);
        }
        
        //{"Info":"Deleted"}
        
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //[self.activityIndicator stopAnimating];
                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                           //[self.custTableView reloadData];
                           
                           if ([[jsonDictionary objectForKey:@"Info"] isEqualToString:@"Deleted"]) {
//                               [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                               [dataArray removeObjectAtIndex:indexPath.row];
//                               [tableView reloadData];
                               UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                               [alert1 show];
                           }else if([[jsonDictionary objectForKey:@"Info"] isEqualToString:@"Talent Exists"])
                           {
                               UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Transactions records exists on this Talent" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                               [alert1 show];
                           }
                       });
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    
    else
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:NO];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
   
}
- (void) animateTextView:(BOOL) up
{
    const int movementDistance =-130;; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.inputView.frame, 0, movement);
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    if (comingFromShareTymbox) {
//        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//        [dict setValue:[NSString stringWithFormat:@"%@",[categoryId objectAtIndex:indexPath.row]] forKey:@"talentName"];
//        
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTalents" object: dict];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{
//        [self performSegueWithIdentifier:@"updateTalent" sender:self];
//    
//    }
//    
//    
//}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (comingFromShareTymbox) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSString stringWithFormat:@"%@",[categoryId objectAtIndex:indexPath.row]] forKey:@"talentName"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTalents" object: dict];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        selectedTalent = [[UserCatTalentObj alloc] init];
        selectedTalent = [userCatTalents objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"updateTalent" sender:self];
        
    }
    
    
}
- (IBAction)addTalentsAction:(id)sender {
    
    [self performSegueWithIdentifier:@"addTalents" sender:self];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    if ([segue.identifier isEqualToString:@"updateTalent"]) {
//        
//         MyTalentsViewController *destViewController = segue.destinationViewController;
//        destViewController.update=YES;
//        
//        NSIndexPath *indexPath = nil;
//        indexPath = [self.tableView indexPathForSelectedRow];
//        NSLog(@"indexpath=row===%ld",(long)indexPath.row);
//        UserCatTalentObj * talent = [[UserCatTalentObj alloc] init];
//        talent = [userCatTalents objectAtIndex:indexPath.row];
////        destViewController.addorUpdateAction = @"Update";
////        destViewController.categoryName = talent.categoryName;
////        destViewController.talentName = talent.talentName;
////        destViewController.talentId = talent.talentId;
////        destViewController.userTalentId = talent.userTalentId;
////        destViewController.talentObj = talent;
//    }
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"updateTalent"]) {
        
        MyTalentsViewController *destViewController = segue.destinationViewController;
        destViewController.update=YES;
        
        destViewController.selectedTalentObj = selectedTalent;
        destViewController.addorUpdateAction = @"Update";
        //        destViewController.addorUpdateAction = @"Update";
        //        destViewController.categoryName = talent.categoryName;
        //        destViewController.talentName = talent.talentName;
        //        destViewController.talentId = talent.talentId;
        //        destViewController.userTalentId = talent.userTalentId;
        //        destViewController.talentObj = talent;
    }else if([segue.identifier isEqualToString:@"addTalents"])
    {
        MyTalentsViewController *destViewController = segue.destinationViewController;
        //destViewController.update=YES;
        destViewController.existsTalents = existsTalentsIds;
    }
}

@end
