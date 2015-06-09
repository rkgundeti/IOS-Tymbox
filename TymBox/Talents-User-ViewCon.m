//
//  Talents-User-ViewCon.m
//  TymBox030915
//
//  Created by Rama Krishna.G on 06/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "Talents-User-ViewCon.h"
#import "seekerObj.h"
#import "HSTableViewCell.h"
//#import "Offer-RequestViewCon.h"

@interface Talents_User_ViewCon ()
{
    NSString *loggedInuserId;
    NSString *selectedMenu;
    OfferObject *offObj;
}
@end

@implementation Talents_User_ViewCon
@synthesize seekerArray;
@synthesize filteredseekerArray;
@synthesize searchbar,custTableView;
@synthesize selectedId,selectedName,selectedTab;
@synthesize isFiltered;
@synthesize selectedLabel,lblLabel,offerObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    searchbar.delegate = (id)self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    loggedInuserId = [defaults stringForKey:@"user_id"];
    selectedMenu = [defaults stringForKey:@"selectedMenu"];
    
    offObj = [[OfferObject alloc]init];
    offObj = offerObj;
    
    NSLog(@"selectedName====%@ %@  %@",selectedName,selectedId,selectedTab);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"<" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 30, 20)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:eng_btn];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Background_portrait.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_portrait.png"]];
    [tempImageView setFrame:custTableView.frame];
    
    custTableView.backgroundView = tempImageView;
    //[tempImageView release];
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    selectedLabel.text = selectedName;
    
    if([selectedTab isEqualToString:@"Helpers"] || [selectedTab isEqualToString:@"Seekers"])
    {
        self.navigationItem.title = @"User Talents";
        if([selectedTab isEqualToString:@"Helpers"])
        {
            [self checkWebService:selectedId];
            lblLabel.text = @"Helper : ";
        }
        else if([selectedTab isEqualToString:@"Seekers"])
        {
            [self checkWebService:loggedInuserId];
            lblLabel.text = @"Seeker : ";
        }
        
        
    }else{
        lblLabel.text = @"Talent : ";
        if ([selectedMenu isEqualToString:@"Helper"]) {
            self.navigationItem.title = @"Seekers";
            [self getUsersService];
        }else if ([selectedMenu isEqualToString:@"Seeker"]) {
            self.navigationItem.title = @"Helpers";
            [self getUsersBasedONTalentService:selectedId];
        }
        
    }
    
    //[self getUsersBasedONTalentService];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"footer-portrait.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //self.title=@"Seekers";
    
    NSLog(@"====%d",(int)[seekerArray count]);
    filteredseekerArray =[[NSMutableArray alloc] initWithCapacity:[seekerArray count]];
    [custTableView reloadData];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) checkWebService:(NSString *)strId  {
    
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",strId];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            seekerArray = [[NSMutableArray alloc]init];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                
                //NSString *address =[NSString stringWithFormat:@"%@",[dict objectForKey:@"categoryName"]];
                
                UIImage *uImage;
                
                [seekerArray addObject:[seekerObj newSeeker:[dict objectForKey:@"talentName"] seekerId:[dict objectForKey:@"talentId"] withImage:uImage rate:[NSString stringWithFormat:@"%@",[dict objectForKey:@"rate"]] rateType:[dict objectForKey:@"rateType"]]];
                
                
            }
            
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void) getUsersBasedONTalentService:(NSString *)strId
{
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentWise?talentId=%@",strId];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    NSLog(@"responseCode====%@",responseCode);
    NSLog(@"~~~~~ Status code: %d", (int)[response statusCode]);
    
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            seekerArray = [[NSMutableArray alloc]init];
            //availService = [NSMutableDictionary dictionary];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                
                
                NSString *getUserId =[dict objectForKey:@"userId"];
                NSLog(@"getUserId===%@",getUserId);
                if(![loggedInuserId isEqualToString:[NSString stringWithFormat:@"%@",getUserId]])
                {
                    
                    //NSString *talentCounts = [NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]];
                    //if(![talentCounts isEqualToString:@"0"])
                    //{
                    UIImage *uImage; //= [self decodeBase64ToImage:[dict objectForKey:@"imageBase64"]];
                    NSLog(@"uImage===%@",uImage);
                    
                    [seekerArray addObject:[seekerObj newSeeker:[dict objectForKey:@"userName"] seekerId:[dict objectForKey:@"userId"] withImage:uImage rate:[NSString stringWithFormat:@"%@",[dict objectForKey:@"rate"]] rateType:[dict objectForKey:@"rateType"]]];
                    //}
                }
                //[availService setObject:c forKey:[dict objectForKey:@"Date"]];
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
}

-(void) getReferToUsersService
{
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet";
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=39";
    NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=39&ReferTo=ReferTo";
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
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            //dataArray = [[NSMutableArray alloc]init];
            //availService = [NSMutableDictionary dictionary];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                NSLog(@"loggedInuserId===%@  %@",loggedInuserId,[dict objectForKey:@"refered_to"]);
                
                if(![loggedInuserId isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"refered_to"]]])
                {
                    UIImage *uImage;
                    
                    NSLog(@"selectedMenu====%@",selectedMenu);
                    if (![selectedMenu isEqualToString:@"Helper"])
                    {
                        NSString *talentCounts = [NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]];
                        if(![talentCounts isEqualToString:@"0"])
                        {
                            [seekerArray addObject:[seekerObj newSeeker:[dict objectForKey:@"referedToName"] seekerId:[dict objectForKey:@"refered_to"] withImage:uImage rate:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] rateType:@""]];
                            
                        }
                        
                    }else
                    {
                        [seekerArray addObject:[seekerObj newSeeker:[dict objectForKey:@"referedToName"] seekerId:[dict objectForKey:@"refered_to"] withImage:uImage rate:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] rateType:@""]];
                        
                    }
                    
                    
                }
                //}
                
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
}

