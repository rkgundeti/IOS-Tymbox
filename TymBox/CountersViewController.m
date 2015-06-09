//
//  CountersViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 5/20/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "CountersViewController.h"
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
@interface CountersViewController ()
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

@implementation CountersViewController
@synthesize countersTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.countersTableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[[userInfoDic valueForKey:@"userId"] stringValue];
    userName=[userInfoDic valueForKey:@"userName"];
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    if([userType isEqualToString:@"Helper"])
    {
        
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        
    }
    selectedTab = @"Counter";
    ORStatus = @"Counter";
    goingToCounter=@"YES";
    [self getOffersFromWebService];
    // Do any additional setup after loading the view.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    

    
    
    return @"Counter Offers";
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([openOfferesList count] == 0 ){
        // nomatchesView.hidden = NO;
    } else {
        //nomatchesView.hidden = YES;
    }
    
    //return [data count];
    return [openOfferesList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TransMasterObj * talent = [[TransMasterObj alloc] init];
    talent = [openOfferesList objectAtIndex:indexPath.row];
    
    
    NSMutableArray *detObj = [[NSMutableArray alloc] init];
    detObj = talent.detArray;
    CounterTableViewCell *cell = (CounterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CounterCell"];
    if (cell == nil){
        //initialize the cell view from the xib file
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CounterTableViewCell"
                                                      owner:self options:nil];
        cell = (CounterTableViewCell *)[nibs objectAtIndex:0];
        TransDetObj *detObj = [[TransDetObj alloc]init];
        detObj = [talent.detArray objectAtIndex:0];
        
        if ([detObj.createdBy isEqualToString:userName]) {
            cell.who.text=@"You";
        }
        else{
            cell.who.text=detObj.createdBy;
        }
        
        if ([talent.offer_Request_Type isEqualToString:@"Request"]) {
            
            cell.what.text= @"Countered a Request";
        }
        
        //  cell.what.text= talent.user_Talent_Name;
        cell.count.text = [NSString stringWithFormat:@"%lu",(unsigned long)[talent.detArray count]];
    }
    return cell;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([userType isEqualToString:@"Seeker"]) {
        return 94.0;
    }
    else{
        if([selectedTab isEqualToString:@"Offer"])
        {
            return 72.0;
        }
        else if  ([selectedTab isEqualToString:@"Request"]){
            
            return 94.0;
            
        }
        
        else{
            
            return 80;
        }
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    
    
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    // if([userType isEqualToString:@"Helper"])
    selectedIndex = indexPath.row;
    
    TransMasterObj * talent = [[TransMasterObj alloc] init];
    talent = [openOfferesList objectAtIndex:selectedIndex];
    //    NSLog(@"loggedInuserId===%@",loggedInuserId);
    //    NSLog(@"talentCreatedId===%@",talent.createdById);
    
    NSArray *detArray = [[NSArray alloc]init];
    detArray = talent.detArray;
    
    //    NSString *check= [NSString stringWithFormat:@"%@",userId];
    NSLog(@"detArray ====%d",[detArray count]);
    
    if ([selectedTab isEqualToString:@"Offer"]) {
        if([userType isEqualToString:@"Helper"])
        {
            [self performSegueWithIdentifier:@"editOffer" sender:self];
            
        }else
            
        {
            // [self performSegueWithIdentifier:@"seekerOfferUpdate" sender:self];
            [self performSegueWithIdentifier:@"OfferDetails" sender:self];
            
        }
        
    }
    else if ([selectedTab isEqualToString:@"Request"]){
        if([userType isEqualToString:@"Helper"])
        {
            
            [self performSegueWithIdentifier:@"OfferDetails" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"seekerOfferUpdate" sender:self];
            
        }
        
    }
    
    else if ([detArray count] > 1){
        
        [self performSegueWithIdentifier:@"OfferDetails" sender:self];
        
    }
    
    //    NSLog(@"%@",talent.createdById);
    //    if([detArray count] == 1 && [userId isEqualToString:[NSString stringWithFormat:@"%@",talent.createdById]])
    //    {
    //        if([userType isEqualToString:@"Helper"])
    //        {
    //            [self performSegueWithIdentifier:@"editOffer" sender:self];
    //        }else{
    //            [self performSegueWithIdentifier:@"seekerOfferUpdate" sender:self];
    //
    //        }
    //    }else if([detArray count] > 1){
    //        [self performSegueWithIdentifier:@"OfferDetails" sender:self];
    //
    //    }
    //
    //     OpenOfferObj * Obj = [[OpenOfferObj alloc] init];
    //     Obj = [openOfferesList objectAtIndex:indexPath.row];
    //
    //     NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    //     [dict setValue:[NSString stringWithFormat:@"%@",Obj.offeredTo] forKey:@"seekerName"];
    //     [dict setValue:[NSString stringWithFormat:@"%@",Obj.offeredTalent] forKey:@"talentName"];
    //     [dict setValue:[NSString stringWithFormat:@"%@",Obj.offeredDate] forKey:@"Date"];
    //     [dict setValue:[NSString stringWithFormat:@"%@",Obj.offeredPrice] forKey:@"Price"];
    //     [dict setValue:[NSString stringWithFormat:@"%@",Obj.offeredexpense] forKey:@"Expense"];
    //
    //     [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedOffer" object: dict];
    //     
    //     
    //     [self.navigationController popViewControllerAnimated:YES];
    
    
    //   */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"OfferDetails"]) {
        
        /*
         
         TalentsTableViewController* controller =
         (TalentsTableViewController*)[[segue destinationViewController] topViewController];
         
         */
        
        OfferDetailViewController *controller = [segue destinationViewController];
        TransMasterObj * talent = [[TransMasterObj alloc] init];
        talent = [openOfferesList objectAtIndex:selectedIndex];
        if ([goingToCounter isEqualToString:@"YES"]) {
            controller.comingFromCounter = @"YES";
        }
        
        controller.selectedObj = talent;
        controller.counter= @"counter";
        NSLog(@"controller===%@",controller);
        
    }
    else if ([segue.identifier isEqualToString:@"editOffer"]) {
        
        
        UINavigationController *navigationController = segue.destinationViewController;
        offerHelpViewController *showItemsTVC = (offerHelpViewController * )navigationController.topViewController;
        
        
        TransMasterObj * talent = [[TransMasterObj alloc] init];
        talent = [openOfferesList objectAtIndex:selectedIndex];
        showItemsTVC.transType = @"edit";
        showItemsTVC.selectedObj = talent;
        
    }
    else if ([segue.identifier isEqualToString:@"seekerOfferUpdate"]) {
        
        SeekerReachOutController *controller = [segue destinationViewController];
        TransMasterObj * talent = [[TransMasterObj alloc] init];
        talent = [openOfferesList objectAtIndex:selectedIndex];
        controller.transType = @"edit";
        controller.selectedObj = talent;
        
    }
    
    //
}

@end
