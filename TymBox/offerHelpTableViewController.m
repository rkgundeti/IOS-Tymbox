//
//  offerHelpTableViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

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

#import "CounterCell.h"
#import "HistoryTVController.h"
#import "AsyncImageView.h"

@interface offerHelpTableViewController ()
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

@implementation offerHelpTableViewController
@synthesize offersSegment,tableView,tableViewCellWithTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.tableView.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    self.navigationItem.title = @"Open Offers";
    
    //self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[[userInfoDic valueForKey:@"userId"] stringValue];
    userName=[userInfoDic valueForKey:@"userName"];
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    if([userType isEqualToString:@"Helper"])
    {
        
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        
    }
    
    
    self.title=@"Open Offers";
    self.tableView.rowHeight=73;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    
    mainLabelArray = @[@"Offered: Tim Lauria",@"Offered: Sonya Polaric",@"Offered: Sonya Polaric"];
    detailArray = @[@"Outdoors - Snow Plowing",@"Outdoors - Snow Plowing",@"Outdoors - Landscaping"];
    dateArray = @[@"3/16/15",@"3/20/15",@"3/21/15"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedTab = @"Offer";
    ORStatus = @"Open";
    [self getOffersFromWebService];
    
}


- (IBAction)OffersSegmentAction:(id)sender {
    
    switch (self.offersSegment.selectedSegmentIndex)
    {
        case 0:
            selectedTab = @"Offer";
            ORStatus = @"Open";
            break;
        case 1:
            selectedTab = @"Request";
            ORStatus = @"Open";
            break;
        case 2:
            selectedTab = @"Counter";
            ORStatus = @"Counter";
            goingToCounter=@"YES";
            break;
        case 3:
            selectedTab = @"Decline";
            ORStatus = @"Decline";
            break;
            
        default:
            break;
    }
    
    [self getOffersFromWebService];
    [self.tableView reloadData];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([userType isEqualToString:@"Helper"]) {
        
        if (self.offersSegment.selectedSegmentIndex==0) {
            return @"Offers you sent";
        }
        else if (self.offersSegment.selectedSegmentIndex==1)
            return @"Requests you received";
        else if (self.offersSegment.selectedSegmentIndex==2){
            return @"Counter Offers";
            
        }
        else{
            return @"Declined Offers";
        }
    }
    
    else{
        if (self.offersSegment.selectedSegmentIndex==0) {
            return @"Offers you Received";
        }
        else if (self.offersSegment.selectedSegmentIndex==1)
            return @"Requests you sent";
        else if (self.offersSegment.selectedSegmentIndex==2){
            return @"Counter Offers";
            
        }
        else{
            return @"Declined Offers";
        }
        
    }
    
    
    return nil;
    
}


