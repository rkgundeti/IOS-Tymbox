//
//  OpenOffersDecline.m
//  TymBox
//
//  Created by Vertex Offshore on 5/20/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "OpenOffersDecline.h"
#import "offerHelpTableViewController.h"
#import "HelperTransaction.h"
#import "OfferdCell.h"
#import "OfferDetailViewController.h"
#import "MBProgressHUD.h"
#import "TransMasterObj.h"
#import "TransDetObj.h"
#import "TableViewCell.h"
#import "TVCellWithOutChilds.h"
#import "offerHelpViewController.h"
#import "SeekerReachOutController.h"
#import "HelperOfferCell.h"
#import "HelperRequestCell.h"
#import "CounterTableViewCell.h"
#import "CounterHistoryTableView.h"
@interface OpenOffersDecline ()
{
    NSString *helperTransactionId;
    NSMutableArray *sendArray;
    NSString *userId;
    NSArray *mainLabelArray;
    NSArray *detailArray;
    NSArray *dateArray;
    NSArray *jsonArray;
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;
    NSMutableArray *totalTransactions;
    NSString *selectedTab;
    NSString *ORStatus;
    NSString *userType;
    NSInteger selectedIndex;
    NSString *userName;
    NSString *goingToCounter;
    
    NSMutableArray *openOfferesList;

}
@end

@implementation OpenOffersDecline

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"";
    self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[[userInfoDic valueForKey:@"userId"] stringValue];
    userName=[userInfoDic valueForKey:@"userName"];
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    if([userType isEqualToString:@"Helper"])
    {
        
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        
    }
    selectedTab = @"Offer";
    ORStatus = @"Decline";
    [self getOffersFromWebService];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getOffersFromWebService{
    
    // http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentWise?talentId=11
    //UserId or Seeker_Id,User_Type O_R_Type,O_R_Status
    
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetTymboxTransServlet?userid=%@&user_type=%@&ORType=%@&ORStatus=%@",userId,userType,selectedTab,ORStatus];
    
    //NSString *URL_LOGIN = [NSString stringWithFormat:@"http://192.168.0.158:8080/TymBoxWeb/GetHelperTransServlet?userid=39"];
    
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
                c.createdById       = [dict objectForKey:@"created_By"];
                c.offer_Request_Type = [dict objectForKey:@"offer_Request_Type"];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HelperOfferCell *cell1;
    TransMasterObj * talent = [[TransMasterObj alloc] init];
    talent = [openOfferesList objectAtIndex:indexPath.row];
    
    
    NSMutableArray *detObj = [[NSMutableArray alloc] init];
    detObj = talent.detArray;
    
//    if([userType isEqualToString:@"Seeker"])
//    {
//        cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//        
//        cell1.seekerName.text = talent.seekerName;
//        
//        cell1.whatYouSent.text= [NSString stringWithFormat:@"%@%@%@",@"Requested for  ",talent.user_Talent_Name,@" Job"];
//        cell1.who.text =talent.userName;
//        cell1.dateLabel.text= [NSString stringWithFormat:@"%@%@",@"Requested Date  ",talent.job_Req_Date];
//        return cell1;
//        
//        
//    }
    
//    else{
    
//        HelperRequestCell *cell = (HelperRequestCell*)[tableView dequeueReusableCellWithIdentifier:@"RequestedCell"];
    
        
    cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell1.seekerName.text = talent.seekerName;
    
    cell1.whatYouSent.text= [NSString stringWithFormat:@"%@%@%@",@"Declined your ",talent.user_Talent_Name,@" Job"];
    cell1.who.text =talent.userName;
    cell1.dateLabel.text= [NSString stringWithFormat:@"%@",talent.job_Req_Date];
    return cell1;
    
   // }
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    return 80;
    
    
}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
