//
//  MapHelperTalentViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 5/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "MapHelperTalentViewController.h"
#import "MBProgressHUD.h"
#import "MapHelper.h"
#import "Helper.h"
#import "SeekerReachOutController.h"
#import "selectedObject.h"
#import "offerHelpViewController.h"
#import "UserInfoObj.h"

#import "AsyncImageView.h"

@interface MapHelperTalentViewController ()
{
    NSMutableArray *categoryArray;
    NSMutableArray *categoryId;
    NSMutableArray *rateArray;
    NSMutableArray *jsonArray;
    NSMutableArray *descrArray;
    NSMutableDictionary *sendDictionary;
    NSMutableArray *totaCount;
    NSString *userID;
    NSMutableArray *locationsArray;
    NSMutableArray *dataArray;
    NSString *selectedUIDs;
    NSString *userType;
    NSString *sendHelperId;
    
    NSString *locationUserIds;
    
    NSMutableDictionary *locUserIdsDic;
}
@end

@implementation MapHelperTalentViewController
@synthesize mapView,tableView,helperId,talentId,ShowTalents,ShowSeekers,comingFromHelpersSegment,comingFromSeekersSegment,comingFromHelperTalentsSegment,comingFromSeekerTalentsSegment,helpWho,offerObj,helpWhoId,helperName;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    self.mapView.delegate = self;
    
    if (ShowTalents) {
         self.title=@"My Talents";
    }else if(helperId)
    {
        self.title=[NSString stringWithFormat:@"%@ - Talents",helperName];
        NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
        
        self.navigationController.navigationBar.titleTextAttributes = size;
    }
    else
    {
        self.title=[NSString stringWithFormat:@"Helpers"];
    }
   
    
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userID=[userInfoDic valueForKey:@"userId"];
   totaCount = [[NSMutableArray alloc] init];
    
    locationUserIds = [NSString stringWithFormat:@"%@,",userID];
    
    locUserIdsDic = [[NSMutableDictionary alloc]init];
    [locUserIdsDic setObject:[NSString stringWithFormat:@"%@",userID] forKey:[NSString stringWithFormat:@"%@",userID]];
    
    if (ShowSeekers) {
        self.title=@"Seekers";
        [self getUsersService];
        
        NSLog(@"%@",offerObj);
        
    }
    
    else{
        
        [self getMainCategories];
    }
    
    
    
    // Do any additional setup after loading the view.
}

