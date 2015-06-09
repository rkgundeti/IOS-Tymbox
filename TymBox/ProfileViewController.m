//
//  ProfileViewController.m
//  TymBox030915
//
//  Created by Bhagavan on 3/23/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserAddressViewController.h"
#import "CKCalendarView.h"
#import "SWRevealViewController.h"
@interface ProfileViewController ()
<CKCalendarDelegate>
{
    
    UIView  *pickerParentView;
    NSString *loggedInuserId;
    NSString *profileOption;
    NSDateFormatter *FormatDate;
    UIDatePicker *datePicker;
    
    NSString *imgName;
    
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;


@end

@implementation ProfileViewController
@synthesize userNametxt,emailIdlbl,phonetxt,yeartxt,genderstr,addresslbl,strGender;
@synthesize street,city,pinCode,country,state;
@synthesize yearBtn,UDID,UID,PhotoImg,updateBtn,activityIndicator,profileSwitch;
@synthesize navigateFrom;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"navigateFrom====%@",navigateFrom);
    
    PhotoImg.layer.borderWidth = 1;
    PhotoImg.layer.cornerRadius=8.0f;
    PhotoImg.layer.masksToBounds=YES;
    PhotoImg.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    loggedInuserId= [NSString stringWithFormat:@"%@",[userInfoDic valueForKey:@"userId"]] ;
    SWRevealViewController *reveal = self.revealViewController;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:reveal action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    
    
    self.title = @"My Profile";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressNotification:) name:@"addressupdate" object:nil];
    
    profileOption = @"Private";
    //[self.profileSwitch setOn:YES animated:YES];
    
    [self getUserDetails];
    
    
}





