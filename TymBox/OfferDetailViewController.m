//
//  OfferDetailViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/30/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "MBProgressHUD.h"
#import "TransDetObj.h"
#import "CounterHistoryTableView.h"
@interface OfferDetailViewController ()
{
    NSDictionary *jsonArray;
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;
    NSMutableArray *seekerNameArray;
    NSString *userId;
    NSString *helperName;
    NSString *userTalentId;
    NSString *status;
    UIPickerView * pickerView;
    UIView  *pickerParentView ;
    NSArray *morningArray;
    NSArray *hoursArray;
    NSString *userType;
    NSString *selectedTab;
    NSString *transMastid;
    NSString *transUserId;
    NSString *selectedHelperId;
    NSMutableArray *detArray;
    UIBarButtonItem *eng_btn;
    NSString *alertMessage;
    
    TransDetObj *selectedDetObj;
}
@end

@implementation OfferDetailViewController
@synthesize cancelJob,resheduleJob,repriceJOb,scrollView,dateTxtField,helperlabel,talentLabel,helperTransactionArray,priceTxtField,expenseTxtField,oneTxtField,totalTxtField,offerDetailTxtView,commitment,acceptBtn,declineBtn,counterBtn,onSpecificDatetxtField,jobTxtField,selectedObj,ULabel,counter,jobCompleteBtn,comingFromCounter;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
    helperName=[userInfoDic valueForKey:@"userName"];
    helperlabel.text=helperName;
    
    
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    if([userType isEqualToString:@"Helper"])
    {
        selectedTab = @"Offer";
        
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        selectedTab = @"Offer";
    }
    
    NSLog(@"%@",helperTransactionArray);
    
    NSLog(@"%@",commitment);
    transMastid = [NSString stringWithFormat:@"%@",selectedObj.transId];
    transUserId = [NSString stringWithFormat:@"%@",selectedObj.userId];
    
    helperlabel.text = [NSString stringWithFormat:@"%@",selectedObj.userName];
    if([userType isEqualToString:@"Helper"])
    {
        ULabel.text= @"Seeker";
        helperlabel.text = selectedObj.seekerName;
        
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        
        ULabel.text= @"Helper";
        
        helperlabel.text = selectedObj.userName;
    }
    TransDetObj *detObj = [[TransDetObj alloc]init];
    
    detArray = [[NSMutableArray alloc]init];
    
    detArray = selectedObj.detArray;
    
    detObj = [detArray objectAtIndex:0];
    selectedDetObj = [detArray objectAtIndex:0];
    
    priceTxtField.text = [NSString stringWithFormat:@"%@",detObj.price];
    NSLog(@"%@",detObj.price);
    //rateTypeTxt.text = [NSString stringWithFormat:@"%@",rateType];
    onSpecificDatetxtField.text=[NSString stringWithFormat:@"%@",selectedObj.Date_Type];
    selectedHelperId = [NSString stringWithFormat:@"%@",selectedObj.userId];
    talentLabel.text =[NSString stringWithFormat:@"%@",selectedObj.user_Talent_Name];
    expenseTxtField.text = [NSString stringWithFormat:@"%@",detObj.expense];
    totalTxtField.text = [NSString stringWithFormat:@"%@",detObj.total];
    oneTxtField.text = [NSString stringWithFormat:@"%@",detObj.quantity];
    morningArray = [[NSArray alloc] initWithObjects:@"By a specific date",@"On a specific date", nil];
    hoursArray = [[NSArray alloc] initWithObjects:@"Hours",@"Day",@"One Job", nil];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateNotFormatted = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",selectedObj.job_Req_Date]];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSString * dateFormatted = [dateFormatter stringFromDate:dateNotFormatted];
    
    dateTxtField.text = dateFormatted;
    
    onSpecificDatetxtField.text = [morningArray objectAtIndex:0];
    jobTxtField.text = [hoursArray objectAtIndex:0];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotificatio:) name:@"getUserTalentId" object:nil];
    
    
    // Rama Code
    
    NSLog(@"selectedObj====%@",selectedObj);
    
    
    [offerDetailTxtView.layer setBorderColor:[[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.5] CGColor]];
    [offerDetailTxtView.layer setBorderWidth:1.0f];
    
    //The rounded corner part, where you specify your view's corner radius:
    offerDetailTxtView.layer.cornerRadius = 8.0f;
    offerDetailTxtView.clipsToBounds = YES;
    
    // Rama Code
    //  [self updateUI];
    
    scrollView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(320, 1005)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"Calender" object:nil];
    // Do any additional setup after loading the view.
}

