//
//  HelperFeedback.m
//  TymBox
//
//  Created by Vertex Offshore on 4/27/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "HelperFeedback.h"
#import "TransMasterObj.h"
#import "TransDetObj.h"
#import "helperFeedbackCell.h"
#import "PostFeedbackViewController.h"
#import "SeekerPFViewController.h"
@interface HelperFeedback ()
{

    NSString *userType;
    NSString *O_R_Type;
    NSString *userId;
    NSMutableArray *openOfferesList;
    NSInteger selectedIndex;

}
@end

@implementation HelperFeedback

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"Leave Feedback";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[[userInfoDic valueForKey:@"userId"] stringValue];
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    if([userType isEqualToString:@"Helper"])
    {
        O_R_Type = @"Offer";
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        O_R_Type = @"Offer";
    }
    
    [self checkWebService];
    [self.tableView reloadData];
    
    
    
}

- (void) checkWebService {
    
    //UserId or Seeker_Id,User_Type O_R_Type,O_R_Status
    
    //NSString *URL_LOGIN = [NSString stringWithFormat:@"http://192.168.0.158:8080/TymBoxWeb/GetTymboxTransServlet?userid=%@&user_type=%@&ORType=%@&ORStatus=%@",loggedInuserId,selectedMenu,selectedTab,@"Counter"];
    
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetTymboxTransServlet?userid=%@&user_type=%@&ORType=Request&ORStatus=%@",userId,userType,@"Complete"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    NSLog(@"responseCode====%@",responseCode);
    NSLog(@"~~~~~ Status code: %d", [response statusCode]);
    
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            openOfferesList = [[NSMutableArray alloc]init];
            
            
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                
                TransMasterObj *c = [[TransMasterObj alloc] init];
                
                
                c.transId           = [dict objectForKey:@"transId"];
                c.userId            = [dict objectForKey:@"userId"];
                c.userName          = [dict objectForKey:@"userName"];
                c.user_Type         = [dict objectForKey:@"user_Type"];
                c.job_Req_Date      = [dict objectForKey:@"job_Req_Date"];
                c.time_Line         = [dict objectForKey:@"time_Line"];
                c.UOM               = [dict objectForKey:@"UOM"];
                c.reach_Out_Message = [dict objectForKey:@"reach_Out_Message"];
                c.user_Talent_Id    = [dict objectForKey:@"user_Talent_Id"];
                c.user_Talent_Name  = [dict objectForKey:@"talentName"];
                c.seekerId          = [dict objectForKey:@"seeker_Id"];
                c.seekerName        = [dict objectForKey:@"seekerName"];
                
                NSMutableArray *detailArray = [[NSMutableArray alloc]init];
                
                detailArray = [dict objectForKey:@"arlTyboxTransDetail"];
                
                c.detArray = [[NSMutableArray alloc]init];
                
                for(NSMutableDictionary *detDict in detailArray)
                {
                    NSLog(@"detDict===%@",detDict);
                    TransDetObj *det = [[TransDetObj alloc]init];
                    
                    det.trans_det_ID        = [detDict objectForKey:@"trans_det_ID"];
                    det.trans_ID            = [detDict objectForKey:@"trans_ID"];
                    det.price               = [detDict objectForKey:@"price"];
                    det.quantity            = [detDict objectForKey:@"quantity"];
                    det.expense             = [detDict objectForKey:@"expense"];
                    det.total               = [detDict objectForKey:@"total"];
                    det.expense_Comments    = [detDict objectForKey:@"expense_Comments"];
                    det.createdBy           = [detDict objectForKey:@"modifiedBy"];
                    
                    
                    [c.detArray addObject:det];
                }
                
                NSLog(@"detArray===%d",[c.detArray count]);
                
                
                
                
                
                [openOfferesList addObject:c];
                
            }
            
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }else
    {
        
        //if ([responseCode isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        //}
    }
    
    //[self performSegueWithIdentifier:@"loggedInUser" sender:self];
    
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
    return [openOfferesList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransMasterObj * talent = [[TransMasterObj alloc] init];
    talent = [openOfferesList objectAtIndex:indexPath.row];
    
    
    NSMutableArray *detObj = [[NSMutableArray alloc] init];
    detObj = talent.detArray;
    
    
    
    helperFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if([userType isEqualToString:@"Helper"]){
    cell.seekerName.text = [NSString stringWithFormat:@"Seeker Name:%@",talent.seekerName];
    
    }
    else{
    cell.seekerName.text = [NSString stringWithFormat:@"Helper Name:%@",talent.userName];
    //cell.seekerName.text = talent.userName;
    }

    
    cell.dateLabel.text = talent.job_Req_Date;
    
    cell.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"add-friend-bg.png"]];
 //   [cell.dateLabel setText:[NSString stringWithFormat:@"%@",talent.job_Req_Date]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    if([userType isEqualToString:@"Helper"])
    {
    [self performSegueWithIdentifier:@"postFeed" sender:self];
    }
    
    
    else{
    
     [self performSegueWithIdentifier:@"SeekerFeed" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"postFeed"]) {
        
        PostFeedbackViewController *offer = [segue destinationViewController];
        
        
        TransMasterObj * talent = [[TransMasterObj alloc] init];
        talent = [openOfferesList objectAtIndex:selectedIndex];
        
        offer.selectedObj = talent;
        
    }
    else{
    
        SeekerPFViewController *offer = [segue destinationViewController];
        
        
        TransMasterObj * talent = [[TransMasterObj alloc] init];
        talent = [openOfferesList objectAtIndex:selectedIndex];
        
        offer.selectedObj = talent;
    }
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
