//
//  UserAvailTableVCon.m
//  TymBox030915
//
//  Created by Bhagavan on 3/9/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "UserAvailTableVCon.h"
#import "UserAvailableObj.h"
#import "UserAvailableTVController.h"
#import <objc/runtime.h>
#import "SWRevealViewController.h"

@interface UserAvailTableVCon ()
{
    NSMutableArray *userAvailibities;
    NSMutableArray *userAvailservice;
    NSMutableDictionary *availService;
    //int indexCount;
    NSString *loggedInuserId;
}
@end

@implementation UserAvailTableVCon

@synthesize colorsTable,actionType,selectedHelperId,nomatchesView;
@synthesize activityView,loadingView,loadingLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    loggedInuserId = [defaults stringForKey:@"user_id"];
    
    //NSDate *currentDate = [NSDate date];
    
    NSLog(@"actionType====%@====   %@", actionType,selectedHelperId);
    
    
    NSLog(@"userAvailservice====%@",userAvailservice);
    
    NSLog(@"availService====%@",[availService allKeys]);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (![actionType isEqualToString:@"User-Avail-Selection"]) {
//        
//        [btn setFrame:CGRectMake(0, 0, 20, 20)];
//        [btn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
//        selectedHelperId = loggedInuserId;
//        //
//    }else
//    {
//        [btn setFrame:CGRectMake(0, 0, 40, 30)];
//        [btn setBackgroundImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
//        [btn setTitle:@"<" forState:UIControlStateNormal];
//        
//    }
//    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    
//    [self.navigationItem setLeftBarButtonItem:eng_btn];
    
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(65, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    loadingLabel.text = @"Loading...";
    [loadingView addSubview:loadingLabel];
    
    [self.view addSubview:loadingView];
    [activityView startAnimating];
    
    
    [self getUserAvailabilityService];
    
    userAvailibities = [[NSMutableArray alloc] init];
    
    if (![actionType isEqualToString:@"User-Avail-Selection"]) {
        for (int i=0; i<=30; i++) {
            
            // add 30 days to it (in seconds)
            //currentDate = [currentDate dateByAddingTimeInterval:(i * 24 * 60 * 60)];
            NSDate *now = [NSDate date];
            NSDate *nextDate = [now dateByAddingTimeInterval:(i * 24 * 60 * 60)];
            
            
            NSLog(@"nextDate==for===%@", nextDate);
            
            //NSString *myString = [NSString stringWithFormat:@"%@",currentDate];;
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            //dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *yourDate = nextDate;
            dateFormatter.dateFormat = @"MM-dd-yyyy";
            NSString *dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
            NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
            
            NSDateFormatter* dateFormatterComp = [[NSDateFormatter alloc] init];
            dateFormatterComp.dateFormat = @"yyyy-MM-dd";
            NSString *compareDate = [NSString stringWithFormat:@"%@",[dateFormatterComp stringFromDate:yourDate]];
            
            //NSDate *now = [NSDate date];
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"EEEE"];
            NSLog(@"====%@",[dateFormatter1 stringFromDate:nextDate]);
            
            NSLog(@"dateStr====%@",dateStr);
            NSLog(@"compareDate====%@",compareDate);
            
            UserAvailableObj *availData = [availService objectForKey:compareDate];
            
            NSLog(@"service==%@    %@",availData.Morning,loggedInuserId);
            
            UserAvailableObj *c = [[UserAvailableObj alloc] init];
            c.UID = loggedInuserId;
            c.Date = dateStr;
            c.Day = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:nextDate]];
            if (availData != nil)
            {
                c.Morning = availData.Morning;
                c.Afternoon = availData.Afternoon;
                c.Evening = availData.Evening;
                c.actionType = @"Upsert";
            }else
            {
                c.Morning = @"Not";
                c.Afternoon = @"Not";
                c.Evening = @"Not";
                c.actionType = @"Insert";
            }
            
            
            [userAvailibities addObject:c];
            
            NSLog(@"c====%@",c.Date);
        }
    }else{
        
        userAvailibities = userAvailservice;
        
    }
    
    nomatchesView = [[UIView alloc] initWithFrame:self.view.frame];
    nomatchesView.backgroundColor = [UIColor clearColor];
    
    UILabel *matchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,320)];
    matchesLabel.font = [UIFont boldSystemFontOfSize:18];
    //matchesLabel.minimumFontSize = 12.0f;
    matchesLabel.numberOfLines = 1;
    //matchesLabel.lineBreakMode = UILineBreakModeWordWrap;
    matchesLabel.shadowColor = [UIColor lightTextColor];
    matchesLabel.textColor = [UIColor darkGrayColor];
    matchesLabel.shadowOffset = CGSizeMake(0, 1);
    matchesLabel.backgroundColor = [UIColor clearColor];
    matchesLabel.textAlignment =  NSTextAlignmentCenter;
    [matchesLabel setTextColor:[UIColor redColor]];
    
    
    //Here is the text for when there are no results
    matchesLabel.text = @"No Availabilities Found";
    
    
    nomatchesView.hidden = YES;
    [nomatchesView addSubview:matchesLabel];
    [self.colorsTable insertSubview:nomatchesView belowSubview:self.colorsTable];
    
    // [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    [activityView stopAnimating];
    [loadingView removeFromSuperview];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *reveal = self.revealViewController;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:reveal action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    if (![actionType isEqualToString:@"User-Avail-Selection"]) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"Save" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, 0, 40, 30)];
        [btn.titleLabel setFont: [UIFont boldSystemFontOfSize:11]];
        btn.titleLabel.adjustsFontSizeToFitWidth = TRUE;
        //btn.titleLabel.minimumFontSize = 11;
        [btn addTarget:self action:@selector(UpdateAvailability:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"button_normal.png"] forState:UIControlStateNormal];
        UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        self.navigationItem.rightBarButtonItem = eng_btn;
        
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_portrait.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    //[tempImageView release];
    
    
    self.navigationItem.title = @"User Availibility";
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"footer-portrait.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.title=@"User Availibility";
    
    
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Assign our own backgroud for the view
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
}