-(void) getUserLocationsService
{
    NSLog(@"===locationUserIds====%@",locationUserIds);
    if(locationUserIds.length >0)
    {
        locationUserIds = [locationUserIds substringToIndex:[locationUserIds length]-1];
        locationUserIds = [NSString stringWithFormat:@"(%@)",locationUserIds];
    }
    
    NSLog(@"===locationUserIds=2222===%@",locationUserIds);
    
    //NSString *userIds = @"(39,41)";
    NSString *URL_LOGIN =  [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetLocationTalentWise?HelperMap=HelperMap&userid=%@",locationUserIds];
    //userID
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    NSLog(@"responseCode====%@",responseCode);
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray1 = [NSJSONSerialization
                                          JSONObjectWithData:respData
                                          options:NSJSONReadingMutableContainers
                                          error:&serializeError];
            
            locationsArray = [[NSMutableArray alloc]init];
            
            for (NSMutableDictionary *dict in jsonArray1)
            {
                NSLog(@"loggedInuserId===%@  %@",[dict objectForKey:@"userId"],[dict objectForKey:@"userName"]);
                
                    UIImage *uImage = [[UIImage alloc]init];
                    if([dict objectForKey:@"imageBase64"])
                    {
                        uImage = [self decodeBase64ToImage:[dict objectForKey:@"imageBase64"]];
                    }
                
                    [locationsArray addObject:[UserInfoObj newUser:[dict objectForKey:@"userName"] userId:[dict objectForKey:@"userId"] withImage:uImage latitude:[dict objectForKey:@"latitude"] longiture:[dict objectForKey:@"longitude"] distance:[dict objectForKey:@"distance"]] ];
                    
                
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

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(void)initConstraints
{
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    id views = @{
                 @"mapView": self.mapView
                 };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:views]];
}

-(void)addAllPins
{
    self.mapView.delegate=self;
    [self getUserLocationsService];
//    NSArray *name=[[NSArray alloc]initWithObjects: @"VelaCherry",@"Perungudi",@"Tharamani", nil];
//    
//    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:name.count];
//    
//    [arrCoordinateStr addObject:@"12.970760345459, 80.2190093994141"];
//    [arrCoordinateStr addObject:@"12.9752297537231, 80.2313079833984"];
//    [arrCoordinateStr addObject:@"12.9788103103638, 80.2412414550781"];
//    
//    for(int i = 0; i < name.count; i++)
//    {
//        [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i]];
//    }
    
    for(int i = 0; i < [locationsArray count]; i++)
    {
        UserInfoObj *obj = locationsArray[i];
        NSString *coordinates = [NSString stringWithFormat:@"%@, %@",obj.latitude,obj.longiture];
        [self addPinWithTitle:obj.userName AndCoordinate:coordinates];
    }
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    
    
    [self.mapView addAnnotation:mapPin];
}

-(void) getUsersService
{
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet";
    NSString *URL_LOGIN =  [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userID];
    
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
            NSMutableArray *jsonArray1 = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            dataArray = [[NSMutableArray alloc]init];
            //availService = [NSMutableDictionary dictionary];
            selectedUIDs = [[NSString alloc]init];
            
            for (NSMutableDictionary *dict in jsonArray1)
            {
                NSLog(@"dict===%@",dict);
                NSLog(@"loggedInuserId===%@  %@",userID,[dict objectForKey:@"refered_to"]);
                
                //                if(![userId isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"refered_to"]]])
                
                if(![userID isEqual:[dict objectForKey:@"refered_to"]])
                {
                    if([[dict objectForKey:@"status"] isEqualToString:@"Accepted"])
                    {
                        UIImage *uImage;
                        NSString *address;
                        NSLog(@"selectedMenu====%@",selectedUIDs);

                        NSString *tempString = [NSString stringWithFormat:@"%@,",[dict objectForKey:@"refered_to"]];
                        selectedUIDs = [selectedUIDs stringByAppendingString:tempString];
                        
                        [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"referedToName"] seekerId:[dict objectForKey:@"refered_to"] withImage:uImage rate:[dict objectForKey:@"talentCount"] details:address rateType:@""  talentName:@"" talentId:@"" talentsCount:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] imgUrl:[dict objectForKey:@"image"]] ];
                  
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
-(void) getReferToUsersService
{
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet";
    //NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=39";
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@&ReferTo=ReferTo",userID];
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
            
            //dataArray = [[NSMutableArray alloc]init];
            //availService = [NSMutableDictionary dictionary];
            
            for (NSMutableDictionary *dict in jsonArray1)
            {
                NSLog(@"dict===%@",dict);
                NSLog(@"loggedInuserId===%@  %@",userID,[dict objectForKey:@"refered_to"]);
                
                //                if(![userId isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"refered_to"]]])
                
                if(![userID isEqual:[dict objectForKey:@"introduced_By"]])
                {
                    
                    if([[dict objectForKey:@"status"] isEqualToString:@"Accepted"])
                    {
                        UIImage *uImage;
                        NSString *address;
                        NSString *tempString = [NSString stringWithFormat:@"%@,",[dict objectForKey:@"introduced_By"]];
                        selectedUIDs = [selectedUIDs stringByAppendingString:tempString];
                        
                        [dataArray addObject:[selectedObject newSeeker:[dict objectForKey:@"itroducedByName"] seekerId:[dict objectForKey:@"introduced_By"] withImage:uImage rate:[dict objectForKey:@"talentCount"] details:address rateType:@""  talentName:@"" talentId:@"" talentsCount:[NSString stringWithFormat:@"%@",[dict objectForKey:@"talentCount"]] imgUrl:[dict objectForKey:@"image"]] ];
                 
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getMainCategories{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        categoryArray = [NSMutableArray array];
        categoryId = [NSMutableArray array];
        rateArray = [NSMutableArray array];
         descrArray = [NSMutableArray array];
        
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSURL *url;
        NSLog(@"==talentId===%@",talentId);
        if (ShowTalents) {
              url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",userID]];
        }
        
       else if (![talentId isEqualToString:@""]) {
             url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentWise?talentId=%@",talentId]];
        }
        else {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",helperId]];
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
            //int i;
//            for (i=0; i<[jsonArray count]; i++) {
//                [categoryArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"categoryName"]];
//                [categoryId addObject:[[jsonArray objectAtIndex:i] valueForKey:@"talentName"]];
//                [rateArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"rate"]];
//                [descrArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"description"]];
//                
//                
//            }
            
            if (![talentId isEqualToString:@""]) {
                for (NSMutableDictionary *dict1 in jsonArray){
                    
                    NSLog(@"===dict1===%@",dict1);
                    
                    if(![locUserIdsDic objectForKey:[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"userId"]]])
                    {
                        NSString *tempStr = [NSString stringWithFormat:@"%@,",[dict1 objectForKey:@"userId"]];
                        NSLog(@"locationUserIds===%@  %@",locationUserIds,tempStr);
                        locationUserIds = [locationUserIds stringByAppendingString:tempStr];
                        [locUserIdsDic setObject:[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"userId"]] forKey:[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"userId"]]];
                    }
                    
                    
                    Helper *c = [[Helper alloc] init];
                    c.helperId = [dict1 objectForKey:@"userId"];
                    c.helperName = [dict1 objectForKey:@"userName"];
                    c.TalentName= [dict1 objectForKey:@"talentName"];
                    c.description = [dict1 objectForKey:@"description"];
                    c.CategoryName = [dict1 objectForKey:@"categoryName"];
                    c.rate= [NSString stringWithFormat:@"%@",[dict1 objectForKey:@"rate"]];
                    [totaCount addObject:c];
                }
            }
            else{
                
                for (NSMutableDictionary *dict1 in jsonArray){
                    
                    //locationUserIds = [locationUserIds stringByAppendingString:[NSString stringWithFormat:@"%@,",[dict1 objectForKey:@"userId"]]];
                    if(![locUserIdsDic objectForKey:[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"userId"]]])
                    {
                        NSString *tempStr = [NSString stringWithFormat:@"%@,",[dict1 objectForKey:@"userId"]];
                        NSLog(@"locationUserIds===%@  %@",locationUserIds,tempStr);
                        locationUserIds = [locationUserIds stringByAppendingString:tempStr];
                        [locUserIdsDic setObject:[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"userId"]] forKey:[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"userId"]]];
                    }
                    
                    Helper *c = [[Helper alloc] init];
                    c.helperId = [dict1 objectForKey:@"userId"];
                    c.helperName = [dict1 objectForKey:@"userName"];
                    c.UserTalentId= [dict1 objectForKey:@"userTalentId"];
                    c.TalentName= [dict1 objectForKey:@"talentName"];
                    c.description = [dict1 objectForKey:@"description"];
                    c.CategoryName = [dict1 objectForKey:@"categoryName"];
                    c.rate= [NSString stringWithFormat:@"%@",[dict1 objectForKey:@"rate"]];
                    [totaCount addObject:c];
                }
            }
           

            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self initConstraints];
                
                [self addAllPins];
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
     NSUInteger rowCount;
   
    if (ShowSeekers) {
        rowCount = dataArray.count;
    }
    else{
       
        rowCount=totaCount.count;
    
    }
    
    return rowCount;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MapHelper *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    #define IMAGE_VIEW_TAG 99
    
    if (ShowSeekers) {
         selectedObject *Obj = nil;
         Obj = [dataArray objectAtIndex:indexPath.row];
        
        cell.talentName.text = Obj.seekerName;
        //cell.whatImage.image= [UIImage imageNamed:@"SeekImage.png"];
        
        cell.whatImage.layer.borderColor = [UIColor grayColor].CGColor;
        cell.whatImage.layer.cornerRadius = 2;
        cell.whatImage.layer.borderWidth = 1;
        
        [cell.whatImage.image drawInRect:CGRectMake((cell.whatImage.frame.size.width/2) - (cell.whatImage.image.size.width/2), (cell.whatImage.frame.size.height/2) - (cell.whatImage.image.size.height/2), cell.whatImage.image.size.width, cell.whatImage.image.size.height)];
        
        
        cell.whatImage.tag = IMAGE_VIEW_TAG;
        cell.whatImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.whatImage.clipsToBounds = YES;
        
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
            cell.whatImage.imageURL = url; //[_imageURLs objectAtIndex:indexPath.row];
        }else{
            UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
            cell.whatImage.image = tempImage;
           
        }
        
    }
    

   else if (![talentId isEqualToString:@""]) {
        Helper *mam = (totaCount)[indexPath.row];
        
        cell.talentName.text= [NSString stringWithFormat:@"%@",mam.helperName];
        cell.rate.text= [NSString stringWithFormat:@"%@",mam.rate];
        cell.whatImage.image= [UIImage imageNamed:@"SeekImage.png"];

    }
    
    else{
   Helper *mam = (totaCount)[indexPath.row];
    
    cell.talentName.text= [NSString stringWithFormat:@"%@-%@",mam.CategoryName,mam.TalentName];
    
    cell.snippetLabel.text= [NSString stringWithFormat:@"%@",mam.description];
    
    cell.rate.text= [NSString stringWithFormat:@"%s%@","$",mam.rate];
    cell.whatImage.image= [UIImage imageNamed:@"talents.png"];
    
       }
    
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"MapTableRow.png"]];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string = @"";
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    
    if ([userType isEqualToString:@"Helper"]){
    
      
        
        
        if (comingFromSeekersSegment) {
            
            Helper *helpererm = (totaCount)[indexPath.row];
            // sendArray= [self getInflowId:helpererm.helperId];
            
            NSLog(@"%@",helpererm.helperId);
            NSLog(@"%@",helpererm.helperName);
            
            
            
            sendDictionary = [[NSMutableDictionary alloc] init];
            //[sendDictionary setValue:helpererm.helperId forKey:@"HelperId"];
            
             [sendDictionary setObject:helpWho forKey:@"SelectedSeekerName"];
            
            [sendDictionary setObject:helpWhoId forKey:@"SelectedSeekerId"];
            
            [sendDictionary setObject:helpererm.helperId forKey:@"HelperId"];
            
            [sendDictionary setValue:helpererm.helperName forKey:@"HelperName"];
            [sendDictionary setValue:helpererm.UserTalentId forKey:@"UserTalentId"];
            
            //[sendDictionary setObject:[categoryId objectAtIndex:indexPath.row]];
            
            // [sendDictionary setValue:talentTxtField.text forKey:@"TalentName"];
            NSString *categoryTalent= [NSString stringWithFormat:@"%@-%@",helpererm.CategoryName,helpererm.TalentName];
            [sendDictionary setObject:categoryTalent forKey:@"TalentName"];
            
            [sendDictionary setObject:helpererm.rate forKey:@"rate"];
            NSLog(@"%@",sendDictionary);
            
        }
        
        else{
            
            selectedObject *Obj = nil;
            Obj = [dataArray objectAtIndex:indexPath.row];
            
            sendHelperId= Obj.seekerName;
            offerObj.selectedUserName= Obj.seekerName;
            offerObj.selectedUserId= Obj.seekerId;
        
        
        }
    
    
    
    }
    
    else{
    Helper *helpererm = (totaCount)[indexPath.row];
    // sendArray= [self getInflowId:helpererm.helperId];
    
    NSLog(@"%@",helpererm.helperId);
    NSLog(@"%@",helpererm.helperName);
    
    
    
    sendDictionary = [[NSMutableDictionary alloc] init];
    //[sendDictionary setValue:helpererm.helperId forKey:@"HelperId"];
    
    [sendDictionary setObject:helpererm.helperId forKey:@"HelperId"];
    
     [sendDictionary setValue:helpererm.helperName forKey:@"HelperName"];
        
        [sendDictionary setValue:helpererm.UserTalentId forKey:@"UserTalentId"];
     
    //[sendDictionary setObject:[categoryId objectAtIndex:indexPath.row]];
    
    // [sendDictionary setValue:talentTxtField.text forKey:@"TalentName"];
    NSString *categoryTalent= [NSString stringWithFormat:@"%@-%@",helpererm.CategoryName,helpererm.TalentName];
    [sendDictionary setObject:helpererm.TalentName forKey:@"TalentName"];
        
    [sendDictionary setObject:categoryTalent forKey:@"CategoryTalent"];
    
     [sendDictionary setObject:helpererm.rate forKey:@"rate"];
    // NSMutableArray *array= [self getInflowId:helperTransactionId];
        
        
    }
    
    if ([userType isEqualToString:@"Helper"]) {
         [self performSegueWithIdentifier:@"offerHelp" sender:self];
    }
    else{
        
    [self performSegueWithIdentifier:@"MapReachOut" sender:self];
        
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    
    if ([segue.identifier isEqualToString:@"MapReachOut"]) {
        
        SeekerReachOutController *detail= [segue destinationViewController];
        NSLog(@"%@",sendDictionary);
        detail.sendDictionary=sendDictionary;
    }
    else if ([segue.identifier isEqualToString:@"offerHelp"]){
    
        offerHelpViewController *navigationController = segue.destinationViewController;
//        offerHelpViewController *showItemsTVC = (offerHelpViewController * )navigationController.topViewController;
        
        navigationController.ReceivedDictionary=sendDictionary;
        navigationController.getHelperId=sendHelperId;
        if (comingFromSeekerTalentsSegment) {
            
            navigationController.offObject=offerObj;
            
        }
        
        
    }
    
}

@end