-(void)getOffersFromWebService{
    
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetTymboxTransServlet?userid=%@&user_type=%@&ORType=%@&ORStatus=%@",userId,userType,selectedTab,ORStatus];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    NSLog(@"~~~~~ Status code: %ld", (long)[response statusCode]);
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray1 = [NSJSONSerialization
                                          JSONObjectWithData:respData
                                          options:NSJSONReadingMutableContainers
                                          error:&serializeError];
            
            openOfferesList = [[NSMutableArray alloc]init];
            
            
            
            for (NSMutableDictionary *dict in jsonArray1)
            {
                NSLog(@"dict===%@",dict);
                
                TransMasterObj *c = [[TransMasterObj alloc] init];
                
                c.Date_Type=        [dict objectForKey:@"jobreq_Datetype"];
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
                c.imgUrl            = [dict objectForKey:@"img_path"];
                NSMutableArray *detailArray1 = [[NSMutableArray alloc]init];
                
                detailArray1 = [dict objectForKey:@"arlTyboxTransDetail"];
                
                c.detArray = [[NSMutableArray alloc]init];
                
                for(NSMutableDictionary *detDict in detailArray1)
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
                
                NSLog(@"detArray===%lu",(unsigned long)[c.detArray count]);
                
                [openOfferesList addObject:c];
                
            }
            
            
        }else
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert1 show];
        }
        
    }else
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #define IMAGE_VIEW_TAG 99
    HelperOfferCell *cell1;
    TransMasterObj * talent = [[TransMasterObj alloc] init];
    talent = [openOfferesList objectAtIndex:indexPath.row];
    
    
    NSMutableArray *detObj = [[NSMutableArray alloc] init];
    detObj = talent.detArray;
    
    if([userType isEqualToString:@"Seeker"])
    {
        
        if ([selectedTab isEqualToString:@"Offer"])
        {
            HelperRequestCell *cell = (HelperRequestCell*)[self.tableView dequeueReusableCellWithIdentifier:@"RequestedCell"];
            
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"RequestedCell"];
            if (cell == nil){
                //initialize the cell view from the xib file
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HelperRequestCell"
                                                              owner:self options:nil];
                cell = (HelperRequestCell *)[nibs objectAtIndex:0];
             }
                cell.seekerName.text= talent.userName;
                cell.talentName.text= talent.user_Talent_Name;
                cell.reqDate.text = talent.job_Req_Date;
                //cell.kindOfDateLabel.text= @"Offered Date";
                //cell.SeekorHelp.text= @"Offered";
                //cell.SeekorHelp.text = [NSString stringWithFormat:@"%@%@%@",@"Offered ",talent.user_Talent_Name,@" Job"];
            TransDetObj *det = [[TransDetObj alloc]init];
            det = [detObj objectAtIndex:0];
            cell.ratelbl.text = [NSString stringWithFormat:@"Amount $ %@",det.total];
                cell.userImg.layer.borderColor = [UIColor grayColor].CGColor;
                cell.userImg.layer.cornerRadius = 2;
                cell.userImg.layer.borderWidth = 1;
                
                
                
                
                cell.userImg.tag = IMAGE_VIEW_TAG;
                cell.userImg.contentMode = UIViewContentModeScaleAspectFill;
                cell.userImg.clipsToBounds = YES;
                
                //get image view
                AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
                
                //cancel loading previous image for cell
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
                NSLog(@"=====%@",talent.imgUrl);
                if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
                {
                    NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                            NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:encodedUrl];
                    //load the image
                    cell.userImg.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
                }else{
                    UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                    cell.userImg.image = tempImage;
                    
                }
            
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

            
            return cell;
            
        }
        
        else if ([selectedTab isEqualToString:@"Request"]){
            cell1 = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            cell1.seekerName.text = talent.seekerName;
            
            cell1.whatYouSent.text= [NSString stringWithFormat:@"%@%@%@",@"Requested for : ",talent.user_Talent_Name,@" Job"];
            cell1.who.text =talent.userName;
            cell1.dateLabel.text= [NSString stringWithFormat:@"%@%@",@"Requested Date : ",talent.job_Req_Date];
            
            cell1.seekerImage.layer.borderColor = [UIColor grayColor].CGColor;
            cell1.seekerImage.layer.cornerRadius = 2;
            cell1.seekerImage.layer.borderWidth = 1;
            
            TransDetObj *det = [[TransDetObj alloc]init];
            det = [detObj objectAtIndex:0];
            cell1.ratelbl.text = [NSString stringWithFormat:@"Amount $ %@",det.total];
            
            cell1.seekerImage.tag = IMAGE_VIEW_TAG;
            cell1.seekerImage.contentMode = UIViewContentModeScaleAspectFill;
            cell1.seekerImage.clipsToBounds = YES;
            
            //get image view
            AsyncImageView *imageView = (AsyncImageView *)[cell1 viewWithTag:IMAGE_VIEW_TAG];
            
            //cancel loading previous image for cell
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
            NSLog(@"=====%@",talent.imgUrl);
            if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
            {
                NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:encodedUrl];
                //load the image
                cell1.seekerImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
            }else{
                UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                cell1.seekerImage.image = tempImage;
                
            }
            //[cell1.seekerImage.image drawInRect:CGRectMake((cell1.seekerImage.frame.size.width/2) - (cell1.seekerImage.image.size.width/2), (cell1.seekerImage.frame.size.height/2) - (cell1.seekerImage.image.size.height/2), cell1.seekerImage.image.size.width, cell1.seekerImage.image.size.height)];
            
            cell1.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

            
            return cell1;
            
        }
        
        //// Newly Adddd
        else if ([selectedTab isEqualToString:@"Counter"]){
            //
            
            CounterCell *cell = (CounterCell*)[self.tableView dequeueReusableCellWithIdentifier:@"counterTabCell"];
            if (cell == nil){
                //initialize the cell view from the xib file
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CounterCell"
                                                              owner:self options:nil];
                cell = (CounterCell *)[nibs objectAtIndex:0];
            }
                TransDetObj *detObj = [TransDetObj new];
                detObj = [talent.detArray objectAtIndex:0];
                NSLog(@"talent.user_Talent_Name;====%@",talent.user_Talent_Name);
                cell.userNamelbl.text = talent.userName;
                cell.talentNamelbl.text = talent.user_Talent_Name;
                cell.counterAmtlbl.text = [NSString stringWithFormat:@"$ %@",detObj.total];
                cell.jobDatelbl.text = talent.job_Req_Date;
                
                
                TransDetObj *actDetObj = [TransDetObj new];
                NSInteger detArrayCount = [talent.detArray count];
                
                actDetObj = [talent.detArray objectAtIndex:detArrayCount-1];
                
                cell.talentRatelbl.text = [NSString stringWithFormat:@"Actual $ %@",actDetObj.total];
                NSString *numberOfCount = [NSString stringWithFormat:@"Counters %ld",detArrayCount-1];
                [cell.counterBtn setTitle:numberOfCount forState:UIControlStateNormal];
                
                cell.counterBtn.layer.cornerRadius=4.0f;
                cell.counterBtn.layer.masksToBounds=YES;
                cell.counterBtn.layer.borderColor=[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
                cell.counterBtn.layer.borderWidth= 1.0f;
                
                cell.counterBtn.enabled = true;
                cell.counterBtn.tag = indexPath.row;
                [cell.counterBtn addTarget:self action:@selector(countdetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

                
                cell.userImg.layer.borderColor = [UIColor grayColor].CGColor;
                cell.userImg.layer.cornerRadius = 2;
                cell.userImg.layer.borderWidth = 1;
                
                
                
                cell.userImg.tag = IMAGE_VIEW_TAG;
                cell.userImg.contentMode = UIViewContentModeScaleAspectFill;
                cell.userImg.clipsToBounds = YES;
                
                //get image view
                AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
                
                //cancel loading previous image for cell
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
                NSLog(@"=====%@",talent.imgUrl);
                if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
                {
                    NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                            NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:encodedUrl];
                    //load the image
                    cell.userImg.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
                }else{
                    UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                    cell.userImg.image = tempImage;
                    
                }
                
            
           
            return cell;
        }
        else{
            
            HelperOfferCell *cell1;
            TransMasterObj * talent = [[TransMasterObj alloc] init];
            talent = [openOfferesList objectAtIndex:indexPath.row];
            
            
            NSMutableArray *detObj = [[NSMutableArray alloc] init];
            detObj = talent.detArray;
            
            
            cell1 = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            cell1.seekerName.text = talent.seekerName;
            
            cell1.whatYouSent.text= [NSString stringWithFormat:@"%@%@%@",@"Declined your ",talent.user_Talent_Name,@" Job"];
            cell1.who.text =talent.userName;
            cell1.dateLabel.text= [NSString stringWithFormat:@"%@",talent.job_Req_Date];
            
            cell1.seekerImage.layer.borderColor = [UIColor grayColor].CGColor;
            cell1.seekerImage.layer.cornerRadius = 2;
            cell1.seekerImage.layer.borderWidth = 1;
            
            
            cell1.seekerImage.tag = IMAGE_VIEW_TAG;
            cell1.seekerImage.contentMode = UIViewContentModeScaleAspectFill;
            cell1.seekerImage.clipsToBounds = YES;
            
            //get image view
            AsyncImageView *imageView = (AsyncImageView *)[cell1 viewWithTag:IMAGE_VIEW_TAG];
            
            //cancel loading previous image for cell
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
            NSLog(@"=====%@",talent.imgUrl);
            if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
            {
                NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:encodedUrl];
                //load the image
                cell1.seekerImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
            }else{
                UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                cell1.seekerImage.image = tempImage;
                
            }
            
            cell1.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

            
            return cell1;
            
            
        }
        
        
    }
    
    else{
        
        if([selectedTab isEqualToString:@"Offer"])
        {
            cell1 = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell1.whatYouSent.text= [NSString stringWithFormat:@"%@%@%@",@"Offered ",talent.user_Talent_Name,@" Job"];
            cell1.who.text = talent.seekerName;
            cell1.dateLabel.text= [NSString stringWithFormat:@"%@%@",@"Offered Date  ",talent.job_Req_Date];
            cell1.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"HelperOfferTableRow.png"]];
            [cell1.layer setCornerRadius:7.0f];
            
            cell1.seekerImage.layer.borderColor = [UIColor grayColor].CGColor;
            cell1.seekerImage.layer.cornerRadius = 2;
            cell1.seekerImage.layer.borderWidth = 1;
            
            TransDetObj *det = [[TransDetObj alloc]init];
            det = [detObj objectAtIndex:0];
            cell1.ratelbl.text = [NSString stringWithFormat:@"Amount $ %@",det.total];
            
            cell1.seekerImage.tag = IMAGE_VIEW_TAG;
            cell1.seekerImage.contentMode = UIViewContentModeScaleAspectFill;
            cell1.seekerImage.clipsToBounds = YES;
            
            //get image view
            AsyncImageView *imageView = (AsyncImageView *)[cell1 viewWithTag:IMAGE_VIEW_TAG];
            
            //cancel loading previous image for cell
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
            NSLog(@"=====%@",talent.imgUrl);
            if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
            {
                NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:encodedUrl];
                //load the image
                cell1.seekerImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
            }else{
                UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                cell1.seekerImage.image = tempImage;
                
            }
            
            cell1.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];


            
            return cell1;
        }
        else if ([selectedTab isEqualToString:@"Request"])
        {
            HelperRequestCell *cell = (HelperRequestCell*)[self.tableView dequeueReusableCellWithIdentifier:@"RequestedCell"];
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"RequestedCell"];
            if (cell == nil)
            {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HelperRequestCell" owner:self options:nil];
                cell = (HelperRequestCell *)[nibs objectAtIndex:0];
            }
                cell.seekerName.text= talent.seekerName;
                cell.talentName.text= talent.user_Talent_Name;
                cell.reqDate.text = talent.job_Req_Date;
                //cell.SeekorHelp.text = [NSString stringWithFormat:@"%@%@%@",@"Seeking for ",talent.user_Talent_Name,@" Job"];
            
            TransDetObj *det = [[TransDetObj alloc]init];
            det = [detObj objectAtIndex:0];
            cell.ratelbl.text = [NSString stringWithFormat:@"Amount $ %@",det.total];

            
                cell.userImg.layer.borderColor = [UIColor grayColor].CGColor;
                cell.userImg.layer.cornerRadius = 2;
                cell.userImg.layer.borderWidth = 1;
                
                
                
                cell.userImg.tag = IMAGE_VIEW_TAG;
                cell.userImg.contentMode = UIViewContentModeScaleAspectFill;
                cell.userImg.clipsToBounds = YES;
                
                //get image view
                AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
                
                //cancel loading previous image for cell
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
                NSLog(@"=====%@",talent.imgUrl);
                if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
                {
                    NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                            NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:encodedUrl];
                    //load the image
                    cell.userImg.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
                }else{
                    UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                    cell.userImg.image = tempImage;
                    
                }
                
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

                
            
            return cell;
        }
        else if ([selectedTab isEqualToString:@"Counter"])
        {
           
            CounterCell *cell = (CounterCell*)[self.tableView dequeueReusableCellWithIdentifier:@"counterTabCell"];
            if (cell == nil){
                //initialize the cell view from the xib file
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CounterCell"
                                                              owner:self options:nil];
                cell = (CounterCell *)[nibs objectAtIndex:0];
             }
                TransDetObj *detObj = [TransDetObj new];
                detObj = [talent.detArray objectAtIndex:0];
                NSLog(@"talent.user_Talent_Name;====%@",talent.user_Talent_Name);
                cell.userNamelbl.text = talent.userName;
                cell.talentNamelbl.text = talent.user_Talent_Name;
                cell.counterAmtlbl.text = [NSString stringWithFormat:@"$ %@",detObj.total];
                cell.jobDatelbl.text = talent.job_Req_Date;
                
                
                TransDetObj *actDetObj = [TransDetObj new];
                NSInteger detArrayCount = [talent.detArray count];
                
                actDetObj = [talent.detArray objectAtIndex:detArrayCount-1];
                
                cell.talentRatelbl.text = [NSString stringWithFormat:@"Actual $ %@",actDetObj.total];
                NSString *numberOfCount = [NSString stringWithFormat:@"Counters %ld",detArrayCount-1];
                [cell.counterBtn setTitle:numberOfCount forState:UIControlStateNormal];
                
                cell.counterBtn.layer.cornerRadius=4.0f;
                cell.counterBtn.layer.masksToBounds=YES;
                cell.counterBtn.layer.borderColor=[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
                cell.counterBtn.layer.borderWidth= 1.0f;
                
                cell.counterBtn.enabled = true;
                cell.counterBtn.tag = indexPath.row;
                [cell.counterBtn addTarget:self action:@selector(countdetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //cell.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"HelperOfferTableRow.png"]];
                
                cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                
                
                cell.selectedBackgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"selected.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                
                cell.userImg.layer.borderColor = [UIColor grayColor].CGColor;
                cell.userImg.layer.cornerRadius = 2;
                cell.userImg.layer.borderWidth = 1;
                
                
                
                cell.userImg.tag = IMAGE_VIEW_TAG;
                cell.userImg.contentMode = UIViewContentModeScaleAspectFill;
                cell.userImg.clipsToBounds = YES;
                
                //get image view
                AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
                
                //cancel loading previous image for cell
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
                NSLog(@"=====%@",talent.imgUrl);
                if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
                {
                    NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                            NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:encodedUrl];
                    //load the image
                    cell.userImg.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
                }else{
                    UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                    cell.userImg.image = tempImage;
                    
                }
            
            
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

            
            return cell;
        }
        else{
            
            HelperOfferCell *cell1;
            TransMasterObj * talent = [[TransMasterObj alloc] init];
            talent = [openOfferesList objectAtIndex:indexPath.row];
            
            
            NSMutableArray *detObj = [[NSMutableArray alloc] init];
            detObj = talent.detArray;
            
            
            cell1 = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            cell1.seekerName.text = talent.seekerName;
            
            cell1.whatYouSent.text= [NSString stringWithFormat:@"%@%@%@",@"Declined your ",talent.user_Talent_Name,@" Job"];
            cell1.who.text =talent.userName;
            cell1.dateLabel.text= [NSString stringWithFormat:@"%@",talent.job_Req_Date];
            
            cell1.seekerImage.layer.borderColor = [UIColor grayColor].CGColor;
            cell1.seekerImage.layer.cornerRadius = 2;
            cell1.seekerImage.layer.borderWidth = 1;
            
            
            
            cell1.seekerImage.tag = IMAGE_VIEW_TAG;
            cell1.seekerImage.contentMode = UIViewContentModeScaleAspectFill;
            cell1.seekerImage.clipsToBounds = YES;
            
            //get image view
            AsyncImageView *imageView = (AsyncImageView *)[cell1 viewWithTag:IMAGE_VIEW_TAG];
            
            //cancel loading previous image for cell
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
            NSLog(@"=====%@",talent.imgUrl);
            if(talent.imgUrl !=nil && ![talent.imgUrl isEqual:[NSNull null]] && ![talent.imgUrl isEqualToString:@""])
            {
                NSString* encodedUrl = [talent.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                        NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:encodedUrl];
                //load the image
                cell1.seekerImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
            }else{
                UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                cell1.seekerImage.image = tempImage;
                
            }
            
            cell1.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"HelperOfferTableRow.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];

            
            return cell1;
            
            
        }
        
    }
    
    
    return nil;
}