-(void) getUsersService
{
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet";
    NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=39";
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=39&ReferTo=ReferTo";
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
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            seekerArray = [[NSMutableArray alloc]init];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                NSLog(@"loggedInuserId===%@  %@",loggedInuserId,[dict objectForKey:@"refered_to"]);
                
                if(![loggedInuserId isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"refered_to"]]])
                {
                    
                    UIImage *uImage;
                    
                    NSLog(@"selectedMenu====%@",selectedMenu);
                    if (![selectedMenu isEqualToString:@"Helper"])
                    {
                        NSString *talentCounts = [NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]];
                        if(![talentCounts isEqualToString:@"0"])
                        {
                            [seekerArray addObject:[seekerObj newSeeker:[dict objectForKey:@"referedToName"] seekerId:[dict objectForKey:@"refered_to"] withImage:uImage rate:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] rateType:@""]];
                            
                        }
                        
                    }else
                    {
                        [seekerArray addObject:[seekerObj newSeeker:[dict objectForKey:@"referedToName"] seekerId:[dict objectForKey:@"refered_to"] withImage:uImage rate:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] rateType:@""]];
                        
                    }
                    
                    
                }
                //}
                
            }
            [self getReferToUsersService];
            
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
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger rowCount;
    if(self.isFiltered)
        rowCount = filteredseekerArray.count;
    else
        rowCount = seekerArray.count;
    
    return rowCount;
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredseekerArray count];
    }
    
    else
    {
        return [seekerArray count];
    }
     */
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CloudCell";
    HSTableViewCell *cell = (HSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[HSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    seekerObj *cloudToDisplay = nil;
    
    //if (tableView == self.searchDisplayController.searchResultsTableView)
    if(isFiltered)
    {
        cloudToDisplay = [filteredseekerArray objectAtIndex:indexPath.row];
    }
    else
    {
        cloudToDisplay = [seekerArray objectAtIndex:indexPath.row];
    }
    
    cell.name.text = cloudToDisplay.seekerName;
    
    
    //cell.imageView.image = Obj.imageFile;
//    cell.image.layer.borderWidth = 1.0f;
//    
//    cell.image.layer.borderColor = [UIColor blueColor].CGColor;
//    
//    cell.image.layer.cornerRadius = 10.0f; //cell.userImg.frame.size.width / 2;
//    cell.image.clipsToBounds = YES;
    
    [cell.ratingbtn setTitle:cloudToDisplay.rate forState:UIControlStateNormal];
    
    UIImage *movement = (cloudToDisplay.imageFile ? cloudToDisplay.imageFile : [UIImage imageNamed:@"MainBG.png"]);
    
  //  cell.image.image = movement; //[UIImage imageNamed:@"MainBG.png"];
    
    if([selectedTab isEqualToString:@"Helpers"] || [selectedTab isEqualToString:@"Seekers"])
    {
        //cell.image.alpha = 0;
        cell.ratingbtn.alpha = 1;
    }
    else
    {
        //cell.image.alpha = 1;
        cell.ratingbtn.alpha = 0;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    seekerObj *Obj = nil;
    
    //if (tableView == self.searchDisplayController.searchResultsTableView)
    if(isFiltered)
    {
        Obj = [filteredseekerArray objectAtIndex:indexPath.row];
    }
    else
    {
        Obj = [seekerArray objectAtIndex:indexPath.row];
    }
    
    
    if([selectedTab isEqualToString:@"Helpers"] || [selectedTab isEqualToString:@"Seekers"])
    {
        offObj.selectedTalentName = Obj.seekerName;
        offObj.selectedTalentId = Obj.seekerId;
        offObj.talentRate = Obj.rate;
        offObj.talentJobType = Obj.rateType;

    }else
    {
        offObj.selectedUserName = Obj.seekerName;
        offObj.selectedUserId = Obj.seekerId;
    }
    
    NSLog(@"offObj====%@",offObj);
    /*
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSString stringWithFormat:@"%@",Obj.seekerName] forKey:@"seekerName"];
    [dict setValue:[NSString stringWithFormat:@"%@",Obj.seekerId] forKey:@"seekerId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedSeeker" object: dict];
    
    [self.navigationController popViewControllerAnimated:YES];
    */
    [self performSegueWithIdentifier:@"transaction" sender:self];
    //
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"transaction"]) {
        
        
//        Offer_RequestViewCon* controller =[segue destinationViewController];
//        controller.offerObj = offObj;
//        NSLog(@"login===%@",controller);
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        
        filteredseekerArray = [[NSMutableArray alloc] init];
        
        for (seekerObj* obj in seekerArray)
        {
            NSRange nameRange = [obj.seekerName rangeOfString:text options:NSCaseInsensitiveSearch];
            //NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound )
            {
                [filteredseekerArray addObject:obj];
            }
        }
        
    }
    
    [custTableView reloadData];
}

@end
