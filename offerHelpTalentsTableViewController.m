#import "offerHelpTalentsTableViewController.h"
#import "MyTalentsViewController.h"
#import "SWRevealViewController.h"
#import "HelperTalentsTableViewCell.h"
#import "MBProgressHUD.h"
#import "MyTalentsViewController.h"
#import "offerMyTalentsCell.h"
@interface offerHelpTalentsTableViewController ()
{
    
    NSMutableArray *categoryArray;
    NSMutableArray *categoryId;
    NSMutableArray *rateArray;
    NSArray *jsonArray;
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;
    MBProgressHUD *hud;
    NSURL *url;
    NSMutableArray *talentIdArray;
    NSString *userId;
    
}
@end

@implementation offerHelpTalentsTableViewController
@synthesize selectedCategory,seekValue,value,selectedSeeker,selectUserTalentId,selectedSeekerId;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
    NSLog(@"%d",seekValue);
     [self getMainCategories];
    
    
    if ([value isEqualToString:@"Seek"]) {
    
    
        self.title=@"Seekers";
        
    }
    NSLog(@"%@",value);
    

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
    
    //show = [[ShowProcessing alloc] init];
    //CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    //          alert = [UIAlertController alertControllerWithTitle:nil
    //                                                                       message:@"Please wait\n\n\n"
    //                                                                preferredStyle:UIAlertControllerStyleAlert];
    //
    //    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //    spinner.center = CGPointMake(130.5, 65.5);
    //    spinner.color = [UIColor blackColor];
    //    [spinner startAnimating];
    //    [alert.view addSubview:spinner];
    //    [self presentViewController:alert animated:NO completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeDeterminate;
//        hud.labelText = @"Loading";
//        [hud show:YES];
        
        //        alert = [UIAlertController alertControllerWithTitle:nil
        //                                                    message:@"Please wait\n\n\n"
        //                                             preferredStyle:UIAlertControllerStyleAlert];
        //
        //        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //        spinner.center = CGPointMake(130.5, 65.5);
        //        spinner.color = [UIColor blueColor];
        //        [spinner startAnimating];
        //        [alert.view addSubview:spinner];
        //        [self presentViewController:alert animated:NO completion:nil];
        
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        categoryArray = [NSMutableArray array];
        categoryId = [NSMutableArray array];
        rateArray = [NSMutableArray array];
        talentIdArray= [NSMutableArray array];
        // [alertView show];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        //        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.42:8080/TymBoxWeb/GetUserTalentServlet?userId=8"]];
        // http://192.168.0.187:8080/TymBoxWeb/CategoryServlet
        
        //192.168.0.158
        
        if ([value isEqualToString:@"Seek"]) {
//            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.158:8080/TymBoxWeb/GetUserDetailServlet"]];
            
            url= [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId]];
            
        }
        else{
        
       url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",userId]];
        }
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
            
            if ([value isEqualToString:@"Seek"]) {
                int i;
                for (i=0; i<[jsonArray count]; i++) {
                    
//                    if ([[[jsonArray objectAtIndex:i] valueForKey:@"user_Name"] isEqualToString:@"Mitchel"]){
//                        NSLog(@"I can't add My self");
//                    }
                    
                    if ([[[jsonArray objectAtIndex:i] valueForKey:@"status"] isEqualToString:@"Accepted"] && [[[jsonArray objectAtIndex:i] valueForKey:@"user_type"] isEqualToString:@"Seeker"]) {
                        
                        
                        
                        [categoryArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"referedToName"]];
                        [categoryId addObject:[[jsonArray objectAtIndex:i] valueForKey:@"refered_to"]];
                        
                    }
//                    else{
//                 
//                    }
                    
                }
            }
            else{
            int i;
            for (i=0; i<[jsonArray count]; i++) {
                [categoryArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"categoryName"]];
                [categoryId addObject:[[jsonArray objectAtIndex:i] valueForKey:@"talentName"]];
                  [rateArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"rate"]];
                [talentIdArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"userTalentId"]];
                
                
            }
            }
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                // [show ProcessingStop];
                // [alertView close];
               // [hud hide:YES];
                
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
    return [categoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    offerMyTalentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if ([value isEqualToString:@"Seek"]) {
     cell.catName.text= [categoryArray objectAtIndex:indexPath.row];
        cell.talName.alpha=0;
        cell.rateField.alpha=0;
        cell.dollarLabel.alpha=0;
    }
    
    else{
        
        cell.talName.alpha=1;
        cell.rateField.alpha=1;
        cell.dollarLabel.alpha=1;
    cell.catName.text= [categoryArray objectAtIndex:indexPath.row];
    cell.talName.text = [categoryId objectAtIndex:indexPath.row];
    cell.rateField.text= [[rateArray objectAtIndex:indexPath.row] stringValue];
    }
    //cell.textLabel.text = [categoryArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    if ([value isEqualToString:@"Seek"]) {
    
     self.selectedSeeker = categoryArray[indexPath.row];
        self.selectedSeekerId = categoryId[indexPath.row];
        
    
    }
    else{
   self.selectedCategory = categoryId[indexPath.row];
    self.selectUserTalentId = talentIdArray[indexPath.row];
    }
    
   // self.selectedCategoryId = [categoryId[indexPath.row] stringValue];
    
    // NSInteger *check =[self getCategoryId:self.selectedCategory];
    //self.selectedCategoryId=
    //[self dissmissModelView];
    [self performSegueWithIdentifier:@"talentSelected" sender:self];
    //[self dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"updateTalent"]) {
        
        MyTalentsViewController *destViewController = segue.destinationViewController;
        
    }
}


@end
