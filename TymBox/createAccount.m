

//
//  createAccount.m
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "createAccount.h"
#import "MBProgressHUD.h"
@interface createAccount ()

{
    UIView  *pickerParentView ;
    NSDictionary *jsonArray;
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;
    UIAlertController *alertmam;
    NSString *device_Token;
    
}
@end
@implementation createAccount
@synthesize userNameTxtField,passwordTxtField,emailTxtField,phoneTxtField,accessToken,genderSegment,birthYearTxtField,selectedGender;

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    selectedGender=@"Male";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    
    device_Token = [[NSUserDefaults standardUserDefaults]stringForKey:@"Device_Token"];
    
    //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    UIImage *backBtnImage = [UIImage imageNamed:@"Back.png"]  ;
    //    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    //    [backBtn addTarget:self action:@selector(cancelEezzyy) forControlEvents:UIControlEventTouchUpInside];
    //    backBtn.frame = CGRectMake(0, 0, 35, 23);
    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    //    self.navigationItem.leftBarButtonItem = backButton;
    
}
- (BOOL) validateEmail:(NSString *)emailAddress
{
    NSString *emailRegex = @"^([a-zA-Z0-9_\\-\\.]+)@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,3})$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return  [emailTest evaluateWithObject:emailAddress];
}
-(void) cancelEezzyy{
    
    // [self.navigationController dismissViewControllerAnimated:YES completion:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)Stop{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (IBAction)signupAction:(id)sender {
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *errorlist=@"" ;
    if ([userNameTxtField.text length] <2)
    {
        errorlist=[(errorlist) stringByAppendingString:@"\nPlease enter your first name (2-20 characters)"];
    }
    
    if ([birthYearTxtField.text length] == 0)
    {
        errorlist=[(errorlist) stringByAppendingString:@"\nPlease select a valid DOB"];
    }
    if ( (![self validateEmail:emailTxtField.text] || [ emailTxtField.text length] == 0))
    {
        errorlist=[(errorlist) stringByAppendingString:@"\nPlease enter a valid E-mail ID"];
    }
    if ([phoneTxtField.text length] == 0)
    {
        errorlist=[(errorlist) stringByAppendingString:@"\nPlease enter your mobile number"];
    }
    
    else {
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        
        //            NSString *serviceString = [NSString stringWithFormat:@"http://192.168.0.158:8080/TymBoxWeb/NewAccountServlet?u=%@&e=%@&p=%@&ph=%@&gender=%@&boy=%@",userNameTxtField.text,emailTxtField.text,passwordTxtField.text,phoneTxtField.text,selectedGender,birthYearTxtField.text];
        //         NSDictionary *listofdict;
        //   NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/NewAccountServlet?u=%@&e=%@&p=%@&ph=%@&gender=%@&boy=%@",userNameTxtField.text,emailTxtField.text,passwordTxtField.text,phoneTxtField.text,selectedGender,birthYearTxtField.text]];
        
        if (!device_Token) {
            device_Token=@"";
        }
        
        
        
        NSString *stringUrl=[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/NewAccountServlet?u=%@&e=%@&p=%@&ph=%@&gender=%@&boy=%@&login_type=%@&device_token=%@",userNameTxtField.text,emailTxtField.text,passwordTxtField.text,phoneTxtField.text,selectedGender,birthYearTxtField.text,@"Tymbox",device_Token];
        NSURL *url=[NSURL new];
        
        url= [NSURL URLWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        //        NSURL *url=[NSURL URLWithString:serviceString];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        if (!responseData)
        {
            [self Stop];
            NSLog(@"Download Error: %@", error.localizedDescription);
            
        }
        else {
            
            NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",myString);
            // Parse the (binary) JSON data from the web service into an NSDictionary object
            jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            NSLog(@"2.dictionary values are : %@",jsonArray);
            
            if (jsonArray == nil) {
                [self Stop];
                NSLog(@"JSON Error: %@", error);
            }
            
            else{
                [self Stop];
                
                NSDictionary *dec = @{ @"userId": [jsonArray objectForKey:@"infoSuccess"], @"userName": userNameTxtField.text,@"email": emailTxtField.text,@"phone": phoneTxtField.text,};
                
                
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:dec forKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                
                UIAlertView *Sucessalert = [[UIAlertView alloc]initWithTitle:@"" message:@"Registered Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [self performSegueWithIdentifier:@"createdAccount" sender:self];
                [Sucessalert show];
                //[self dismissViewControllerAnimated:YES completion:nil];
                /*    alertmam = [UIAlertController alertControllerWithTitle:result message:@"Registered Successfully" preferredStyle:UIAlertControllerStyleAlert];
                 
                 
                 
                 [self presentViewController:alertmam animated:YES completion:nil];
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^(void) {
                 
                 [alertmam dismissViewControllerAnimated:YES completion:^{ [self performSegueWithIdentifier:@"createdAccount" sender:self];
                 
                 }];
                 
                 
                 });
                 
                 */
                
                
                
                
                
            }
        }
    }
    
}
//-(void)Dismiss{
//   [alertmam dismissViewControllerAnimated:YES completion:^{ [self performSegueWithIdentifier:@"createdAccount" sender:self];
//    }];
//
//}
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
    birthYearTxtField.inputView = pickerParentView;
    
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
    birthYearTxtField.text = [FormatDate stringFromDate:[datePicker date]];
    [birthYearTxtField resignFirstResponder];
    // [self closeDatePicker:self];
}
-(void)CancelPickerDoneClick
{
    [birthYearTxtField resignFirstResponder];
    //[self closeDatePicker:self];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
    if (textField.tag==55) {
        [self calenderButton:nil];
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)genderSegmentAction:(id)sender {
    
    switch (self.genderSegment.selectedSegmentIndex)
    {
        case 0:
            selectedGender = @"Male";
            break;
        case 1:
            selectedGender = @"Female";
            break;
        default: 
            break; 
    }
}
@end