-(void)getUserDetails{
    
    
    //NSString *URL_LOGIN = @"http://192.168.0.158:8080/TymBoxWeb/LoginServlet?u=test@test.com&p=test";
    
    NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserDetailServlet?userid=%@",loggedInuserId];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeNotification:) name:@"closeNotification" object:nil];
    
    NSLog(@"responseCode====%@",responseCode);
    // NSLog(@"~~~~~ Status code: %d", [response statusCode]);
    
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"UDID===%@",dict);
                
                NSLog(@"DOB===%@",[dict objectForKey:@"DOB"]);
                
                NSString *dateStr = [dict objectForKey:@"DOB"];
                
                // Convert string to date object
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [dateFormat dateFromString:dateStr];
                
                // Convert date object to desired output format
                [dateFormat setDateFormat:@"MM/dd/yyyy"];
                dateStr = [dateFormat stringFromDate:date];
                
                yeartxt.text = dateStr; //[dict objectForKey:@"DOB"];
                
                NSLog(@"city===%@",[dict objectForKey:@"city"]);
                //                NSURL *url = [NSURL URLWithString:[dict objectForKey:@"imageBase64"]];
                //                NSData *imageData = [NSData dataWithContentsOfURL:url];
                //             PhotoImg.image = [UIImage imageWithData:imageData];
                
                //NSData* data = [[NSData alloc] initWithBase64EncodedString:[dict objectForKey:@"imageBase64"] options:0];
                //UIImage* image = [UIImage imageWithData:data];
                
                /*
                UIImage *tempImage = [UIImage imageNamed:@"spr.png"];
                PhotoImg.image = tempImage;
                if(image)
                {
                    PhotoImg.image=image;
                }
                */
                NSString *imgUrl = [NSString new];
                if([dict objectForKey:@"image"])
                {
                    imgUrl = [dict objectForKey:@"image"];
                }else if([dict objectForKey:@"imageBase64"])
                {
                    imgUrl = [dict objectForKey:@"imageBase64"];
                }
                
                NSLog(@"imgurl====%@",imgUrl);
                
                NSLog(@"=====%@",imgUrl);
                if(imgUrl !=nil && ![imgUrl isEqual:[NSNull null]] && ![imgUrl isEqualToString:@""])
                {
                    NSString* encodedUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding:
                                            NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:encodedUrl];
                    
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    PhotoImg.image = image;
                    imgName = imgUrl;
                }else{
                    UIImage *tempImage = [UIImage imageNamed:@"Placeholder.png"];
                    PhotoImg.image = tempImage;
                    imgName = @"Placeholder.png";
                }
                
                city = [dict objectForKey:@"city"];
                country = [dict objectForKey:@"country"];
                pinCode = [dict objectForKey:@"pinCode"];
                street = [dict objectForKey:@"street"];
                state = [dict objectForKey:@"state"];
                strGender = [dict objectForKey:@"gender"];
                phonetxt.text = [dict objectForKey:@"phone"];
                userNametxt.text= [dict objectForKey:@"userName"];
                NSLog(@"strGender===%@",strGender);
                
                if ([strGender isEqualToString:@"Male"]) {
                    genderstr.selectedSegmentIndex=0;
                }else if ([strGender isEqualToString:@"Female"]) {
                    genderstr.selectedSegmentIndex=1;
                }
                
                
                //strGender = [NSString stringWithFormat:@"%@",[genderstr titleForSegmentAtIndex:0]];
                
                NSLog(@"country===%@",[dict objectForKey:@"country"]);
                NSLog(@"gender===%@",[dict objectForKey:@"gender"]);
                NSLog(@"pinCode===%@",[dict objectForKey:@"pinCode"]);
                
                NSLog(@"street===%@",[dict objectForKey:@"street"]);
                NSLog(@"user_id===%@",[dict objectForKey:@"user_Id"]);
                NSLog(@"user_name===%@",[dict objectForKey:@"user_Name"]);
                userNametxt.text = [dict objectForKey:@"user_Name"];
                //country = [dict objectForKey:@"country"];
                NSLog(@"user_Email_Id===%@",[dict objectForKey:@"user_Email_Id"]);
                emailIdlbl.text = [dict objectForKey:@"user_Email_Id"];
                
                NSLog(@"user_Password===%@",[dict objectForKey:@"user_Password"]);
                NSLog(@"user_id===%@",[dict objectForKey:@"user_Id"]);
                UID = [dict objectForKey:@"user_Id"];
                UDID = [dict objectForKey:@"UDID"];
                profileOption = [dict objectForKey:@"profile"];
                
                if([profileOption isEqualToString:@"private"])
                {
                    profileSwitch.on = NO;
                    [self.privateButton setSelected:YES];
                    [self.publicButton setSelected:NO];
                }else{
                    profileSwitch.on = YES;
                    [self.publicButton setSelected:YES];
                    [self.privateButton setSelected:NO];
                }
                addresslbl.text = [NSString stringWithFormat:@"%@, %@, %@",street,city,state];
                
                // [self performSegueWithIdentifier:@"loggedInUser" sender:self];
                
            }
            
            
        }else
        {
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alert show];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"PopUpViewController_iPad" bundle:nil];
                [self.popViewController setTitle:@"This is a popup view"];
                
                [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"You just triggered a great popup window" animated:YES messageType:@"Error"];
            } else {
                
                self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"CustomAlertBoxViewCon" bundle:nil];
                [self.popViewController setTitle:@"Message"];
                
                [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"Problem with DB Service" animated:YES messageType:@"Error"];
                
                self.popViewController.view.superview.frame = CGRectMake(0, 0, 310, 500);
                self.popViewController.view.superview.center = self.view.center;
                
            }
        }
        
    }else
    {
        
        //if ([responseCode isEqualToString:@"0"]) {
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"PopUpViewController_iPad" bundle:nil];
            [self.popViewController setTitle:@"This is a popup view"];
            
            [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"You just triggered a great popup window" animated:YES messageType:@"Error"];
        } else {
            
            self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"CustomAlertBoxViewCon" bundle:nil];
            [self.popViewController setTitle:@"Message"];
            
            [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"Problem with DB Service" animated:YES messageType:@"Error"];
            
            self.popViewController.view.superview.frame = CGRectMake(0, 0, 310, 500);
            self.popViewController.view.superview.center = self.view.center;
            
        }
    }
    
    
    
    
}

