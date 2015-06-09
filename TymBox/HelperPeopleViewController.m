//
//  HelperPeopleViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/13/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "HelperPeopleViewController.h"
#import "HPTableViewCell.h"
#import "HPClass.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"

#import "AsyncImageView.h"

//#import "entryScreenViewController.h"
@interface HelperPeopleViewController ()
{
    NSString *userId;
    NSMutableArray *jsonArray;
    NSMutableArray *totalUsers;
    NSArray *requestSentArray;
    NSMutableArray *totalRequestSentGuys;
    BOOL clicked;
    NSMutableDictionary *pendingReqIds;
    NSMutableArray *requestSentIds;
    NSMutableArray *requestSentGuys;
    NSMutableArray *friendsArray;
    NSMutableArray *friendsJsonArray;
    NSMutableArray *friendsIDs;
    //entryScreenViewController *babu;
    NSString *userType;
    NSString *receiverUserType;
    
    NSString *firstStringUrl;
    NSString *secondStringUrl;
    NSString *thirdStringUrl;
    NSMutableArray *FriendsuniqueArray;
    
}
@property(strong,nonatomic) NSArray *array;

@end

@implementation HelperPeopleViewController
@synthesize custtableView,peopleSegment;
@synthesize isFiltered,searchbar,filteredDataArray;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*========= to get image url ===============*/
    //get image URLs
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Images" ofType:@"plist"];
    NSArray *imagePaths = [NSArray arrayWithContentsOfFile:plistPath];
    
    //remote image URLs
    NSMutableArray *URLs = [NSMutableArray array];
    for (NSString *path in imagePaths)
    {
        NSURL *URL = [NSURL URLWithString:path];
        if (URL)
        {
            [URLs addObject:URL];
        }
        else
        {
            NSLog(@"'%@' is not a valid URL", path);
        }
    }
    self.imageURLs = URLs;
    
    /*========= to get image url ===============*/
    
    
    
    searchbar.delegate = (id)self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    SWRevealViewController *reveal = self.revealViewController;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:reveal action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    
    self.title=@"People";
    self.array=[[NSArray alloc]
                initWithObjects:@"Sadik",@"Rama",@"Partha",@"Zakir",@"Thomas", nil];
    //babu = [[entryScreenViewController alloc] init];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId= [NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"userId"]] ;
    
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    
    firstStringUrl = [[NSString alloc]init];
    secondStringUrl = [[NSString alloc]init];;
    thirdStringUrl = [[NSString alloc]init];;
    
    peopleSegment.selectedSegmentIndex=0;
    firstStringUrl = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId];
    [self getHelperTransactions:firstStringUrl];
    
    // Do any additional setup after loading the view.
}
- (IBAction)indexChanged:(id)sender {
    
    switch (self.peopleSegment.selectedSegmentIndex)
    {
        case 0:
            // firstStringUrl=[NSString stringWithFormat:@"http://192.168.0.158:8080/TymBoxWeb/HelperListServlet?userid=%@",userId];
            
            firstStringUrl=[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId];
            
            
            //http://hyd.vertexcs.com:8081/TymBoxWeb/CategoryServlet
            [self getHelperTransactions:firstStringUrl];
            break;
        case 1:
            
            NSLog(@"%@",requestSentIds);
            NSLog(@"%@",friendsIDs);
            receiverUserType=@"Helper";
            
            secondStringUrl= [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/HelperListServlet?userid=%@",userId];
            [self getHelperTransactions:secondStringUrl];
            break;
        case 2:
            receiverUserType=@"Seeker";
            thirdStringUrl= [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet"];
            [self getHelperTransactions:thirdStringUrl];
            break;
        default:
            break;
    }
}
-(void) getRefreedFriends
{
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet";
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=39";
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@&ReferTo=ReferTo",userId];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    NSLog(@"responseCode====%@",responseCode);
    //NSLog(@"~~~~~ Status code: %d", (int)[response statusCode]);
    
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray1 = [NSJSONSerialization
                                          JSONObjectWithData:respData
                                          options:NSJSONReadingMutableContainers
                                          error:&serializeError];
            
            for (NSMutableDictionary *dict in jsonArray1)
            {
                
               // NSLog(@"==dict===%@",dict);
                
                if ([[dict objectForKey:@"status"] isEqualToString:@"Accepted"]) {
                    if(![userId isEqualToString:[dict objectForKey:@"refered_to"]])
                    {
                        HPClass *c = [[HPClass alloc] init];
                        c.hName = [dict objectForKey:@"itroducedByName"];
                        c.hId=[dict objectForKey:@"introduced_By"];
                        
                        if([dict objectForKey:@"image"])
                        {
                            c.imgUrl = [dict objectForKey:@"image"];
                        }else if([dict objectForKey:@"imageBase64"])
                        {
                            c.imgUrl = [dict objectForKey:@"imageBase64"];
                        }
                        
                        NSLog(@"imgurl====%@",c.imgUrl);
                        
                        /*
                        UIImage *uImage = [[UIImage alloc]init];
                        if([dict objectForKey:@"image"])
                        {
                            uImage = [self decodeBase64ToImage:[dict objectForKey:@"image"]];
                        }else if([dict objectForKey:@"imageBase64"])
                        {
                            uImage = [self decodeBase64ToImage:[dict objectForKey:@"imageBase64"]];
                        }
                        NSLog(@"uImage===%@",uImage);
                        c.hImage = uImage;
                        */
                        if (![friendsIDs containsObject:c.hId]) {
                            [friendsIDs addObject:[dict objectForKey:@"introduced_By"]];
                            [friendsArray addObject:c];
                        }
                        
                        
                        
                    }
                    
                }
            }
            //                FriendsuniqueArray = [NSMutableArray array];
            //
            //                [FriendsuniqueArray addObjectsFromArray:[[NSSet setWithArray:friendsIDs] allObjects]];
        }
    }
    
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)getHelperTransactions:(NSString *)RequestedUrl{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (peopleSegment.selectedSegmentIndex==0) {
            
            requestSentIds=[NSMutableArray array];
            requestSentGuys = [NSMutableArray array];
            pendingReqIds = [NSMutableDictionary dictionary];
            
            friendsIDs =[NSMutableArray array];
            totalRequestSentGuys=[[NSMutableArray alloc] init];
            friendsArray = [[NSMutableArray alloc] init];
            NSURL *url6=[NSURL URLWithString:[NSString stringWithFormat:@"%@",RequestedUrl]];
            friendsJsonArray = [self getResponse:url6];
            
            for (NSMutableDictionary *dict1 in friendsJsonArray){
                
                //NSLog(@"====%@",dict1);
                
                if ([[dict1 objectForKey:@"status"] isEqualToString:@"Accepted"]) {
                    if(![userId isEqualToString:[dict1 objectForKey:@"refered_to"]])
                    {
                        HPClass *c = [[HPClass alloc] init];
                        c.hName = [dict1 objectForKey:@"referedToName"];
                        c.hId=[dict1 objectForKey:@"refered_to"];
                        
                        if([dict1 objectForKey:@"image"])
                        {
                            c.imgUrl = [dict1 objectForKey:@"image"];
                        }else if([dict1 objectForKey:@"imageBase64"])
                        {
                            c.imgUrl = [dict1 objectForKey:@"imageBase64"];
                        }
                        
                        NSLog(@"imgurl====%@",c.imgUrl);
                        
                        /*
                        UIImage *uImage = [[UIImage alloc]init];
                        if([dict1 objectForKey:@"image"])
                        {
                            uImage = [self decodeBase64ToImage:[dict1 objectForKey:@"image"]];
                        }else if([dict1 objectForKey:@"imageBase64"])
                        {
                            uImage = [self decodeBase64ToImage:[dict1 objectForKey:@"imageBase64"]];
                        }
                        NSLog(@"uImage===%@",uImage);
                        c.hImage = uImage;
                        */
                        [friendsIDs addObject:[dict1 objectForKey:@"refered_to"]];
                        [friendsArray addObject:c];
                    }
                    
                }
                else{
                    NSLog(@"Still awaiitng for response");
                    
                }
                
            }
            [self getRefreedFriends];
            NSLog(@"%@",friendsIDs);
            
        }
        
        else{
            
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId]];
            
            totalRequestSentGuys=[[NSMutableArray alloc] init];
            requestSentArray = [self getResponse:url];
            
            
            for (NSMutableDictionary *dict1 in requestSentArray)
            {
                NSLog(@"dict1===%@",dict1);
                
                if ([[dict1 objectForKey:@"status"] isEqualToString:@"Request Sent"])  {
                    [requestSentIds addObject:[dict1 objectForKey:@"refered_to"]];
                }
                else if ([[dict1 objectForKey:@"status"] isEqualToString:@"Accepted"]){
                    
                    [friendsIDs addObject:[dict1 objectForKey:@"refered_to"]];
                    
                }
                else if([[dict1 objectForKey:@"status"] isEqualToString:@"OnHold"])
                {
                    //
                    [pendingReqIds setValue:[dict1 valueForKey:@"refered_to"] forKey:[dict1 valueForKey:@"refered_to"]];
                }
            }
            
            
            
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@&ReferTo=ReferTo",userId]];
            
            
            NSArray *requestSentArray1 = [NSArray new];
            requestSentArray1    = [self getResponse:url];
            
            
            for (NSMutableDictionary *dict1 in requestSentArray1)
            {
                NSLog(@"dict1===%@",dict1);
                
                if ([[dict1 objectForKey:@"status"] isEqualToString:@"Request Sent"])  {
                    [requestSentIds addObject:[dict1 objectForKey:@"introduced_By"]];
                }
                else if ([[dict1 objectForKey:@"status"] isEqualToString:@"Accepted"]){
                    
                    [friendsIDs addObject:[dict1 objectForKey:@"introduced_By"]];
                    
                }
                else if([[dict1 objectForKey:@"status"] isEqualToString:@"OnHold"])
                {
                 //
                    [pendingReqIds setValue:[dict1 valueForKey:@"introduced_By"] forKey:[dict1 valueForKey:@"introduced_By"]];
                }
                 
            }
            NSLog(@"pendingReqIds====%@",pendingReqIds);
            NSLog(@"%@",requestSentIds);
            NSLog(@"%@",friendsIDs);
            
            NSURL *url1=[NSURL URLWithString:[NSString stringWithFormat:@"%@",RequestedUrl]];
            
            totalUsers=[[NSMutableArray alloc] init];
            jsonArray = [self getResponse:url1];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                //NSLog(@"dict===%@",dict);
                NSLog(@"userId====%@:::%@",userId,[dict objectForKey:@"user_Id"]);
                NSString *strTempUSerId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_Id"]];
                
                if(![userId isEqualToString:strTempUSerId])
                {
                    HPClass *c = [[HPClass alloc] init];
                    c.hName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_Name"]];
                    c.hId=[dict objectForKey:@"user_Id"];
                    
                    //UIImage *uImage = [[UIImage alloc]init];
                    NSLog(@"hid===%@",c.hId);
                    NSLog(@"pendingReqIds====%@",pendingReqIds);
                    if([dict objectForKey:@"image"])
                    {
                        c.imgUrl = [dict objectForKey:@"image"];
                    }else if([dict objectForKey:@"imageBase64"])
                    {
                        c.imgUrl = [dict objectForKey:@"imageBase64"];
                    }
                    
                    NSLog(@"imgurl====%@",c.imgUrl);
                    
                    if ([requestSentIds containsObject:c.hId]) {
                        c.Status=@"Request Sent";
                    }
                    
                    else if([pendingReqIds objectForKey:c.hId])
                    {
                        c.Status=@"Pending";
                    }
                    if (![friendsIDs containsObject:c.hId]) {
                        NSLog(@"%s","He is already a friend");
                        [totalUsers addObject:c];
                    }
                }
            }
            
        }
           dispatch_async(dispatch_get_main_queue(), ^(void) {
            

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [custtableView reloadData];
        });
    });
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        
        filteredDataArray = [[NSMutableArray alloc] init];
        if (peopleSegment.selectedSegmentIndex==0) {
            
            for (HPClass* obj in friendsArray)
            {
                NSRange nameRange = [obj.hName rangeOfString:text options:NSCaseInsensitiveSearch];
                //NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [filteredDataArray addObject:obj];
                }
            }
        }else{
            
            for (HPClass* obj in totalUsers)
            {
                NSRange nameRange = [obj.hName rangeOfString:text options:NSCaseInsensitiveSearch];
                //NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [filteredDataArray addObject:obj];
                }
            }
        }
    }
    
    [custtableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (peopleSegment.selectedSegmentIndex==0) {
        
        NSUInteger rowCount;
        if(self.isFiltered)
            rowCount = filteredDataArray.count;
        else
            rowCount = friendsArray.count;
        
        return rowCount;
        //return friendsArray.count;
    }
    else{
        NSUInteger rowCount;
        if(self.isFiltered)
            rowCount = filteredDataArray.count;
        else
            rowCount = totalUsers.count;
        
        return rowCount;
        //return totalUsers.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #define IMAGE_VIEW_TAG 99
    
    static NSString *CellIdentifier = @"Cell";
    HPTableViewCell *cell = (HPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[HPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //HPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (peopleSegment.selectedSegmentIndex==0) {
        
        HPClass *helper = nil;
        
        //if (tableView == self.searchDisplayController.searchResultsTableView)
        if(isFiltered)
        {
            helper = [filteredDataArray objectAtIndex:indexPath.row];
        }
        else
        {
            helper = [friendsArray objectAtIndex:indexPath.row];
        }
        
        //HPClass *helper = (friendsArray)[indexPath.row];
        NSLog(@"%@",helper.hName);
        NSLog(@"%@",helper.hId);
        
        cell.friendBtn.alpha = 1;
        cell.addFriendBtn.alpha = 0;
        cell.requestsentBtn.alpha = 0;
        cell.pendingBtn.alpha = 0;
        
        cell.helperName.text=helper.hName;
        cell.addFriendBtn.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"friends-bt.png"]];
        //[cell.addFriendBtn setTitle:@"Friends" forState:UIControlStateNormal];
        cell.addFriendBtn.enabled = false;
        //        cell.addFriendBtn.layer.borderColor = [UIColor grayColor].CGColor;
        //        cell.addFriendBtn.layer.cornerRadius = 2;
        //        cell.addFriendBtn.layer.borderWidth = 1;
        
        //cell.helperImage.image = helper.hImage;
        cell.helperImage.layer.borderColor = [UIColor grayColor].CGColor;
        cell.helperImage.layer.cornerRadius = 2;
        cell.helperImage.layer.borderWidth = 1;
        
        [cell.helperImage.image drawInRect:CGRectMake((cell.helperImage.frame.size.width/2) - (cell.helperImage.image.size.width/2), (cell.helperImage.frame.size.height/2) - (cell.helperImage.image.size.height/2), cell.helperImage.image.size.width, cell.helperImage.image.size.height)];
        
        /*=-=============== to load image asyncronusly ===========*/
        cell.helperImage.tag = IMAGE_VIEW_TAG;
        cell.helperImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.helperImage.clipsToBounds = YES;
        
        //get image view
        AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
        
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        NSLog(@"=====%@",helper.imgUrl);
        if(helper.imgUrl !=nil && ![helper.imgUrl isEqual:[NSNull null]] && ![helper.imgUrl isEqualToString:@""])
        {
            NSString* encodedUrl = [helper.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:encodedUrl];
            //load the image
            cell.helperImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
        }else{
            UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
            cell.helperImage.image = tempImage;
            if(helper.hImage)
            {
                cell.helperImage.image = helper.hImage;
            }
        }
    }
    
    else{
        
        HPClass *helper = nil;
        
        //if (tableView == self.searchDisplayController.searchResultsTableView)
        if(isFiltered)
        {
            helper = [filteredDataArray objectAtIndex:indexPath.row];
        }
        else
        {
            helper = [totalUsers objectAtIndex:indexPath.row];
        }
        
        //HPClass *helper = (totalUsers)[indexPath.row];
        cell.helperName.text=helper.hName;
        
        cell.addFriendBtn.tag=indexPath.row;
        
        cell.friendBtn.alpha = 0;
        cell.addFriendBtn.alpha = 0;
        cell.requestsentBtn.alpha = 0;
        cell.pendingBtn.alpha = 0;
        
        cell.addFriendBtn.enabled = true;
        //        cell.addFriendBtn.layer.cornerRadius = 2;
        //        cell.addFriendBtn.layer.borderWidth = 1;
        
        NSLog(@"==helper.Status===%@",helper.Status);
        
        if ([helper.Status isEqualToString:@"Request Sent"]) {
            cell.requestsentBtn.alpha = 1;
            //cell.addFriendBtn.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"request-sent-bt.png"]];
            
            //cell.addFriendBtn.enabled = false;
            //cell.addFriendBtn.layer.borderColor = [UIColor grayColor].CGColor;
        }else if([helper.Status isEqualToString:@"Pending"])
        {
            cell.pendingBtn.alpha = 1;
            /*
            UIImage *image = [UIImage imageNamed:@"declain-bt.png"];
            UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f);
            UIImage *stretchedImage = [image resizableImageWithCapInsets:insets];
            [cell.addFriendBtn setBackgroundImage:stretchedImage forState:UIControlStateNormal];
            [cell.addFriendBtn setTitle:@"Pending" forState:UIControlStateNormal];
            */
            //cell.addFriendBtn.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"declain-bt.png"]];
            
            //cell.addFriendBtn.enabled = false;
        }
        else{
            
            cell.addFriendBtn.alpha = 1;
            
            cell.addFriendBtn.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"add-friend-bt.png"]];
            [cell.addFriendBtn addTarget:self
                                  action:@selector(addFriend:)
                        forControlEvents:UIControlEventTouchUpInside];
            
            // cell.addFriendBtn.layer.borderColor = cell.addFriendBtn.tintColor.CGColor;
        }
        /*
        UIImage *tempImage = [UIImage imageNamed:@"spr.png"];
        cell.helperImage.image = tempImage;
        if(helper.hImage)
        {
            cell.helperImage.image = helper.hImage;
        }
        */
        cell.helperImage.layer.borderColor = [UIColor grayColor].CGColor;
        cell.helperImage.layer.cornerRadius = 2;
        cell.helperImage.layer.borderWidth = 1;
        
        [cell.helperImage.image drawInRect:CGRectMake((cell.helperImage.frame.size.width/2) - (cell.helperImage.image.size.width/2), (cell.helperImage.frame.size.height/2) - (cell.helperImage.image.size.height/2), cell.helperImage.image.size.width, cell.helperImage.image.size.height)];
        
        /*=-=============== to load image asyncronusly ===========*/
        cell.helperImage.tag = IMAGE_VIEW_TAG;
        cell.helperImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.helperImage.clipsToBounds = YES;
        
        //get image view
        AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
        
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        
        //load the image
        
        NSLog(@"=====%@",helper.imgUrl);
        if(helper.imgUrl !=nil && ![helper.imgUrl isEqual:[NSNull null]] && ![helper.imgUrl isEqualToString:@""])
        {
            NSString* encodedUrl = [helper.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                    NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:encodedUrl];
            //load the image
            cell.helperImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
        }else{
            UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
            cell.helperImage.image = tempImage;
            if(helper.hImage)
            {
                cell.helperImage.image = helper.hImage;
            }
        }
        
    }
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"add-friend-bg.png"]];
    
    return cell;
    
}

