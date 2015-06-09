//
//  SeekerReachOutController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/2/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "SeekerReachOutController.h"
#import "MBProgressHUD.h"
#import "TransDetObj.h"
#import "UserAvailTableVCon.h"
@interface SeekerReachOutController ()
{
    NSString *userID;
    UIPickerView * pickerView;
    UIView  *pickerParentView ;
    NSArray *morningArray;
    NSArray *hoursArray;
     NSDictionary *jsonArray;
    NSString *helperID;
    NSString *talentId;
    NSString *userType;
    NSString *helperTalentId;
    NSString *selectedTalent3;
    NSString *selectedTalentID;
    NSString *transId;
    NSString *seekerIdString;
  
   
}
@end

@implementation SeekerReachOutController
@synthesize helperDetailsArray,specificDateTxtField,dateTxtField,oneTxtFiels,jobTxtField,willingToPayTxtField,expenseTxtField,toatlTxtField,scrollView,reachoutTxtView,sendDictionary,transType,selectedObj,helperNameLabel,selectedTalent;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [reachoutTxtView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [reachoutTxtView.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    reachoutTxtView.layer.cornerRadius = 5;
    reachoutTxtView.clipsToBounds = YES;
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userID=[userInfoDic valueForKey:@"userId"];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:nextDate];
    NSLog(@"%@",formattedDateString);
    
    NSLog(@"nextDate: %@ ...", nextDate);
    
    
    dateTxtField.text=formattedDateString;
    NSLog(@"transtype===%@",transType);
    NSLog(@"selectedObj===%@",selectedObj);
    if ([transType isEqualToString:@"edit"]) {
        
//        selectedNameTxt.text = seekerName;
//        rateTxt.text = [NSString stringWithFormat:@"%@",rate];
//        rateTypeTxt.text = [NSString stringWithFormat:@"%@",rateType];
//        
//        selectedTalentTxt.text =talentName;
//        seekerId = selectedObj.userId;
//        NSLog(@"selectedobj====%@",selectedObj);
        transId = selectedObj.transId;
        seekerIdString=selectedObj.seekerId;
//        selectedNameTxt.text = selectedObj.seekerName;
//
        
        selectedTalentID=selectedObj.user_Talent_Id;
        selectedTalent3 = selectedObj.user_Talent_Name;
       
//        
//        
//        selectedTalentId = selectedObj.user_Talent_Id;
//        
//        
        TransDetObj *transDet = [[TransDetObj alloc]init];
        transDet = [selectedObj.detArray objectAtIndex:0];
        willingToPayTxtField.text = [NSString stringWithFormat:@"%@",transDet.price];
        
        //[jobBtn setTitle:selectedObj.UOM forState:UIControlStateNormal];
        jobTxtField.text = selectedObj.UOM;
        expenseTxtField.text = [NSString stringWithFormat:@"%@",transDet.expense];
        oneTxtFiels.text = [NSString stringWithFormat:@"%@",transDet.quantity];
        toatlTxtField.text = [NSString stringWithFormat:@"%@",transDet.total];
//
        NSString *urDateString=selectedObj.job_Req_Date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
        NSDate *dateString = [dateFormatter dateFromString:strDate];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
        //NSLog(@"%@",formattedDateString);
        
        dateTxtField.text = formattedDateString;
        
    }
    else{
        
        helperTalentId = [NSString stringWithFormat:@"%@",[sendDictionary valueForKey:@"UserTalentId"]];
        helperID = [sendDictionary valueForKey:@"HelperId"];
        selectedTalent.text= [sendDictionary valueForKey:@"TalentName"];
        helperNameLabel.text= [sendDictionary valueForKey:@"HelperName"];
        willingToPayTxtField.text=[sendDictionary valueForKey:@"rate"];
        toatlTxtField.text=[sendDictionary valueForKey:@"rate"];
        selectedTalent3 = [sendDictionary valueForKey:@"TalentName"];
    }
    NSLog(@"%@",helperDetailsArray);
   // helperID= [helperDetailsArray valueForKey:@"userId"];
    
         talentId= [helperDetailsArray valueForKey:@"userTalentId"];
      NSLog(@"%@",sendDictionary);

    
  
    
    [self getHelperTalentId];
 
    
    [scrollView setContentSize:CGSizeMake(320, 1005)];
    morningArray = [[NSArray alloc] initWithObjects:@"By a specific date",@"On a specific date", nil];
    hoursArray = [[NSArray alloc] initWithObjects:@"Hours",@"Day",@"One Job", nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"Calender" object:nil];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)ratetxtEndAction:(id)sender {
    
    [self calculate];
    
}