- (void) closeNotification:(NSNotification *)notification{
    
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    if([[theString objectForKey:@"Info"] isEqualToString:@"Ok"])
    {
        
        if([navigateFrom isEqualToString:@"profileUpdateNav"])
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
    //[self performSegueWithIdentifier:@"profileUpdateNav" sender:self];
    
}

- (void) addressNotification:(NSNotification *)notification{
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    street = [theString objectForKey:@"street"];
    city = [theString objectForKey:@"city"];
    state = [theString objectForKey:@"state"];
    pinCode = [theString objectForKey:@"zip"];
    country = [theString objectForKey:@"country"];
    addresslbl.text = [NSString stringWithFormat:@"%@, %@, %@",street,city,state];
    //self.addressbtn.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@",street,city,state];
    NSLog(@"pinCode===%@",pinCode);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addAddress"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSLog(@"accToken====%@",accToken);
        
        //UserAddressViewController* controller =[segue destinationViewController];
        UserAddressViewController* controller =(UserAddressViewController*)[[segue destinationViewController] topViewController];
        controller.street = street;
        controller.state = state;
        controller.country = country;
        controller.city = [NSString stringWithFormat:@"%@",city];
        controller.pinCode = [NSString stringWithFormat:@"%@",pinCode];
        //[controller setAccessToken:self.accToken];
        
        NSLog(@"login===%@",controller);
        
    }else if([segue.identifier isEqualToString:@"updateTalent"])
    {
        /*
         NSIndexPath *indexPath = nil;
         indexPath = [self.tableView indexPathForSelectedRow];
         NSLog(@"indexpath=row===%ld",(long)indexPath.row);
         
         UserCatTalentObj * talent = [[UserCatTalentObj alloc] init];
         talent = [userCatTalents objectAtIndex:indexPath.row];
         AddTalentsController* controller =[segue destinationViewController];
         //AddTalentsController* controller = (AddTalentsController*)[[segue destinationViewController] topViewController];
         controller.addorUpdateAction = @"Update";
         controller.categoryName = talent.categoryName;
         controller.talentName = talent.talentName;
         controller.talentId = talent.talentId;
         controller.userTalentId = talent.userTalentId;
         controller.talentObj = talent;
         */
        /*
         
         TalentDetailViewController *controller = segue.destinationViewController;
         //controller.userTalent = talent;
         //controller.selCategory = selectedCategory;
         controller.categories = categories;
         controller.selCatId = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
         controller.selTalId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
         
         */
    }
}

- (IBAction)genderAction:(id)sender {
    
    if(genderstr.selectedSegmentIndex == 0)
    {
        //self.view.backgroundColor = [UIColor redColor];
        strGender = [NSString stringWithFormat:@"%@",[genderstr titleForSegmentAtIndex:0]];
        
    }
    else if(genderstr.selectedSegmentIndex == 1)
    {
        //self.view.backgroundColor = [UIColor greenColor];
        strGender = [NSString stringWithFormat:@"%@",[genderstr titleForSegmentAtIndex:1]];
    }
    
}

- (void) checkFieldsComplete {
    
    if ([userNametxt.text isEqualToString:@""] || [phonetxt.text isEqualToString:@""] || [yeartxt.text isEqualToString:@""] || [street isEqualToString:@""] || [city isEqualToString:@""] || [state isEqualToString:@""] || [country isEqualToString:@""] ||[pinCode isEqualToString:@""])
    {
        [self alertStatus:@"You need to complete all fields." :@"Error" :0];
    }else
    {
        [self updateService];
    }
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"PopUpViewController_iPad" bundle:nil];
        [self.popViewController setTitle:@"This is a popup view"];
        
        [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"You just triggered a great popup window" animated:YES messageType:@"Info"];
    } else {
        
        self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"CustomAlertBoxViewCon" bundle:nil];
        [self.popViewController setTitle:title];
        
        [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:msg animated:YES messageType:title];
        
        self.popViewController.view.superview.frame = CGRectMake(0, 0, 310, 500);
        self.popViewController.view.superview.center = self.view.center;
        
    }
}