- (void)addFriend:(id)sender
{
    NSLog(@"Add friend.");
    UIButton *btnTemp = (UIButton *)sender;
    NSInteger iTag = btnTemp.tag;
    
    NSLog(@"Alredy Sent Request %ld",(long)iTag);
    HPClass *tempObject = [totalUsers objectAtIndex:btnTemp.tag];
    
    if ([btnTemp.titleLabel.text isEqualToString:@"Request Sent"]) {
        NSLog(@"Alredy Sent Request");
        
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *helperId;
        NSString *helperStatus;
        NSURL *requrl;
        NSString *posttring;
        NSData *responseData;
        helperId= tempObject.hId;
        helperStatus = @"Request Sent";
        requrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateIntroFriendServlet"]];
        posttring =[NSString stringWithFormat:@"{\"Introduced_By\":\"%@\",\"Refered_To\":\"%@\",\"User_Type\":\"%@\",\"Status\":\"%@\"}",userId,helperId,receiverUserType,helperStatus];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[posttring length]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:requrl];
        [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [posttring dataUsingEncoding:NSUTF8StringEncoding]];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        if (!responseData)
        {
            NSLog(@"Download Error: %@", error.localizedDescription);
            
        }
        //**************************************    AFTER GETTING RESPONSE    *******************************************
        NSDictionary *jsonDictionary;
        jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (jsonDictionary == nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Error in Api" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert1 show];
            
            NSLog(@"JSON Error: %@", error);
        }
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Successfully Inserted to DB"]) {
                //[btnTemp setTitle:@"Request Sent" forState:UIControlStateNormal];
                tempObject.Status = @"Request Sent";
                
                UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Request Sent sucessfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert1 show];
                
                
            }else if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Alredy Sent Request"])
            {
                UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"Info" message:@"Alredy Sent Request" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert1 show];
            }
            
            
        }
        
        [custtableView reloadData];
    }
    
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
