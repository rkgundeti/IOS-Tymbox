//
//  Offer-Seeker-ViewCon.m
//  TymBox030915
//
//  Created by Rama Krishna.G on 04/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "Offer-Seeker-ViewCon.h"
#import "selectedObject.h"
#import "HSTableViewCell.h"

#import "Talents-User-ViewCon.h"

#import "OfferObject.h"
#import "MapHelperTalentViewController.h"
#import "MyTalentsViewController.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"

#import "AsyncImageView.h"

@interface Offer_Seeker_ViewCon ()
{
    NSString *selectedSegment;
    
    NSString *selectedName;
    NSString *selectedId;
    NSString *selectedTab;
    NSString *userId;
    NSString *loggedInuserName;
    NSString *selectedMenu;
    NSString *selectedUIDs;
    OfferObject *offerObj;
    NSString *sendSelectedTalentID;
    NSString *helpWho;
    MBProgressHUD *HUD;
}
@end

@implementation Offer_Seeker_ViewCon

@synthesize tableview,dataArray,filteredDataArray,searchbar,seekerTalentSegment;
@synthesize selectedMenu,helperTalentSegment,comingFromMenu;
@synthesize isFiltered;

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
    
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
    
    
    if (comingFromMenu) {
        SWRevealViewController *reveal = self.revealViewController;
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:reveal action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = barBtn;
    }
    
    selectedSegment= [NSString stringWithFormat:@"%@",[helperTalentSegment titleForSegmentAtIndex:0]];
//    loggedInuserName = [defaults stringForKey:@"userName"];
    
    selectedMenu = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    searchbar.delegate = (id)self;
    
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"footer-portrait.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Background_portrait.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //UIImage *headerImg = [UIImage imageNamed:@"greenBackimg.png"];
    
    //UIGraphicsBeginImageContext(headerVies.frame.size);
    //[[UIImage imageNamed:@"greenBackimg.png"] drawInRect:headerVies.bounds];
    //UIImage *headerImg = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
    
    //headerVies.backgroundColor = [UIColor colorWithPatternImage:headerImg];
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"<" forState:UIControlStateNormal];
//    [btn setFrame:CGRectMake(0, 0, 40, 30)];
//    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    
//    [self.navigationItem setLeftBarButtonItem:eng_btn];
    
    if([selectedMenu isEqualToString:@"Helper"])
    {
        
        selectedSegment = [NSString stringWithFormat:@"%@",[helperTalentSegment titleForSegmentAtIndex:0]];
        self.title=@"Offer Help";
        helperTalentSegment.alpha = 1;
        seekerTalentSegment.alpha = 0;
        
       
        NSLog(@"helperTalentSegment====%ld",(long)[helperTalentSegment selectedSegmentIndex]);
        if(helperTalentSegment.selectedSegmentIndex == 0)
        {
            selectedSegment = [NSString stringWithFormat:@"%@",[helperTalentSegment titleForSegmentAtIndex:0]];
            [self getUsersService];
            
        }
        else if(helperTalentSegment.selectedSegmentIndex == 1)
        {
            selectedSegment = [NSString stringWithFormat:@"%@",[helperTalentSegment titleForSegmentAtIndex:1]];
            [self checkWebService];
            
        }
        
    }else if([selectedMenu isEqualToString:@"Seeker"])
    {
        selectedSegment = [NSString stringWithFormat:@"%@",[seekerTalentSegment titleForSegmentAtIndex:0]];
        self.title=@"Seek Help";
        helperTalentSegment.alpha = 0;
        seekerTalentSegment.alpha = 1;
        
         NSLog(@"seekerTalentSegment====%ld",(long)[seekerTalentSegment selectedSegmentIndex]);
        if(seekerTalentSegment.selectedSegmentIndex == 0)
        {
            selectedSegment = [NSString stringWithFormat:@"%@",[seekerTalentSegment titleForSegmentAtIndex:0]];
            [self getUsersService];
            
        }
        else if(seekerTalentSegment.selectedSegmentIndex == 1)
        {
            selectedSegment = [NSString stringWithFormat:@"%@",[seekerTalentSegment titleForSegmentAtIndex:1]];
            [self checkWebService];
            
        }else if (seekerTalentSegment.selectedSegmentIndex == 2)
        {
            selectedSegment = [NSString stringWithFormat:@"%@",[seekerTalentSegment titleForSegmentAtIndex:1]];
            
        }
    }
    
    
  
    
    
    //[self getUsersService];
    
    NSLog(@"selectedUIDs===%@",selectedUIDs);
    /*
    selectedUIDs = [selectedUIDs substringToIndex:[selectedUIDs length] - 1];
    
    selectedUIDs = [NSString stringWithFormat:@"%@",selectedUIDs];
    
    NSLog(@"selectedUIDs===%@",selectedUIDs);
    */

    NSLog(@"count==%d",(int)[dataArray count]);
    filteredDataArray = [NSMutableArray arrayWithCapacity:[dataArray count]];    
    // Reload the table

    [tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([selectedMenu isEqualToString:@"Helper"])
    {
        
         self.title=@"Seek Help";
    }
    
    else{
    self.title=@"Offer Help";
    }
   
    // Do any additional setup after loading the view.
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) checkWebService {
    
    //NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",loggedInuserId];
    NSString *URL_LOGIN = [[NSString alloc]init];
    
    if([selectedMenu isEqualToString:@"Helper"])
    {
        URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",userId];
    }else if([selectedMenu isEqualToString:@"Seeker"])
    {
        URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetTalentHelperWise?userId=(%@)",selectedUIDs];
    }
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
            
            dataArray = [[NSMutableArray alloc]init];
//            if (dataArray.count==0) {
//                
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@"Tymbox"
//                                              message:@"You don't have talents"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//                
//                              UIAlertAction* ok = [UIAlertAction
//                                     actionWithTitle:@"Add Talent"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction * action)
//                                     {
//                                          [self performSegueWithIdentifier:@"addTalentfromOH" sender:self];
//                                         
//                                     }];
//                
//                [alert addAction:ok];
//            
//                
//                [self presentViewController:alert animated:YES completion:nil];
//                
//               
//            }
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                
                NSString *address =[NSString stringWithFormat:@"%@",[dict objectForKey:@"categoryName"]];
                
                UIImage *uImage;
                
                if([selectedMenu isEqualToString:@"Helper"])
                {
                    [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"talentName"] seekerId:[dict objectForKey:@"talentId"] withImage:uImage rate:[dict objectForKey:@"rate"] details:address rateType:[dict objectForKey:@"rateType"] talentName:[dict objectForKey:@"talentName"] talentId:[dict objectForKey:@"talentId"] talentsCount:[dict objectForKey:@"rate"] imgUrl:[dict objectForKey:@"image"]]];
                    
                }else if([selectedMenu isEqualToString:@"Seeker"])
                {
                    [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"talentName"] seekerId:[dict objectForKey:@"talentId"] withImage:uImage rate:[dict objectForKey:@"rate"] details:address rateType:[dict objectForKey:@"rateType"] talentName:[dict objectForKey:@"talentName"] talentId:[dict objectForKey:@"talentId"] talentsCount:[dict objectForKey:@"userCount"] imgUrl:[dict objectForKey:@"image"]]];
                
                }
                
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