- (IBAction)back:(id)sender
{
    if (![actionType isEqualToString:@"User-Avail-Selection"]) {
        
        
            }else
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}


//Add this utility method in your class.
- (NSDictionary *) getObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(void) getUserAvailabilityService
{
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserAvailabilityServlet?userid=%@",selectedHelperId];
    
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
            
            userAvailservice = [[NSMutableArray alloc]init];
            availService = [NSMutableDictionary dictionary];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                
                
                UserAvailableObj *c = [[UserAvailableObj alloc] init];
                c.UID = [dict objectForKey:@"UID"];
                c.Day = [dict objectForKey:@"Day"];
                c.Date = [dict objectForKey:@"Date"];
                c.Morning = [dict objectForKey:@"Morning"];
                c.Afternoon = [dict objectForKey:@"Afternoon"];
                c.Evening = [dict objectForKey:@"Evening"];
                
                [userAvailservice addObject:c];
                
                [availService setObject:c forKey:[dict objectForKey:@"Date"]];
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

- (void) checkWebService:(NSString *)strBody {
    
    NSString *serviceString;
    NSString *strdata = strBody;
    
    serviceString=@"http://hyd.vertexcs.com:8081/TymBoxWeb/NewUserAvailabilityServlet";
    //http://192.168.2.42:8080/TymBoxWeb/GetUserAvailabilityServlet?userid=1
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *requestData = [strdata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *escapedUrlString = [serviceString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:escapedUrlString];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody: requestData];
    [theRequest setHTTPMethod:@"POST"];
    
    NSString *msg;
    msg=@"User Availability Updated";
    
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    if (!responseData)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        
    }
    NSDictionary *jsonDictionary;
    jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if (jsonDictionary == nil) {
        NSLog(@"JSON Error: %@", error);
    }
    
    if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"success"]) {
        
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }else if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"fail"]) {
        
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Problem with Server" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }
    
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    //if(alert.tag == 1)
    //{
    if(buttonIndex == alert.cancelButtonIndex)
    {
        NSLog(@"cancel");
        // [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"ok");
        //[self.navigationController popViewControllerAnimated:YES];
        
    }
    //}
}