- (void)history:(id)sender
{
    [self performSegueWithIdentifier:@"CounterHistory" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CounterHistory"]) {
        CounterHistoryTableView *vc = (CounterHistoryTableView *)[[segue destinationViewController] topViewController];
        
        
        vc.counterObj=selectedObj;
        
    }
    
}

- (IBAction)quantityTxtAction:(id)sender {
    
    [self calculate];
}
- (IBAction)priceTxtAction:(id)sender {
    
    [self calculate];
}
- (IBAction)expenseTxtAction:(id)sender {
    
    [self calculate];
}

- (IBAction)onSpecificBtnAction:(id)sender {
    
    [onSpecificDatetxtField becomeFirstResponder];
    pickerView = [[UIPickerView alloc] init];
    pickerView.tag=0;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor whiteColor];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolBar setItems:[NSArray arrayWithObjects: flexible, doneButton, nil]];
    //pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
    //[pickerParentView addSubview:pickerView];
    //[pickerParentView addSubview:toolBar];
    
    onSpecificDatetxtField.inputView = pickerView;
    
}


- (IBAction)jobPickBtnAction:(id)sender {
    
    
    [jobTxtField becomeFirstResponder];
    pickerView = [[UIPickerView alloc] init];
    pickerView.tag=3;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor whiteColor];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolBar setItems:[NSArray arrayWithObjects: flexible, doneButton, nil]];
    //pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
    //[pickerParentView addSubview:pickerView];
    //[pickerParentView addSubview:toolBar];
    
    jobTxtField.inputView = pickerView;
    //jobTxtField.inputAccessoryView = toolBar;
    //[jobTxtField becomeFirstResponder];
    
}