-(void) getReferToUsersService
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
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            //dataArray = [[NSMutableArray alloc]init];
            //availService = [NSMutableDictionary dictionary];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                NSLog(@"loggedInuserId===%@  %@",userId,[dict objectForKey:@"refered_to"]);
                
//                if(![userId isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"refered_to"]]])
                
                     if(![userId isEqual:[dict objectForKey:@"introduced_By"]])
                {
                    
                    UIImage *uImage;
                    NSString *address;
                    
                    
                    NSLog(@"selectedMenu====%@",selectedMenu);
                    if (![selectedMenu isEqualToString:@"Helper"])
                    {
                        if ([[dict objectForKey:@"status"] isEqualToString:@"Accepted"])
                        {
                            
                            NSString *talentCounts = [NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]];
                            if(![talentCounts isEqualToString:@"0"])
                            {
                                NSString *tempString = [NSString stringWithFormat:@"%@,",[dict objectForKey:@"introduced_By"]];
                                selectedUIDs = [selectedUIDs stringByAppendingString:tempString];
                            
                                [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"itroducedByName"] seekerId:[dict objectForKey:@"introduced_By"] withImage:uImage rate:[dict objectForKey:@"talentCount"] details:address rateType:@""  talentName:@"" talentId:@"" talentsCount:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] imgUrl:[dict objectForKey:@"image"]] ];
                            }
                        }
                    }else
                    {
                        if ([[dict objectForKey:@"status"] isEqualToString:@"Accepted"])
                        {
                            NSString *tempString = [NSString stringWithFormat:@"%@,",[dict objectForKey:@"introduced_By"]];
                            selectedUIDs = [selectedUIDs stringByAppendingString:tempString];
                        
                            [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"itroducedByName"] seekerId:[dict objectForKey:@"introduced_By"] withImage:uImage rate:[dict objectForKey:@"talentCount"] details:address rateType:@""  talentName:@"" talentId:@"" talentsCount:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] imgUrl:[dict objectForKey:@"image"]] ];
                        }
                    }
                    
                    
                }
                //}
                
            }
            NSLog(@"selectedUIDs===%@",selectedUIDs);
            if (!selectedUIDs.length==0) {
                selectedUIDs = [selectedUIDs substringToIndex:[selectedUIDs length] - 1];
                
                selectedUIDs = [NSString stringWithFormat:@"%@",selectedUIDs];
                
                NSLog(@"selectedUIDs===%@",selectedUIDs);
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
    
   
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet";
            NSString *URL_LOGIN =  [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId];
            
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
                    
                    dataArray = [[NSMutableArray alloc]init];
                    //availService = [NSMutableDictionary dictionary];
                    selectedUIDs = [[NSString alloc]init];
                    
                    for (NSMutableDictionary *dict in jsonArray)
                    {
                        NSLog(@"dict===%@",dict);
                        NSLog(@"loggedInuserId===%@  %@",userId,[dict objectForKey:@"refered_to"]);
                        
                        //                if(![userId isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"refered_to"]]])
                        
                        if(![userId isEqual:[dict objectForKey:@"refered_to"]])
                        {
                            
                           
                            UIImage *uImage;
                            NSString *address;
                            
                            
                            NSLog(@"selectedMenu====%@",selectedMenu);
                            if (![selectedMenu isEqualToString:@"Helper"])
                            {
                                NSString *talentCounts = [NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]];
                                if(![talentCounts isEqualToString:@"0"])
                                {
                                    if ([[dict objectForKey:@"status"] isEqualToString:@"Accepted"]) {
                                        NSString *tempString = [NSString stringWithFormat:@"%@,",[dict objectForKey:@"refered_to"]];
                                        selectedUIDs = [selectedUIDs stringByAppendingString:tempString];
                                        
                                        [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"referedToName"] seekerId:[dict objectForKey:@"refered_to"] withImage:uImage rate:[dict objectForKey:@"talentCount"] details:address rateType:@""  talentName:@"" talentId:@"" talentsCount:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] imgUrl:[dict objectForKey:@"image"]] ];
                                    }
                                    
                                }
                                
                            }else
                            {
                                //selectedUIDs = [NSString]
                                
                                if ([[dict objectForKey:@"status"] isEqualToString:@"Accepted"]) {
                                    NSString *tempString = [NSString stringWithFormat:@"%@,",[dict objectForKey:@"refered_to"]];
                                    selectedUIDs = [selectedUIDs stringByAppendingString:tempString];
                                    
                                    [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"referedToName"] seekerId:[dict objectForKey:@"refered_to"] withImage:uImage rate:[dict objectForKey:@"talentCount"] details:address rateType:@""  talentName:@"" talentId:@"" talentsCount:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] imgUrl:[dict objectForKey:@"image"]] ];
                                    
                                }
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
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableview reloadData];
            });
        });

    
    
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
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
        
        filteredDataArray = [[NSMutableArray alloc] init];
        
        for (selectedObject* obj in dataArray)
        {
            NSRange nameRange = [obj.seekerName rangeOfString:text options:NSCaseInsensitiveSearch];
            //NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound )
            {
                [filteredDataArray addObject:obj];
            }
        }
        /*
        NSPredicate *predicate;
        
        if([selectedSegment isEqualToString:@"Helpers"] || [selectedSegment isEqualToString:@"Seekers"])
        {
            predicate = [NSPredicate predicateWithFormat:@"SELF.seekerName contains[c] %@",text];
            
        }else if([selectedSegment isEqualToString:@"Talents"])
        {
            predicate = [NSPredicate predicateWithFormat:@"SELF.talentName contains[c] %@",text];
            
        }
        NSLog(@"predicate====%@",predicate);
        
        NSArray *tempArray = [dataArray filteredArrayUsingPredicate:predicate];
        
        filteredDataArray = [NSMutableArray arrayWithArray:tempArray];
        */
    }
    
    [tableview reloadData];
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    
    NSUInteger rowCount;
    if(self.isFiltered)
        rowCount = filteredDataArray.count;
    else
        rowCount = dataArray.count;
    
    return rowCount;
    /*
    NSLog(@"count====%lu",(unsigned long)[dataArray count]);
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredDataArray count];
    }
    else
    {
        return [dataArray count];
    }
    */
    //return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    #define IMAGE_VIEW_TAG 99
    
    static NSString *CellIdentifier = @"CloudCell";
    HSTableViewCell *cell = (HSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[HSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    selectedObject *Obj = nil;
    
    //if (tableView == self.searchDisplayController.searchResultsTableView)
    if(isFiltered)
    {
        Obj = [filteredDataArray objectAtIndex:indexPath.row];
    }
    else
    {
        Obj = [dataArray objectAtIndex:indexPath.row];
    }
    
    //cell.textLabel.text = cloudToDisplay.seekerName;
    
    NSLog(@"%@,  %@,   %@",Obj.seekerName,Obj.seekerId,Obj.rate);
    NSLog(@"selectedSegment===%@",selectedSegment);
    if([selectedSegment isEqualToString:@"Helpers"] || [selectedSegment isEqualToString:@"Seekers"])
    {
        cell.name.text = Obj.seekerName;
       // cell.image.alpha = 1;
        if([selectedSegment isEqualToString:@"Helpers"])
        {
            cell.ratingbtn.alpha = 1;
        }else
        {
            cell.ratingbtn.alpha = 0;
        }
        
        cell.image.image= [UIImage imageNamed:@"Placeholder.png"];
//        
        cell.image.tag = IMAGE_VIEW_TAG;
        cell.image.contentMode = UIViewContentModeScaleAspectFit;
        cell.image.clipsToBounds = YES;
        
        /*=-=============== to load image asyncronusly ===========*/
        
        //get image view
        AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
        
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        
        NSLog(@"=====%@",Obj.imgUrl);
        if(Obj.imgUrl !=nil && ![Obj.imgUrl isEqual:[NSNull null]] && ![Obj.imgUrl isEqualToString:@""])
        {
            NSString* encodedUrl = [Obj.imgUrl stringByAddingPercentEscapesUsingEncoding:
                                    NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:encodedUrl];
            //load the image
            cell.image.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
        }else{
            UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
            cell.image.image = tempImage;
            
        }
        //load the image
        //cell.imageView.imageURL =  [_imageURLs objectAtIndex:indexPath.row];
        
        /*=-=============== to load image asyncronusly ===========*/
        
    }else if([selectedSegment isEqualToString:@"Talents"])
    {
        cell.name.text = Obj.talentName;
      //  cell.image.alpha = 0;
        cell.ratingbtn.alpha = 1;
        cell.image.image= [UIImage imageNamed:@"talents.png"];
        cell.image.contentMode = UIViewContentModeScaleAspectFit;
        cell.image.clipsToBounds = YES;
        
    }
    
    
    //cell.valueLbl.text = [NSString stringWithFormat:@"%@",Obj.rate];
    
    //cell.valueLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackButton.png"]];
    
    [cell.ratingbtn setTitle:[NSString stringWithFormat:@"%@",Obj.talentsCount] forState:UIControlStateNormal];

   
    
//    cell.image.image = Obj.imageFile;     //[UIImage imageNamed:@"SeekImage.png"];//
//    cell.image.layer.borderWidth = 1.0f;
//    
//    cell.image.layer.borderColor = [UIColor grayColor].CGColor;
//    
//    cell.image.layer.cornerRadius = 10.0f; //cell.userImg.frame.size.width / 2;
//    cell.image.clipsToBounds = YES;
    
    
    
    //cell.detailsLbl.text = Obj.details;
    
    //cell.detailsLbl.alpha = 0;
    //cell.imageView.image = [UIImage imageNamed:@"MainBG.png"];
   // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string;
    
    if([selectedMenu isEqualToString:@"Helper"])
    {
        
        if (helperTalentSegment.selectedSegmentIndex==0) {
            string = @"People I know";
        }
        else{
            string = @"My Talents";
            
        }
    }
    else{
    if (seekerTalentSegment.selectedSegmentIndex==0) {
         string = @"People I know                         Talents they have";
    }
    else{
        string = @"Helper Talents                         People I know";

    
    }
    }
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectedObject *Obj = nil;
    
    //if (tableView == self.searchDisplayController.searchResultsTableView)
    if(isFiltered)
    {
        Obj = [filteredDataArray objectAtIndex:indexPath.row];
    }
    else
    {
        Obj = [dataArray objectAtIndex:indexPath.row];
    }
    
    selectedName = Obj.seekerName;
    selectedId = Obj.seekerId;
    
    NSLog(@"selectedSegment====%@",selectedSegment);
    
    //
    
    offerObj = [[OfferObject alloc]init];
    
    sendSelectedTalentID = [NSString new];
    
    if([selectedSegment isEqualToString:@"Helpers"] || [selectedSegment isEqualToString:@"Seekers"])
    {
        offerObj.selectedUserName = selectedName;
        offerObj.selectedUserId = selectedId;
        
    }else if([selectedSegment isEqualToString:@"Talents"])
    {
        offerObj.selectedTalentName = selectedName;
        offerObj.selectedTalentId = selectedId;
        offerObj.talentRate = Obj.rate;
        offerObj.talentJobType = Obj.rateType;
        
        sendSelectedTalentID= Obj.talentId;
        
    }
    [self performSegueWithIdentifier:@"SelectedHelperTalents" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"user-Talents"]) {
        /*
        //Talents_UserTVCon* controller =[segue destinationViewController];
        Talents_User_ViewCon* controller =[segue destinationViewController];
        //controller.actionType = @"User-Avail-Selection";
        controller.selectedName = selectedName;
        controller.selectedId = selectedId;
        controller.selectedTab = selectedSegment;
        controller.offerObj = offerObj;
        NSLog(@"login===%@",controller);
         */
    }
    
    else if ([segue.identifier isEqualToString:@"SelectedHelperTalents"]) {
        
        if([selectedMenu isEqualToString:@"Helper"])
        {
            
            if ([selectedSegment isEqualToString:@"Talents"]) {
                MapHelperTalentViewController *vc = segue.destinationViewController;
                vc.comingFromSeekerTalentsSegment=YES;
                vc.ShowSeekers=YES;
                vc.offerObj=offerObj;
                vc.talentId=[NSString stringWithFormat:@"%@",sendSelectedTalentID];
            }
            else{
                MapHelperTalentViewController *vc = segue.destinationViewController;
                vc.ShowTalents=YES;
                vc.comingFromSeekersSegment=YES;
                vc.helpWho=selectedName;
                vc.helpWhoId=selectedId;
                vc.talentId=[NSString stringWithFormat:@"%@",sendSelectedTalentID];
            }

        }
        else{
            MapHelperTalentViewController *vc = segue.destinationViewController;
            if ([selectedSegment isEqualToString:@"Talents"]) {
                //vc.helperId = selectedId;
                vc.talentId=[NSString stringWithFormat:@"%@",sendSelectedTalentID];
                vc.helperName = selectedName;
                
            }else
            {
                vc.helperId = selectedId;
                vc.talentId=[NSString stringWithFormat:@"%@",sendSelectedTalentID];
                vc.helperName = selectedName;
            }
        }
    
    }
    else if([segue.identifier isEqualToString:@"addTalentfromOH"])
    {
        MyTalentsViewController *destViewController = segue.destinationViewController;
        //destViewController.update=YES;
        destViewController.comingFromOfferHelp = YES;
    }
}