-(void) updateService
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSLog(@"yeartxt.text====%@",yeartxt.text);
    UIImage* image = PhotoImg.image;
    NSData* dataImage = [NSData new];
    NSString* base64Image = [NSString new];
    if(image)
    {
        dataImage = UIImagePNGRepresentation(image);
        base64Image = [dataImage base64EncodedStringWithOptions:0];
        
    }
    
    
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@", street, city, country];
    NSLog(@"GET Addres%@",address);
    
    
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *geoLocationresult = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (geoLocationresult) {
        NSScanner *scanner = [NSScanner scannerWithString:geoLocationresult];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    
    NSLog(@"center===%f, %f",center.longitude, center.latitude);
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)[loggedInuserId integerValue]] forKey:@"user_id"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)[UDID integerValue]] forKey:@"UDID"];
    [dict setValue:[NSString stringWithFormat:@"%@",street] forKey:@"street"];
    [dict setValue:[NSString stringWithFormat:@"%@",city] forKey:@"city"];
    [dict setValue:[NSString stringWithFormat:@"%@",state] forKey:@"state"];
    [dict setValue:[NSString stringWithFormat:@"%@",pinCode] forKey:@"pinCode"];
    [dict setValue:[NSString stringWithFormat:@"%@",country] forKey:@"country"];
    [dict setValue:[NSString stringWithFormat:@"%@",yeartxt.text] forKey:@"DOB"];
    [dict setObject:base64Image forKey:@"imageBase64"];
    [dict setObject:[NSString stringWithFormat:@"%@",strGender] forKey:@"gender"];
    
    [dict setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [dict setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"logitude"];
    [dict setObject:[NSString stringWithFormat:@"%@",profileOption] forKey:@"profile"];
    [dict setObject:[NSString stringWithFormat:@"%@",userNametxt.text] forKey:@"userName"];
    [dict setObject:[NSString stringWithFormat:@"%@",phonetxt.text] forKey:@"phone"];
    
    
    
    [array addObject:dict];
    
    NSLog(@"array===%@",array);
    
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"result===%@",result);
    [self checkWebService:result];
}

- (IBAction)updateAction:(id)sender {
    
    [userNametxt resignFirstResponder];
    //[emailId resignFirstResponder];
    //[passWord resignFirstResponder];
    [phonetxt resignFirstResponder];
    [yeartxt resignFirstResponder];
    [self checkFieldsComplete];
    
    
    
    
    
    
    
}

- (void) checkWebService:(NSString *)strBody {
    
    NSString *serviceString;
    NSString *strdata = strBody;
    
    serviceString=@"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateUserDetailsServlet";
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
    msg=@"User Profile Updated";
    
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    if (!responseData)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        
    }
    NSDictionary *jsonDictionary;
    jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if (jsonDictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        msg=@"Problem with Server";
    }
    
    if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"success"]) {
        
        //UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        //[alert1 show];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"PopUpViewController_iPad" bundle:nil];
            [self.popViewController setTitle:@"This is a popup view"];
            
            [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"You just triggered a great popup window" animated:YES messageType:@"Info"];
        } else {
            
            self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"CustomAlertBoxViewCon" bundle:nil];
            [self.popViewController setTitle:@"Message"];
            
            [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:msg animated:YES messageType:@"Info"];
            
            self.popViewController.view.superview.frame = CGRectMake(0, 0, 310, 500);
            self.popViewController.view.superview.center = self.view.center;
            
        }
        
        UIImage* image = PhotoImg.image;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults removeObjectForKey:@"uImage"];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 100);
        
        [defaults setObject:imageData forKey:@"uImage"];
        [defaults synchronize];
        
    }else if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"fail"]) {
        
        //UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Problem with Server" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        //[alert1 show];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"PopUpViewController_iPad" bundle:nil];
            [self.popViewController setTitle:@"This is a popup view"];
            
            [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:@"You just triggered a great popup window" animated:YES messageType:@"Info"];
        } else {
            
            self.popViewController = [[CustomAlertBoxViewCon alloc] initWithNibName:@"CustomAlertBoxViewCon" bundle:nil];
            [self.popViewController setTitle:@"Message"];
            
            [self.popViewController showInView:self.view withImage:[UIImage imageNamed:@"typpzDemo"] withMessage:msg animated:YES messageType:@"Error"];
            
            self.popViewController.view.superview.frame = CGRectMake(0, 0, 310, 500);
            self.popViewController.view.superview.center = self.view.center;
            
        }
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
        //[self.navigationController popViewControllerAnimated:YES];
        
        if([navigateFrom isEqualToString:@"profileUpdateNav"])
        {
            [self dismissViewControllerAnimated:NO completion:nil];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
    else
    {
        NSLog(@"ok");
        //[self.navigationController popViewControllerAnimated:YES];
        
    }
    //}
}

- (IBAction)addAddressAction:(id)sender {
    
    [self performSegueWithIdentifier:@"addAddress" sender:self];
    
}