- (void) incomingNotification:(NSNotification *)notification{
    NSString *theString = [notification object];
    NSLog(@"%@",theString);
    dateTxtField.text = theString;
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [btn setTitle:@"History" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 26, 25)];
    //    btn.backgroundColor= [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"history-but.png"]];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"history-but.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setRightBarButtonItem:eng_btn];
    
    if ([comingFromCounter isEqualToString:@"YES"]) {
        
        //       self.navigationItem.rightBarButtonItem.enabled = NO;
        //      self.navigationItem.rightBarButtonItem.title = @"";
        
    }
    
    else{
        [self.navigationItem.rightBarButtonItem.customView setAlpha:0.0];
        
    }
    
    
    if ([commitment isEqualToString:@"Commitment"]) {
        self.title=@"Accepted Offer";
        counterBtn.alpha = 0;
        acceptBtn.alpha = 0;
        declineBtn.alpha = 0;
        
        resheduleJob.alpha = 1;
        repriceJOb.alpha = 1;
        cancelJob.alpha = 1;
        jobCompleteBtn.alpha=1;
        
    }
    
    else{
        
        counterBtn.alpha = 1;
        acceptBtn.alpha = 1;
        declineBtn.alpha = 1;
        
        resheduleJob.alpha = 0;
        repriceJOb.alpha = 0;
        cancelJob.alpha = 0;
        jobCompleteBtn.alpha=0;
    }
    
}
-(void)updateUI{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        //          dateTxtField.text=[helperTransactionArray valueForKey:@"jobDate"];
        //
        //
        //          priceTxtField.text=[helperTransactionArray valueForKey:@"offerPrice"];
        //          expenseTxtField.text= [helperTransactionArray valueForKey:@"expense"];
        //          oneTxtField.text= [helperTransactionArray valueForKey:@"quantity"];
        //          totalTxtField.text=[helperTransactionArray valueForKey:@"transTotal"];
        //          talentLabel.text= [helperTransactionArray valueForKey:@"talent_name"];
        //          userTalentId= [helperTransactionArray valueForKey:@"userTalentId"];
        //        status= [helperTransactionArray valueForKey:@"status"];
        //        if ([helperTransactionArray valueForKey:@"expenseComments"]) {
        //            offerDetailTxtView.text= [helperTransactionArray valueForKey:@"expenseComments"];
        //        }
        transMastid = [NSString stringWithFormat:@"%@",selectedObj.transId];
        transUserId = [NSString stringWithFormat:@"%@",selectedObj.userId];
        TransDetObj *detObj = [[TransDetObj alloc]init];
        
        NSMutableArray *detArray1 = [[NSMutableArray alloc]init];
        
        detArray1 = selectedObj.detArray;
        
        detObj = [detArray1 objectAtIndex:0];
        priceTxtField.text = [NSString stringWithFormat:@"%@",detObj.price];
        //rateTypeTxt.text = [NSString stringWithFormat:@"%@",rateType];
        // selectedHelperId = [NSString stringWithFormat:@"%@",selectedObj.userId];
        talentLabel.text =[NSString stringWithFormat:@"%@",selectedObj.user_Talent_Name];
        expenseTxtField.text = [NSString stringWithFormat:@"%@",detObj.expense];
        totalTxtField.text = [NSString stringWithFormat:@"%@",detObj.total];
        oneTxtField.text = [NSString stringWithFormat:@"%@",detObj.quantity];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * dateNotFormatted = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",selectedObj.job_Req_Date]];
        [dateFormatter setDateFormat:@"MM/dd/YYYY"];
        NSString * dateFormatted = [dateFormatter stringFromDate:dateNotFormatted];
        
        dateTxtField.text = dateFormatted;
        offerDetailTxtView.text = [NSString stringWithFormat:@"%@",selectedObj.reach_Out_Message];
        jobTxtField.text = [NSString stringWithFormat:@"%@",selectedObj.UOM];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });
    
    
}
- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==1){
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"showCalender" sender:self];
        // textField.keyboardType=NO;
    }
    
    else if (textField.tag==0 || textField.tag == 3 ){
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.tag=textField.tag;
        [pickerView setDataSource: self];
        [pickerView setDelegate: self];
        pickerView.showsSelectionIndicator = YES;
        pickerView.backgroundColor = [UIColor whiteColor];
        // perTxtField.inputView = pickerView;
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        //        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutData)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        //        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearData)];
        [toolBar setItems:[NSArray arrayWithObjects: flexible, doneButton, nil]];
        // perTxtField.inputAccessoryView = toolBar;
        pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
        [pickerParentView addSubview:pickerView];
        [pickerParentView addSubview:toolBar];
        
        
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
        onSpecificDatetxtField.text = [morningArray objectAtIndex:row];
    }
    else{
        jobTxtField.text = [hoursArray objectAtIndex:row];
    }
    
    //Write the required logic here that should happen after you select a row in Picker View.
}
-(void)pickerDoneClicked:(id)sender{
    
    [pickerParentView removeFromSuperview];
    // [MorningTxtField resignFirstResponder];
    [jobTxtField resignFirstResponder];
    [onSpecificDatetxtField resignFirstResponder];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*
    if (textField.tag==4 || textField.tag==5) {
        int theInteger = [priceTxtField.text intValue] + [expenseTxtField.text intValue];
        NSString *total = [NSString stringWithFormat:@"%d",theInteger];
        totalTxtField.text = total;
        
    }
    */
}
- (IBAction)declineBtnAction:(id)sender {
    alertMessage=@"You Declined the offer";
    status=@"Decline";
    [self hitMan:status];
}

- (IBAction)quantityChangedAction:(id)sender {
    [self calculate];
}

- (IBAction)rateChangedAction:(id)sender {
    [self calculate];
}
- (IBAction)expenseChangedAction:(id)sender {
    [self calculate];
}