- (IBAction)seekerTalentSegAction:(id)sender {
    
    if(seekerTalentSegment.selectedSegmentIndex == 0)
    {
        //self.view.backgroundColor = [UIColor redColor];
        selectedSegment = [NSString stringWithFormat:@"%@",[seekerTalentSegment titleForSegmentAtIndex:0]];
        [self getUsersService];
        [self.tableview reloadData];
        
    }
    else if(seekerTalentSegment.selectedSegmentIndex == 1)
    {
        //self.view.backgroundColor = [UIColor greenColor];
        selectedSegment = [NSString stringWithFormat:@"%@",[seekerTalentSegment titleForSegmentAtIndex:1]];
        
        [self checkWebService];
        [self.tableview reloadData];
        
        //[self getUsersService];
        
    }else if (seekerTalentSegment.selectedSegmentIndex == 2)
    {
        selectedSegment = [NSString stringWithFormat:@"%@",[seekerTalentSegment titleForSegmentAtIndex:1]];
        
        //[self checkWebService];
        
    }
    NSLog(@"count=2222=%d",(int)[dataArray count]);
    filteredDataArray = [NSMutableArray arrayWithCapacity:[dataArray count]];
    
    // Reload the table
    [tableview reloadData];
}

- (IBAction)helperTalentSegAction:(id)sender {
    
    if(helperTalentSegment.selectedSegmentIndex == 0)
    {
        //self.view.backgroundColor = [UIColor redColor];
        selectedSegment = [NSString stringWithFormat:@"%@",[helperTalentSegment titleForSegmentAtIndex:0]];
        [self getUsersService];
        
    }
    else if(helperTalentSegment.selectedSegmentIndex == 1)
    {
        //self.view.backgroundColor = [UIColor greenColor];
        selectedSegment = [NSString stringWithFormat:@"%@",[helperTalentSegment titleForSegmentAtIndex:1]];
        
        [self checkWebService];
        
        //[self getUsersService];
        
    }
    NSLog(@"count==%d",(int)[dataArray count]);
    filteredDataArray = [NSMutableArray arrayWithCapacity:[dataArray count]];
    
    // Reload the table
    [tableview reloadData];
    
}
@end
