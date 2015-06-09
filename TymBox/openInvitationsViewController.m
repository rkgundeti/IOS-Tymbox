//
//  openInvitationsViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/15/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "openInvitationsViewController.h"
#import "openInvi.h"
#import "openInviClass.h"
#import "WebService.h"
#import "MBProgressHUD.h"

#import "AsyncImageView.h"

@interface openInvitationsViewController ()
{
    NSMutableArray *totalInvitations;
    NSMutableArray *jsonArray;
    NSMutableArray *jsonArray2;
    NSMutableArray *AcceptjsonArray;
    NSString *userId;
    NSString *userType;
    NSURL *url2;
    NSString *invitedUser;
    NSString *referedType;
    NSString *acceptedBy;
    
    BOOL acee;

}
@end

@implementation openInvitationsViewController
@synthesize custtableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"<" forState:UIControlStateNormal];
//    [btn setFrame:CGRectMake(0, 0, 30, 30)];
//    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    [self.navigationItem setLeftBarButtonItem:eng_btn];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    
//    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
//    self.navigationController.navigationBar.titleTextAttributes = size;
    
    self.title = @"My Invitations";
    
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    userId = [defaults stringForKey:@"user_id"];
//    userType = [defaults stringForKey:@"selectedMenu"];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"userId"]] ;
    
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    //NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];
    //userId=[userInfoDic valueForKey:@"userId"];
    
    //userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    if([userType isEqualToString:@"Helper"])
    {
       url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetTymoxIntroduceFriendList?user_Id=%@&Helper=Helper",userId]];
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        url2=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetTymoxIntroduceFriendList?user_Id=%@&Seeker=Seeker",userId]];
    }
    self.title=@"Invitations";
    custtableView.contentInset = UIEdgeInsetsZero;
    //tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self getInvitations];
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeNotification:) name:@"closeNotification" object:nil];
    // Do any additional setup after loading the view.
}

- (void) closeNotification:(NSNotification *)notification{
    
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    if([[theString objectForKey:@"Info"] isEqualToString:@"Ok"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.alertViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"PopUpViewController_iPad" bundle:nil];
        [self.alertViewController setTitle:@"This is a popup view"];
        
        [self.alertViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"You just triggered a great popup window" animated:YES messageType:@"Info"];
    } else {
        
        self.alertViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"CustomAlertBoxViewCon" bundle:nil];
        [self.alertViewController setTitle:title];
        
        [self.alertViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:msg animated:YES messageType:title];
        
        self.alertViewController.view.superview.frame = CGRectMake(0, 0, 310, 500);
        self.alertViewController.view.superview.center = self.view.center;
        
    }
}

//- (IBAction)back:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    //[self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)getInvitations{

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    totalInvitations=[[NSMutableArray alloc] init];
    NSURL *url1=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@&ReferTo=ReferTo",userId]];
    
    
    
    
    jsonArray = [self getResponse:url1];
    
    jsonArray2 = [self getResponse:url2];
    
    
    
    //    jsonArray = [WebService getResponse:url1];
    
    
    for (NSMutableDictionary *dict in jsonArray)
    {
        NSLog(@"dict===%@",dict);
        
        if (![[dict objectForKey:@"status"] isEqualToString:@"Accepted"]) {
            
            openInviClass *c = [[openInviClass alloc] init];
            c.invitationuserName = [dict objectForKey:@"itroducedByName"];
            c.invitationuserId=[dict objectForKey:@"introduced_By"];
            c.dBId=[dict objectForKey:@"dbId"];
            c.referType = @"introduce";
            c.seekerStatus = [dict objectForKey:@"status"];
            c.helperStatus = [dict objectForKey:@"status"]; //@"Rejected";
            c.imgUrl = [dict objectForKey:@"image"];
            [totalInvitations addObject:c];
        }
    }
    
    for (NSMutableDictionary *dict in jsonArray2)
    {
        NSLog(@"dict===%@",dict);
        
        
        openInviClass *c = [[openInviClass alloc] init];
        NSString *tempId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"helper_Refer_To_Id"]];
        NSString *tempId1 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"seeker_Refer_To_Id"]];
        if([userId isEqualToString:tempId])
        {
            c.invitationuserName = [dict objectForKey:@"seekerName"];
            c.invitationuserId=[dict objectForKey:@"seeker_Refer_To_Id"];
            NSString *status = [dict objectForKey:@"seeker_Status"];
            if([status isEqualToString:@""])
            {
                c.seekerStatus = @"Pending";
            }else
            {
                c.seekerStatus = [dict objectForKey:@"seeker_Status"];
            }
            c.acceptedBy = @"Helper";
            
        }else if([userId isEqualToString:tempId1])
        {
            c.invitationuserName = [dict objectForKey:@"helperName"];
            c.invitationuserId=[dict objectForKey:@"helper_Refer_To_Id"];
            NSString *status = [dict objectForKey:@"helper_Status"];
            if([status isEqualToString:@""])
            {
                c.helperStatus = @"Pending";
            }else
            {
                c.helperStatus = [dict objectForKey:@"helper_Status"];
            }
            c.acceptedBy = @"Seeker";
        }
        
        UIImage *uImage = [self decodeBase64ToImage:[dict objectForKey:@"imageBase64"]];
        c.imageFile = uImage;
        c.dBId=[dict objectForKey:@"hs_if_Id"];
        c.referType = @"refered";
        c.imgUrl = [dict objectForKey:@"image"];
        [totalInvitations addObject:c];
        
    }
    
    
    // dispatch_async(dispatch_get_main_queue(), ^(void) {
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.custtableView reloadData];
    
    
    // });
    
    
    // });
    
}