- (IBAction)chnageImage:(id)sender {
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Tymbox"
                                 message:@"Upload profile picture"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction
                                actionWithTitle:@"Take Photo"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Do some thing here
                                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                    picker.delegate = self;
                                    picker.allowsEditing = YES;
                                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                    
                                    [self presentViewController:picker animated:YES completion:NULL];
                                    
                                }];
    UIAlertAction* selectPhoto = [UIAlertAction
                                  actionWithTitle:@"Select Photo"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                      picker.delegate = self;
                                      picker.allowsEditing = YES;
                                      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                      
                                      [self presentViewController:picker animated:YES completion:NULL];
                                      
                                  }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    
    
    [view addAction:takePhoto];
    [view addAction:selectPhoto];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.PhotoImg.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)profileAction:(id)sender {
    
    if ([profileSwitch isOn]) {
        profileOption = @"Public";
    }else {
        profileOption = @"Private";
    }
    
}

/*======for custom calendar functionality ======*/

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    //self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    
    //self.yearBtn.titleLabel.text = [self.dateFormatter stringFromDate:date];
    yeartxt.text =  [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    NSDate* date1 = date;
    
    NSDate *date2 = [NSDate date];
    
    if ([date1 compare:date2] == NSOrderedSame){
        NSLog(@"Same");
    }
    if ([date2 compare:date1]==NSOrderedAscending ) {
        updateBtn.enabled = false;
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Birth Year Can't be more than current Date" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }
    if ([date2 compare:date1]== NSOrderedDescending) {
        NSLog(@"Descending");
        updateBtn.enabled = true;
        
    }
    
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (IBAction)showCalendar:(id)sender {
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"09/20/2012"];
    
    self.disabledDates = @[
                           [self.dateFormatter dateFromString:@"01/05/2013"],
                           [self.dateFormatter dateFromString:@"01/06/2013"],
                           [self.dateFormatter dateFromString:@"01/07/2013"]
                           ];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    NSLog(@"yearbtn   %f,  %f",yearBtn.frame.origin.x,yearBtn.frame.origin.y);
    
    calendar.frame = CGRectMake(yearBtn.frame.origin.x-120, yearBtn.frame.origin.y - 240, 200, 220);
    [self.view addSubview:calendar];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    //[self.view addSubview:self.dateLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
    
    if (textField.tag==55) {
        [self calenderButton:nil];
    }
    
}
- (void)calenderButton:(id)sender
{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // NSDate *currentDate = [NSDate date];
    //  NSDate *yesterday = [NSDate dateWithString:@"2009-12-10 00:00:00 +0000"];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    
    // NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:yesterday options:0];
    
    datePicker.maximumDate = [NSDate date];
    //  [datePicker setMaximumDate:maxDate];
    
    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setFormatterBehavior:NSDateFormatterBehavior10_4];
    [FormatDate setDateFormat:@"MM/dd/yyyy"];
    
    
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    // toolBar.tintColor = [UIColor whiteColor];
    toolBar.barStyle=UIBarStyleBlackOpaque;
    [toolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick)];
    //flexSpace.tintColor = [UIColor colorWithRed:89/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f];
    //    UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelPickerDoneClick)];
    //flexSpace1.tintColor = [UIColor colorWithRed:89/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f];
    [barItems addObject:flexSpace];
    //    [barItems addObject:flexSpace1];
    
    [toolBar setItems:barItems animated:YES];
    pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
    [pickerParentView addSubview:datePicker];
    [pickerParentView addSubview:toolBar];
    yeartxt.inputView = pickerParentView;
    
    //    pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
    //    [pickerParentView addSubview:datePicker];
    //    [pickerParentView addSubview:toolBar];
    //    perTxtField.inputView = pickerParentView;
    //
    //    [actionSheet addSubview:toolBar];
    //    [actionSheet addSubview:datePicker];
    //    [actionSheet  showInView:self.view];
    //    [actionSheet setBounds:CGRectMake(0,0,320, 464)];}
    
    
    
}

-(void)dateChanged
{
    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setDateFormat:@"MM/dd/yyyy"];
}

-(void)DatePickerDoneClick
{
    yeartxt.text = [FormatDate stringFromDate:[datePicker date]];
    [yeartxt resignFirstResponder];
    // [self closeDatePicker:self];
}
-(void)CancelPickerDoneClick
{
    [yeartxt resignFirstResponder];
    //[self closeDatePicker:self];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -50; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}




- (IBAction)onRadioAction:(RadioButton*)sender {
    
    profileOption = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
    
    //UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:profileOption delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    //[alert1 show];
}
@end