- (IBAction)UpdateAvailability:(id)sender
{
    
    //NSDictionary *dict = [NSDictionary dictionaryWithPropertiesOfObject: details];
    //NSLog(@"%@", dict);
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i=0; i < [userAvailibities count]; i++)
    {
        UserAvailableObj *details = [[UserAvailableObj alloc] init];
        
        details = userAvailibities[i];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([details class], &count);
        
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            [dict setObject:[details valueForKey:key] forKey:key];
        }
        NSLog(@"dict===%@",dict);
        [array addObject:dict];
        free(properties);
    }
    
    NSLog(@"array===%@",array);
    
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"result===%@",result);
    [self checkWebService:result];
    
    
}

- (void)cancelEezzyy {
    // [self dismissViewControllerAnimated:NO completion:nil];
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([userAvailibities count] == 0 ){
        nomatchesView.hidden = NO;
    } else {
        nomatchesView.hidden = YES;
    }
    return userAvailibities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UserAvailableTVController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:indexPath.row];
    NSLog(@"tempObject===%@====%@",tempObject.Date,tempObject.Day);
    cell.Date.text = tempObject.Date;
    
    cell.Day.text = tempObject.Day;
    
    
    
    if (![actionType isEqualToString:@"User-Avail-Selection"]) {
        
        
        cell.morningSelect.enabled = true;
        cell.morningSelect.tag = indexPath.row;
        [cell.morningSelect addTarget:self action:@selector(morBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([tempObject.Morning isEqualToString:@"Available"]) {
            [cell.morningSelect setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        }
        else if ([tempObject.Morning isEqualToString:@"Reserved"])
        {
            
            cell.morningSelect.enabled=false;
            
            [cell.morningSelect setBackgroundImage:[UIImage imageNamed:@"morning-inactive.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.morningSelect setBackgroundImage:[UIImage imageNamed:@"morning.png"] forState:UIControlStateNormal];
        }
        
        cell.afternoonSelect.enabled = true;
        cell.afternoonSelect.tag = indexPath.row;
        [cell.afternoonSelect addTarget:self action:@selector(afterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([tempObject.Afternoon isEqualToString:@"Available"]) {
            [cell.afternoonSelect setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        }
        else if ([tempObject.Afternoon isEqualToString:@"Reserved"])
        {
            
            cell.afternoonSelect.enabled=false;
            
            [cell.afternoonSelect setBackgroundImage:[UIImage imageNamed:@"afternoon-inactive.png"] forState:UIControlStateNormal];
        }
        
        else
        {
            [cell.afternoonSelect setBackgroundImage:[UIImage imageNamed:@"afternoon.png"] forState:UIControlStateNormal];
        }
        
        cell.eveningSelect.enabled = true;
        cell.eveningSelect.tag = indexPath.row;
        [cell.eveningSelect addTarget:self action:@selector(eveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([tempObject.Evening isEqualToString:@"Available"]) {
            [cell.eveningSelect setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        }
        else if ([tempObject.Evening isEqualToString:@"Reserved"])
        {
            
            cell.eveningSelect.enabled=false;
            
            [cell.eveningSelect setBackgroundImage:[UIImage imageNamed:@"night-inactive.png"] forState:UIControlStateNormal];
        }
        
        else
        {
            [cell.eveningSelect setBackgroundImage:[UIImage imageNamed:@"night.png"] forState:UIControlStateNormal];
        }
        
        
        //if(indexPath.row == 0)
        //{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
        NSInteger hour = [components hour];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate = [NSDate date];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
        NSString *dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
        
        NSLog(@"tempObject===%@===111=%@=====%@ ===== %@",tempObject.Date,tempObject.Day,[NSDate date],dateStr);
        if([tempObject.Date isEqualToString:dateStr])
        {
            NSLog(@"hour===%ld",(long)hour);
            
            if(hour >12)
            {
                cell.morningSelect.enabled = false;
            }else if(hour >17)
            {
                cell.afternoonSelect.enabled = false;
            }else
            {
                cell.morningSelect.enabled = true;
                cell.afternoonSelect.enabled = true;
            }
            
            if(hour >= 0 && hour < 12)
                NSLog(@"Good morning, foo");
            else if(hour >= 12 && hour < 17)
                NSLog(@"Good afternoon, foo");
            else if(hour >= 17)
                NSLog(@"Good evening, foo");
        }
        
        //}
        
    }else
    {
        cell.morningSelect.tag = indexPath.row;
        
        cell.morningSelect.enabled = true;
        cell.afternoonSelect.enabled = true;
        cell.eveningSelect.enabled = true;
        
        if ([tempObject.Morning isEqualToString:@"Available"]) {
            [cell.morningSelect setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
            [cell.morningSelect addTarget:self action:@selector(morAvailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.morningSelect.enabled = true;
        }else if ([tempObject.Morning isEqualToString:@"Request"]) {
            [cell.morningSelect setBackgroundImage:[UIImage imageNamed:@"morning.png"] forState:UIControlStateNormal];
            [cell.morningSelect addTarget:self action:@selector(morAvailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.morningSelect.enabled = true;
        }
        else if ([tempObject.Morning isEqualToString:@"Reserved"])
        {
            
            cell.morningSelect.enabled=false;
            
            [cell.morningSelect setBackgroundImage:[UIImage imageNamed:@"morning-inactive.png"] forState:UIControlStateNormal];
        }
        else
        {
            cell.morningSelect.enabled = false;
            [cell.morningSelect setBackgroundImage:[UIImage imageNamed:@"morning.png"] forState:UIControlStateNormal];
        }
        
        //Request
        
        cell.afternoonSelect.tag = indexPath.row;
        
        
        
        if ([tempObject.Afternoon isEqualToString:@"Available"]) {
            [cell.afternoonSelect setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
            [cell.afternoonSelect addTarget:self action:@selector(afterAvailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.afternoonSelect.enabled = true;
        }else if ([tempObject.Afternoon isEqualToString:@"Request"]) {
            [cell.afternoonSelect setBackgroundImage:[UIImage imageNamed:@"afternoon.png"] forState:UIControlStateNormal];
            [cell.afternoonSelect addTarget:self action:@selector(afterAvailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.afternoonSelect.enabled = true;
        }
        else if ([tempObject.Afternoon isEqualToString:@"Reserved"])
        {
            
            cell.afternoonSelect.enabled=false;
            
            [cell.afternoonSelect setBackgroundImage:[UIImage imageNamed:@"afternoon-inactive.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.afternoonSelect setBackgroundImage:[UIImage imageNamed:@"afternoon.png"] forState:UIControlStateNormal];
            cell.afternoonSelect.enabled = false;
        }
        
        cell.eveningSelect.tag = indexPath.row;
        
        
        
        if ([tempObject.Evening isEqualToString:@"Available"]) {
            [cell.eveningSelect setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
            [cell.eveningSelect addTarget:self action:@selector(eveAvailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.eveningSelect.enabled = true;
        }else if ([tempObject.Evening isEqualToString:@"Request"]) {
            [cell.eveningSelect setBackgroundImage:[UIImage imageNamed:@"night.png"] forState:UIControlStateNormal];
            [cell.eveningSelect addTarget:self action:@selector(eveAvailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.eveningSelect.enabled = true;
        }
        else if ([tempObject.Evening isEqualToString:@"Reserved"])
        {
            
            cell.eveningSelect.enabled=false;
            
            [cell.eveningSelect setBackgroundImage:[UIImage imageNamed:@"night-inactive.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.eveningSelect setBackgroundImage:[UIImage imageNamed:@"night.png"] forState:UIControlStateNormal];
            cell.eveningSelect.enabled = false;
        }
        
        //if(indexPath.row == 0)
        //{
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
        NSInteger hour = [components hour];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate = [NSDate date];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
        NSString *dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
        NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
        
        NSLog(@"tempObject===%@===111=%@=====%@ ===== %@",tempObject.Date,tempObject.Day,[NSDate date],dateStr);
        if([tempObject.Date isEqualToString:dateStr])
        {
            
            NSLog(@"hour===%ld",(long)hour);
            
            if(hour >12)
            {
                cell.morningSelect.enabled = false;
            }else if(hour >17)
            {
                cell.afternoonSelect.enabled = false;
            }else
            {
                cell.morningSelect.enabled = true;
                cell.afternoonSelect.enabled = true;
            }
            
            if(hour >= 0 && hour < 12)
                NSLog(@"Good morning, foo");
            else if(hour >= 12 && hour < 17)
                NSLog(@"Good afternoon, foo");
            else if(hour >= 17)
                NSLog(@"Good evening, foo");
        }
        //}
        
    }
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    
    
    
    
    return cell;
}

-(void)showName:(UIButton*)button{
    int row = (int)button.tag;
    NSLog(@"row===%i",row);
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:row];
    NSLog(@"tempObject====%@", tempObject.Date);
    tempObject.Morning=@"Not";
    
    [self.tableView reloadData];
}



-(void)morBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%d",(int)senderButton.tag);
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:senderButton.tag];
    NSLog(@"Morning====%@", tempObject.Morning);
    
    
    if([tempObject.Morning isEqualToString:@"Available"])
    {
        tempObject.Morning=@"Not";
    }else if([tempObject.Morning isEqualToString:@"Not"])
    {
        tempObject.Morning=@"Available";
    }
    [self.tableView reloadData];
}

-(void)morAvailBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:senderButton.tag];
    NSLog(@"Morning====%@", tempObject.Morning);
    
    
    if([tempObject.Morning isEqualToString:@"Available"])
    {
        tempObject.Morning=@"Request";
    }else if([tempObject.Morning isEqualToString:@"Request"])
    {
        tempObject.Morning=@"Available";
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%@",@"Morning"] forKey:@"Time"];
    [dict setValue:[NSString stringWithFormat:@"%@",tempObject.Date] forKey:@"Date"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestAvail" object: dict];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self.tableView reloadData];
}

-(void)afterBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:senderButton.tag];
    NSLog(@"Afternoon====%@", tempObject.Afternoon);
    
    
    if([tempObject.Afternoon isEqualToString:@"Available"])
    {
        tempObject.Afternoon=@"Not";
    }else if([tempObject.Afternoon isEqualToString:@"Not"])
    {
        tempObject.Afternoon=@"Available";
    }
    
    [self.tableView reloadData];
}

-(void)afterAvailBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:senderButton.tag];
    NSLog(@"Afternoon====%@", tempObject.Afternoon);
    
    
    if([tempObject.Afternoon isEqualToString:@"Available"])
    {
        tempObject.Afternoon=@"Request";
    }else if([tempObject.Afternoon isEqualToString:@"Request"])
    {
        tempObject.Afternoon=@"Available";
    }
    
    //[self.tableView reloadData];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%@",@"Afternoon"] forKey:@"Time"];
    [dict setValue:[NSString stringWithFormat:@"%@",tempObject.Date] forKey:@"Date"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestAvail" object: dict];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)eveBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:senderButton.tag];
    
    NSLog(@"Evening====%@", tempObject.Evening);
    if([tempObject.Evening isEqualToString:@"Available"])
    {
        tempObject.Evening=@"Not";
    }else if([tempObject.Evening isEqualToString:@"Not"])
    {
        tempObject.Evening=@"Available";
    }
    
    [self.tableView reloadData];
}

-(void)eveAvailBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"current Row=%ld",(long)senderButton.tag);
    
    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:senderButton.tag];
    
    NSLog(@"Evening====%@", tempObject.Evening);
    if([tempObject.Evening isEqualToString:@"Available"])
    {
        tempObject.Evening=@"Request";
    }else if([tempObject.Evening isEqualToString:@"Request"])
    {
        tempObject.Evening=@"Available";
    }
    
    //[self.tableView reloadData];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%@",@"Evening"] forKey:@"Time"];
    [dict setValue:[NSString stringWithFormat:@"%@",tempObject.Date] forKey:@"Date"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestAvail" object: dict];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