- (IBAction)expencetxtEndAction:(id)sender {
    
    [self calculate];
    
}
- (IBAction)rateChangedAction:(id)sender {
    [self calculate];
}
- (IBAction)quantityChangedAction:(id)sender {
    [self calculate];
}
- (IBAction)expenseChangedAction:(id)sender {
    [self calculate];
}

-(void) calculate{
    int ratePer = 0;
    int rate = 0;
    int expence = 0;
    
    if(![oneTxtFiels.text isEqualToString:@""])
    {
        ratePer = [oneTxtFiels.text intValue];
    }
    
    if(![willingToPayTxtField.text isEqualToString:@""])
    {
        rate = [willingToPayTxtField.text intValue];
    }
    
    if(![expenseTxtField.text isEqualToString:@""])
    {
        expence = [expenseTxtField.text intValue];
    }
    int total = (ratePer * rate) + expence;
    
    toatlTxtField.text = [NSString stringWithFormat:@"%d",total];
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
-(void)getHelperTalentId{
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",helperID]];
    
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"GET"];
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSMutableArray *total;
    NSMutableArray *JSONDEtails;
    total=[[NSMutableArray alloc] init];
    JSONDEtails = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    for (NSMutableDictionary *dict in JSONDEtails)
    {
        NSLog(@"dict===%@",dict);
        
        
        if ([selectedTalent3 isEqualToString:[dict objectForKey:@"talentName"]]) {
            helperTalentId= [dict objectForKey:@"userTalentId"];
        }
        else{
            NSLog(@"Not his friends");
            
        }
        // c.numberOfTalents = [dict objectForKey:@"talent_name"];
        
        
        
    }


}
- (void) incomingNotification:(NSNotification *)notification{
    NSString *theString = [notification object];
    NSLog(@"%@",theString);
    dateTxtField.text = theString;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
     [self animateTextField: textField up: YES];
    if (textField.tag==1){
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"Calender" sender:self];
        // textField.keyboardType=NO;
    }
    
    else if (textField.tag==0 || textField.tag == 3){
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.tag=textField.tag;
        [pickerView setDataSource: self];
        [pickerView setDelegate: self];
        pickerView.showsSelectionIndicator = YES;
        pickerView.backgroundColor = [UIColor whiteColor];
        // perTxtField.inputView = pickerView;
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutData)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearData)];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexible, doneButton, nil]];
        // perTxtField.inputAccessoryView = toolBar;
        pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
        [pickerParentView addSubview:pickerView];
        [pickerParentView addSubview:toolBar];
        // [self.view addSubview:pickerParentView];
        
        
        textField.inputView = pickerParentView;
    }
    
    
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    if (pickerView.tag == 0){
        return [morningArray count];
    }
    else{
        return [hoursArray count];
    }}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView.tag == 0){
        return [morningArray objectAtIndex:row];
    }
    else{
        return [hoursArray objectAtIndex:row];
    }
    
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0){
        specificDateTxtField.text = [morningArray objectAtIndex:row];
    }
    else{
        jobTxtField.text = [hoursArray objectAtIndex:row];
    }
    
    //Write the required logic here that should happen after you select a row in Picker View.
}
-(void)pickerDoneClicked:(id)sender{
    
    [pickerParentView removeFromSuperview];
    [jobTxtField resignFirstResponder];
    [specificDateTxtField resignFirstResponder];
    // [MorningTxtField resignFirstResponder];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
     [self animateTextField: textField up: NO];
    /*
    if (textField.tag==4 || textField.tag==5) {
        int theInteger = [willingToPayTxtField.text intValue] + [expenseTxtField.text intValue];
        NSString *total = [NSString stringWithFormat:@"%d",theInteger];
        toatlTxtField.text = total;
        
    }
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)previous{
    /*
    NSString *helpDate = dateTxtField.text;
    
    NSString *strdata;
    //int *expense = 0;
    
    
    if([expenseTxtField.text isEqualToString:@""])
    {
        expenseTxtField.text =@"0";
    }
    
    NSString *O_R_Type;
    
    
    if([userType isEqualToString:@"Helper"])
    {
        O_R_Type = @"Offer";
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        O_R_Type = @"Request";
    }
    
    //  NSLog(@"Time-Line=== %@",jobTxtField.titleLabel.text);
    if([transType isEqualToString:@"edit"])
    {
        
        NSString *urDateString=helpDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
        NSDate *dateString = [dateFormatter dateFromString:strDate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
        NSLog(@"%@",formattedDateString);
        
        
        strdata =[NSString stringWithFormat:@"{\"Tans_ID\":\"%@\",\"User_ID\":\"%@\",\"Job_Req_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"\"}",transId,seekerIdString,formattedDateString,@"",jobTxtField.text,@"",reachoutTxtView.text,willingToPayTxtField.text,oneTxtFiels.text,expenseTxtField.text,toatlTxtField.text,@""];
        
        
    }
    
    else{
        
        
        strdata =[NSString stringWithFormat:@"{\"User_ID\":\"%@\",\"User_Type\":\"%@\",\"Job_Req_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"User_Talent_Id\":\"%@\",\"Seeker_Id\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Complete_Comments\":\"%@\",\"O_R_Type\":\"%@\",\"O_R_Status\":\"%@\"}",
                  helperID,userType,helpDate,@"",jobTxtField.text,reachoutTxtView.text,helperTalentId,userID,willingToPayTxtField.text,oneTxtFiels.text,expenseTxtField.text,toatlTxtField.text,@"",@"",O_R_Type,@"Open"];
        
        
    }
    
    [self checkWebService:strdata];
    
*/

}
- (IBAction)windiwBtnAction:(id)sender {
    
    [self performSegueWithIdentifier:@"HelperAvalibility" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"HelperAvalibility"]) {
    
        UserAvailTableVCon *userAvail= segue.destinationViewController;
        userAvail.selectedHelperId=helperID;
        
      
    }


}
- (IBAction)reachOutAction:(id)sender {
    
    
    NSLog(@"%@",willingToPayTxtField.text);
    if ([willingToPayTxtField.text isEqualToString:@"0"]) {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter How much you are willing to pay" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }
    
    else{
    NSLog(@"%@",helperTalentId);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *requrl;
    //NSString *posttring;
    //NSMutableDictionary *Response;
    //NSData *responseData;
    
    NSString *helpDate = dateTxtField.text;
    NSString *O_R_Type;
    
    
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    if([userType isEqualToString:@"Helper"])
    {
        O_R_Type = @"Offer";
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        O_R_Type = @"Request";
    }
    
    
    requrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateSeekerTransServlet"]];
    //    NSString *seekerTransID= @"2";
    //    NSString *Time_Line= @"";
    //    NSString *UOM=@"";
    //    NSString *HelperTalentId=@"";
    //     //NSString *HelperId=@"";
    //    NSString *seekerFeedback=@"";
    //    NSString *quantity=@"1";
    //    NSString *Helper_Feedback=@"";
    //    NSString *Offer_Type=@"";
    //    NSString *jobCompletedComments=@"";
    //    NSString *status= @"Reuest Open";
    
    if ([expenseTxtField.text isEqualToString:@""]) {
        expenseTxtField.text=0;
    }
    NSLog(@"%@",expenseTxtField.text);
    
    NSString *strdata;
    
    
    
    //    posttring =[NSString stringWithFormat:@"{\"Sek_User_Id\":\"%@\",\"Required_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"User_Talent_Id\":\"%@\",\"Help_Trans_ID\":\"%@\",\"Asking_Price\":\"%@\",\"Helper_Feedback\":\"%@\",\"Required_Date_Type\":\"%@\",\"Offer_Type\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Status\":\"%@\"}",userID,dateTxtField.text,Time_Line,UOM,reachoutTxtView.text,talentId,helperID,willingToPayTxtField.text,Helper_Feedback,specificDateTxtField.text,Offer_Type,oneTxtFiels.text,expenseTxtField.text,toatlTxtField.text,status];
    //
    
    //    NSString *urDateString=dateTxtField.text;
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    //
    //    NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    //    NSDate *dateString = [dateFormatter dateFromString:strDate];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
    //    NSLog(@"%@",formattedDateString);
    
    
    
    if([transType isEqualToString:@"edit"])
    {
        
        NSString *urDateString=helpDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
        NSDate *dateString = [dateFormatter dateFromString:strDate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
        NSLog(@"%@",formattedDateString);
        
       
        strdata =[NSString stringWithFormat:@"{\"Tans_ID\":\"%@\",\"User_ID\":\"%@\",\"Job_Req_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"\",\"jobreq_Datetype\":\"%@\"}",transId,seekerIdString,formattedDateString,@"",jobTxtField.text,reachoutTxtView.text,willingToPayTxtField.text,oneTxtFiels.text,expenseTxtField.text,toatlTxtField.text,specificDateTxtField];
        
        
    }
    else
    {
    strdata =[NSString stringWithFormat:@"{\"User_ID\":\"%@\",\"User_Type\":\"%@\",\"Job_Req_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"User_Talent_Id\":\"%@\",\"Seeker_Id\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Complete_Comments\":\"%@\",\"O_R_Type\":\"%@\",\"O_R_Status\":\"%@\",\"jobreq_Datetype\":\"%@\"}",
              helperID,userType,dateTxtField.text,@"",jobTxtField.text,reachoutTxtView.text,helperTalentId,userID,willingToPayTxtField.text,oneTxtFiels.text,expenseTxtField.text,toatlTxtField.text,@"",@"",O_R_Type,@"Open",specificDateTxtField.text];
    }
    [self checkWebService:strdata];
    
    //    NSString *msgLength = [NSString stringWithFormat:@"%d", [posttring length]];
    //    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:requrl];
    //    [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    //    [theRequest setHTTPMethod:@"POST"];
    //    [theRequest setHTTPBody: [posttring dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //    NSHTTPURLResponse *response = nil;
    //    NSError *error = nil;
    //    responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    //    if (!responseData)
    //    {
    //        NSLog(@"Download Error: %@", error.localizedDescription);
    //
    //    }
    //**************************************    AFTER GETTING RESPONSE    *******************************************
    //
    //    else{
    //        NSError *error1;
    //
    //        NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //
    //        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error1];
    //        [self Stop];
    //        if ([[jsonArray objectForKey:@"info"] isEqualToString:@"Successfully Inserted Seeker Trans to DB" ]) {
    //            UIAlertView *update = [[UIAlertView alloc]initWithTitle:@"" message:@"Request sent sucessfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //            [self.navigationController popViewControllerAnimated:YES];
    //            [update show];
    //
    //        }
    //        else{
    //
    //        }
    //
    //
    //
    //
    //        NSLog(@"%@", Response);
    //
    //
    //    }
    }
    
}
- (void) checkWebService:(NSString *)strBody {
    
    NSString *serviceString;
    NSString *strdata = strBody;
    
    //serviceString=@"http://192.168.0.158:8080/TymBoxWeb/CreateHelperTrasactionServlet";
    NSString *msg;
    
    if([transType isEqualToString:@"edit"])
    {
        serviceString = @"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateTransMasterDetailServlet";
        msg=@"Request Updated";
    }
    else{
        serviceString = @"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateTymboxTransServlet";
        msg=@"Request Created";
    }
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *requestData = [strdata dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *escapedUrlString = [serviceString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:escapedUrlString];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody: requestData];
    [theRequest setHTTPMethod:@"POST"];
    
    
    
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
    
    if ([[jsonDictionary objectForKey:@"info"] rangeOfString:@"Success"].location != NSNotFound) {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
        [self Stop];
        [self.navigationController popViewControllerAnimated:YES];
    }else if([[jsonDictionary objectForKey:@"info"] rangeOfString:@"Failure"].location != NSNotFound)
    {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Problem with Server" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
        [self Stop];
    }
    
}
-(void)Stop{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