-(void)countdetailsBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    selectedIndex = senderButton.tag;
    
    
    [self performSegueWithIdentifier:@"counterDetails" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([userType isEqualToString:@"Seeker"]) {
        return 97.0;
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
            
            return 97;
        }
    }
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![selectedTab isEqualToString:@"Decline"]) {
        userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
        selectedIndex = indexPath.row;
        
        TransMasterObj * talent = [[TransMasterObj alloc] init];
        talent = [openOfferesList objectAtIndex:selectedIndex];
        
        NSArray *detArray = [[NSArray alloc]init];
        detArray = talent.detArray;
        NSLog(@"detArray ====%lu",(unsigned long)[detArray count]);
        
        if ([selectedTab isEqualToString:@"Offer"]) {
            if([userType isEqualToString:@"Helper"])
            {
                [self performSegueWithIdentifier:@"editOffer" sender:self];
                
            }else
                
            {
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
            
            TransDetObj *detObj = [detArray objectAtIndex:0];
            
            if([userName isEqualToString:detObj.createdBy])
            {
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"You already countered this.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert1 show];
                return;
            }
            else
            {
                [self performSegueWithIdentifier:@"OfferDetails" sender:self];
            }
            
        }
        
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"OfferDetails"]) {
        
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
        
        offerHelpViewController *showItemsTVC = [segue destinationViewController];
        
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
        
    }else if([segue.identifier isEqualToString:@"counterDetails"])
    {
        HistoryTVController* controller =(HistoryTVController*)[[segue destinationViewController] topViewController];
        //HistoryTVController *controller = [segue destinationViewController];
        TransMasterObj *selectedCounterObj = [TransMasterObj new];
        selectedCounterObj = [openOfferesList objectAtIndex:selectedIndex];
        
        NSLog(@"selectedCounterObj====%@", selectedCounterObj);
        controller.counterObj = selectedCounterObj;
    }
    
    
}

@end