-(void) calculate{
    int ratePer = 0;
    int rate = 0;
    int expence = 0;
    
    if(![oneTxtField.text isEqualToString:@""])
    {
        ratePer = [oneTxtField.text intValue];
    }
    
    if(![priceTxtField.text isEqualToString:@""])
    {
        rate = [priceTxtField.text intValue];
    }
    
    if(![expenseTxtField.text isEqualToString:@""])
    {
        expence = [expenseTxtField.text intValue];
    }
    int total = (ratePer * rate) + expence;
    
    totalTxtField.text = [NSString stringWithFormat:@"%d",total];
}

- (IBAction)counterBtnAction:(id)sender {
    
    alertMessage=@"You countered an open offer";
    status= @"Counter";
    if([expenseTxtField.text isEqualToString:@""])
    {
        expenseTxtField.text =@"0";
    }
    
    
    NSString *errorStr = [NSString new];
    if(oneTxtField.text.length == 0 || [oneTxtField.text isEqualToString:@"0"] ){
        errorStr = [errorStr stringByAppendingString:@"\nQuantity can't be zero (0) .."];
        
        
    }else if(priceTxtField.text.length == 0 || [priceTxtField.text isEqualToString:@"0"])
    {
        errorStr = [errorStr stringByAppendingString:@"\nPrice can't be zero (0) .."];
        
    }
    
    if(errorStr.length > 0)
    {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:errorStr delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
        return;
    }
    
    NSLog(@"selectedDetObj===%@",selectedDetObj);
    
    NSString *oldTotal = [NSString new];
    oldTotal = [NSString stringWithFormat:@"%@",selectedDetObj.total];
    if([oldTotal isEqualToString:totalTxtField.text])
    {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"You haven't changed any fields." delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }else{
        
        NSString *strdata =[NSString stringWithFormat:@"{\"Tans_ID\":\"%@\",\"userId\":\"%@\",\"O_R_Status\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Complete_Comments\":\"%@\",\"jobreq_Datetype\":\"%@\"}",transMastid,userId,status,priceTxtField.text,oneTxtField.text,expenseTxtField.text,totalTxtField.text,@"test",@"",onSpecificDatetxtField.text];
        
        [self checkWebService:strdata];
        
    }
    
}
-(void)Stop{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void) hitMan:(NSString *)status1{
    NSInteger success = 0;
    @try {
        
        
        NSString *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateTymboxTransaction?status=%@&userId=%@&transId=%@&HelperId=%@&jobRequiredDate=%@&timLine=%@",status1,userId,transMastid,selectedObj.userId,selectedObj.job_Req_Date,selectedObj.time_Line];
        
        
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
        NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
        
        NSLog(@"responseCode====%@",responseCode);
        NSLog(@"~~~~~ Status code: %ld", (long)[response statusCode]);
        
        if([respData length]<=2)
        {
            [self alertStatus:@"Sign in Failed." :@"Error!" :0];
        }
        
        else if(respData != nil){
            
            if ([response statusCode] >= 200 && [response statusCode] < 300) {
                
                NSDictionary *jsonDictionary;
                jsonDictionary = [NSJSONSerialization JSONObjectWithData:respData options:kNilOptions error:&error];
                
                if (jsonDictionary == nil) {
                    NSLog(@"JSON Error: %@", error);
                }
                
                if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Db Updated"]) {
                    
                    //UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    //[alert1 show];
                    
                    [self alertStatus:@"" :alertMessage :0];
                    
                }else if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"fail"]) {
                    
                    UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Problem with Server" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert1 show];
                }
                
            }else
            {
                
                
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
                
            }
            
        }else
        {
            
            [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    if (success) {
        [self performSegueWithIdentifier:@"loggedInUser" sender:self];
    }
    
    
    
}
- (IBAction)acceptBtnAction:(id)sender {
    alertMessage= @"You accepted the offer";
    status = @"Accept";
    [self hitMan:status];
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}
- (IBAction)sendUpdateBtnAction:(id)sender {
    if([expenseTxtField.text isEqualToString:@""])
    {
        expenseTxtField.text =@"0";
    }
    
    
    
    NSString *strdata =[NSString stringWithFormat:@"{\"Tans_ID\":\"%@\",\"userId\":\"%@\",\"O_R_Status\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Complete_Comments\":\"%@\"}",transMastid,userId,status,priceTxtField.text,oneTxtField.text,expenseTxtField.text,totalTxtField.text,@"test",@""];
    
    //NSString *strdata =[NSString stringWithFormat:@"{\"Tans_ID\":\"%@\",\"userId\":\"%@\",\"User_Type\":\"%@\",\"Job_Req_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"User_Talent_Id\":\"%@\",\"Seeker_Id\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Complete_Comments\":\"%@\",\"O_R_Type\":\"%@\",\"O_R_Status\":\"%@\"}",transMastid,transUserId,selectedMenu,helpDate,button.titleLabel.text,jobBtn.titleLabel.text,commentsTxt.text,selectedTalentId,seekerIdString,retetxt.text,ratePertxt.text,expensestxt.text,totaltxt.text,@"",@"",O_R_Type,@"Open"];
    
    [self checkWebService:strdata];
    
    /*
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     NSString *dateString = dateTxtField.text;
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSDate *date = [dateFormatter dateFromString:dateString];
     
     
     [dateFormatter setDateFormat:@"MM/dd/yyyy"];
     NSString *newDateString = [dateFormatter stringFromDate:date];
     
     
     NSURL *requrl;
     NSString *posttring;
     NSMutableDictionary *Response;
     NSData *responseData;
     //    requrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.158:8080/TymBoxWeb/CreateHelperTrasactionServlet"]];
     NSString *seekerTransID= [helperTransactionArray valueForKey:@"seekerTransId"];
     NSString *helperUserId= userId;
     
     NSString *seekerFeedback=[helperTransactionArray valueForKey:@"seekerFeedback"];
     
     //userTalentId=@"3";
     
     NSString *helperReachoutMsg=[helperTransactionArray valueForKey:@"helperReachOutMsg"];
     
     NSString *jobCompletedComments=[helperTransactionArray valueForKey:@"jobCompleteComments"];
     
     requrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.158:8080/TymBoxWeb/CreateHelperTrasactionServlet"]];
     posttring =[NSString stringWithFormat:@"{\"Sek_Trans_ID\":\"%@\",\"Hlp_User_ID\":\"%@\",\"User_Talent_ID\":\"%@\",\"Status\":\"%@\",\"Seeker_Feedback\":\"%@\",\"Quantity\":\"%@\",\"Offer_Price\":\"%@\",\"Expense\":\"%@\",\"Transaction_Total\":\"%@\",\"Helper_Reach_Out_Msg\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Date\":\"%@\",\"Job_Complete_Comments\":\"%@\"}",seekerTransID,helperUserId,userTalentId,status,seekerFeedback,oneTxtField.text,priceTxtField.text,expenseTxtField.text,totalTxtField.text,helperReachoutMsg,offerDetailTxtView.text,newDateString,jobCompletedComments];
     
     NSString *msgLength = [NSString stringWithFormat:@"%d", [posttring length]];
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
     NSLog(@"JSON Error: %@", error);
     }
     
     else{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
     if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Successfully Inserted to DB"]) {
     
     UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Offer updated sucessfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
     [alert1 show];
     [self.navigationController popViewControllerAnimated:YES];
     }
     
     
     }
     
     */
    
}
- (void) checkWebService:(NSString *)strBody {
    
    NSString *serviceString;
    NSString *strdata = strBody;
    //http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentWise?talentId=11
    
    serviceString=@"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateTymboxTransDetail";
    
    
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
    // msg=@"You accepted the offer";
    // msg= [NSString stringWithFormat:<#(NSString *), ...#>]
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
        
        
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }else if([[jsonDictionary objectForKey:@"info"] rangeOfString:@"Failure"].location != NSNotFound)
    {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Problem with Server" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }
    
    /*
     if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Successfully Inserted to DB"]) {
     
     UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
     [alert1 show];
     }else if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"DB Failure"]) {
     
     UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Problem with Server" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
     [alert1 show];
     }
     */
    
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
    }
    else
    {
        NSLog(@"ok");
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    //}
}

- (IBAction)jobCompleteBtnAction:(id)sender {
    
    status=@"Complete";
    alertMessage=@"You completed the Job";
    [self hitMan:status];
}
@end