-(NSMutableArray *)getResponse:(NSURL *) stringUrl{
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    //        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.42:8080/TymBoxWeb/CategoryServlet"]];
    // http://192.168.0.187:8080/TymBoxWeb/CategoryServlet
    
    
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:stringUrl];
    [theRequest setHTTPMethod:@"GET"];
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    
    return arr;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [totalInvitations count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #define IMAGE_VIEW_TAG 99
    
    static NSString *CellIdentifier = @"Cell";
    openInvi *cell = (openInvi *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[openInvi alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //openInvi *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    openInviClass *Invi = (totalInvitations)[indexPath.row];
    cell.userName.text= Invi.invitationuserName;
    
    NSLog(@"%@====%@",userId,Invi.invitationuserId);
    
    cell.acceptBtn.alpha = 1;
    cell.rejectBtn.alpha = 1;
    cell.statusLbl.alpha = 0;
    
    //if(![userId isEqualToString:Invi.invitationuserId])
    //{
        NSString *status;
        if([Invi.acceptedBy isEqualToString:@"Helper"])
        {
            status = Invi.helperStatus;
        }else
        {
            status = Invi.seekerStatus;
        }
    
    NSLog(@"==Invi.helperStatus ===%@  %@",Invi.helperStatus,Invi.seekerStatus );
    
    if([Invi.helperStatus isEqualToString:@"Pending"] || [Invi.seekerStatus isEqualToString:@"Pending"])
    {
        cell.acceptBtn.alpha = 0;
        cell.rejectBtn.alpha = 0;
        cell.statusLbl.alpha = 1;
        cell.statusLbl.text = @"Pending";
        cell.statusLbl.layer.cornerRadius = 2;
        cell.statusLbl.layer.borderWidth = 1;
        cell.statusLbl.layer.borderColor = [UIColor grayColor].CGColor;
        [cell.statusLbl setTextColor:[UIColor redColor]];
        cell.statusLbl.textAlignment = NSTextAlignmentCenter;
        
    }else if([Invi.helperStatus isEqualToString:@"OnHold"] || [Invi.seekerStatus isEqualToString:@"OnHold"])
    {
        cell.acceptBtn.alpha = 0;
        cell.rejectBtn.alpha = 0;
        cell.statusLbl.alpha = 1;
        cell.statusLbl.text = @"On Hold";
        cell.statusLbl.layer.cornerRadius = 2;
        cell.statusLbl.layer.borderWidth = 1;
        cell.statusLbl.layer.borderColor = [UIColor grayColor].CGColor;
        [cell.statusLbl setTextColor:[UIColor redColor]];
        cell.statusLbl.textAlignment = NSTextAlignmentCenter;
        
    }
    
    //}
    
    cell.acceptBtn.tag=indexPath.row;
    
    cell.acceptBtn.layer.cornerRadius = 2;
    cell.acceptBtn.layer.borderWidth = 1;
    cell.acceptBtn.layer.borderColor = cell.acceptBtn.tintColor.CGColor;
    
    //cell.userImage.image = Invi.imageFile;
    cell.userImage.layer.borderWidth = 1.0f;
    
    cell.userImage.layer.borderColor = [UIColor grayColor].CGColor;
    
    cell.userImage.layer.cornerRadius = 10.0f; //cell.userImg.frame.size.width / 2;
    cell.userImage.clipsToBounds = YES;
    
    
    [cell.userImage.image drawInRect:CGRectMake((cell.userImage.frame.size.width/2) - (cell.userImage.image.size.width/2), (cell.userImage.frame.size.height/2) - (cell.userImage.image.size.height/2), cell.userImage.image.size.width, cell.userImage.image.size.height)];
    
    
    cell.userImage.tag = IMAGE_VIEW_TAG;
    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.userImage.clipsToBounds = YES;
    
    //get image view
    AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
    
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    NSLog(@"=====%@",Invi.imgUrl);
    if(Invi.imgUrl !=nil && ![Invi.imgUrl isEqual:[NSNull null]] && ![Invi.imgUrl isEqualToString:@""])
    {
        NSString* encodedUrl = [Invi.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodedUrl];
        //load the image
        cell.userImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
    }else{
        UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
        cell.userImage.image = tempImage;
        
    }
    
    
    cell.rejectBtn.tag=indexPath.row;
    
    cell.rejectBtn.layer.cornerRadius = 2;
    cell.rejectBtn.layer.borderWidth = 1;
    cell.rejectBtn.layer.borderColor = [UIColor redColor].CGColor;;
    cell.rejectBtn.tintColor = [UIColor purpleColor];
    [cell.rejectBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    [cell.acceptBtn addTarget:self
                       action:@selector(acceptFriend:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [cell.rejectBtn addTarget:self
                       action:@selector(rejectFriend:)
             forControlEvents:UIControlEventTouchUpInside];
    
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"table-row.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    return cell;
    
}

- (void)rejectFriend:(id)sender
{
    
    NSLog(@"reject friend.");
    UIButton *btnTemp = (UIButton *)sender;
    NSInteger iTag = btnTemp.tag;
    NSLog(@"iTag===%ld",(long)iTag);
    
    NSString *status= @"OnHold";
    
    openInviClass *tempObject = [totalInvitations objectAtIndex:btnTemp.tag];
    
    invitedUser = tempObject.invitationuserName;
    referedType = tempObject.referType;
    acceptedBy = tempObject.acceptedBy;
    
    
    NSURL *url1;
    NSString *msg;
    
    if([referedType isEqualToString:@"introduce"])
    {
        msg = [NSString stringWithFormat:@"%@'s Friend request is put On Hold",invitedUser];
        
        //[for tymbox.Introduce_Friend]
        //http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?Status =Open&UserId=39&Id=1&Introduce=Introduce
        
        url1 = [[NSURL alloc]init];
        
        url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?status=%@&userId=%@&DbId=%@&Introduce=Introduce",status,userId,tempObject.dBId]];
    }else{
        
        //[for tymbox.helper_seeker_introduce_friend]
        //http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?Status =Open&UserId=39&Id=1&HelperSeekerIntro=HelperSeekerIntro&Helper=Helper(or Seeker)
        url1 = [[NSURL alloc]init];
        
        msg = [NSString stringWithFormat:@"%@'s Friend request is put On Hold",invitedUser];
        NSString *urlString = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?Status=%@&UserId=%@&Id=%@&HelperSeekerIntro=HelperSeekerIntro&Helper=%@",status,userId,tempObject.dBId,acceptedBy];
        
        url1 = [NSURL URLWithString:urlString];
        
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    totalInvitations = [[NSMutableArray alloc] init];
    
    AcceptjsonArray=[self getResponse:url1];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertStatus:msg :@"Error" :0];
    if(AcceptjsonArray.count >0)
    {
        [self getInvitations];
    }
}

- (void)acceptFriend:(id)sender
{
    
    NSLog(@"Add friend.");
    UIButton *btnTemp = (UIButton *)sender;
    NSInteger iTag = btnTemp.tag;
    NSLog(@"iTag===%ld",(long)iTag);
   
    
    
    NSString *status= @"Accepted";
    
    
    
    openInviClass *tempObject = [totalInvitations objectAtIndex:btnTemp.tag];
    
    invitedUser = tempObject.invitationuserName;
    referedType = tempObject.referType;
    acceptedBy = tempObject.acceptedBy;
    
    
    NSURL *url1;
    NSString *msg;

    if([referedType isEqualToString:@"introduce"])
    {
        msg = [NSString stringWithFormat:@"you are now connected to %@",invitedUser];
    
        //[for tymbox.Introduce_Friend]
        //http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?Status =Open&UserId=39&Id=1&Introduce=Introduce
        
        url1 = [[NSURL alloc]init];
        
        url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?status=%@&userId=%@&DbId=%@&Introduce=Introduce",status,userId,tempObject.dBId]];
    }else{
        
        //[for tymbox.helper_seeker_introduce_friend]
        //http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?Status =Open&UserId=39&Id=1&HelperSeekerIntro=HelperSeekerIntro&Helper=Helper(or Seeker)
        url1 = [[NSURL alloc]init];
        
        msg = [NSString stringWithFormat:@"You are now friend of %@",invitedUser];
        NSString *urlString = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateFriendListServlet?Status=%@&UserId=%@&Id=%@&HelperSeekerIntro=HelperSeekerIntro&Helper=%@",status,userId,tempObject.dBId,acceptedBy];
        
        url1 = [NSURL URLWithString:urlString];
        
    }
    
    AcceptjsonArray=[self getResponse:url1];
    
    if (AcceptjsonArray) {
       
        [sender setBackgroundImage:[UIImage imageNamed:@"friends-bt.png"] forState:UIControlStateNormal];
    }
    
   [self getInvitations];
    
    
    
    
    [self.custtableView reloadData];
//    NSIndexPath *selectedIndexPath = [self.custtableView indexPathForSelectedRow];
//    
//    [self.custtableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
   
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    
     
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
