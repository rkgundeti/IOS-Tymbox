//
//  MyCoomitmentsController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "MyCoomitmentsController.h"
#import "OfferDetailViewController.h"
#import "TransDetObj.h"
#import "MycommitmentsCell.h"
@interface MyCoomitmentsController ()

@end

@implementation MyCoomitmentsController{
    
    NSArray *mainLabelArray;
    NSArray *detailArray;
    NSArray *dateArray;
    NSString *userType;
    NSString *O_R_Type;
    NSString *userId;
    NSMutableArray *openOfferesList;
    NSInteger selectedIndex;
 
}
@synthesize ComingFromJobHistory;
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
    
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetTymboxTransServlet?userid=%@&user_type=%@&ORType=Request&ORStatus=%@",userId,userType,@"Accept"];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"My Commitments";
    
  
    
    self.tableView.rowHeight=73;
    mainLabelArray = @[@"Helping: Tim Lauria",@"Helping: Sonya Polaric",@"Helping: Sonya Polaric"];
    detailArray = @[@"Outdoors - Snow Plowing",@"Outdoors - Snow Plowing",@"Outdoors - Landscaping"];
    dateArray = @[@"3/16/15",@"3/20/15",@"3/21/15"];

    
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
     return [openOfferesList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransMasterObj * talent = [[TransMasterObj alloc] init];
    //talent = [openOfferesList objectAtIndex:indexPath.row];
    talent = [openOfferesList objectAtIndex:0];
    
    
    NSMutableArray *detObj = [[NSMutableArray alloc] init];
    detObj = talent.detArray;
    
    
   
   MycommitmentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (ComingFromJobHistory) {
        if([userType isEqualToString:@"Helper"])
        {
            cell.whatLabel.text=[NSString stringWithFormat:@"%s:%@","Completed Job With",talent.seekerName];
        }else if([userType isEqualToString:@"Seeker"])
        {
            //cell.whatLabel.text=@"Completed Job With";
             cell.whatLabel.text=[NSString stringWithFormat:@"%s:%@","Completed Job With",talent.seekerName];
        }
    }
    else{
    if([userType isEqualToString:@"Helper"])
    {
       cell.whatLabel.text=@"Helping";
    }else if([userType isEqualToString:@"Seeker"])
    {
       cell.whatLabel.text=@"Seeking";
    }
    }
   // cell.seekerName.text = talent.seekerName;
    cell.talentName.text = talent.user_Talent_Name;
    [cell.dateLabel setText:[NSString stringWithFormat:@"%@",talent.job_Req_Date]];
    cell.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    return cell;
}
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"AcceptedOffer" sender:self];

}
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
    if ([segue.identifier isEqualToString:@"AcceptedOffer"]) {
        
        OfferDetailViewController *offer = [segue destinationViewController];
        offer.commitment=@"Commitment";
      
        TransMasterObj * talent = [[TransMasterObj alloc] init];
        talent = [openOfferesList objectAtIndex:selectedIndex];
        
        offer.selectedObj = talent;
        

        
        
        
    }
}


@end
