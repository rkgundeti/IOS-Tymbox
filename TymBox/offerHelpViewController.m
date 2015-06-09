//
//  offerHelpViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/23/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "offerHelpViewController.h"
#import "offerHelpTalentsTableViewController.h"
#import "UserAvailTableVCon.h"
#import "CKCalendarView.h"
#import "SACalendar.h"
#import "offerAvavlibilityTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "TransDetObj.h"
#import "TransDetObj.h"
@interface offerHelpViewController ()<CKCalendarDelegate>
{
    NSString *check;
    UIPickerView * pickerView;
    UIView  *pickerParentView ;
    NSArray *morningArray;
    NSArray *hoursArray;
    NSString *userTalentId;
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;
    NSDictionary *jsonArray;
    NSString *userId;
    NSString *selectedSeekerId;
    NSString *userType;
     NSString *transId;
    NSString  *seekerIdString;
    NSString  *selectedTalentId;
    NSString *userName;
    NSString *transID;
    NSString *tymboxWindowDate;
    
}
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@end

@implementation offerHelpViewController
@synthesize scrollView,talentTxtField,seekerTxtField,MorningTxtField,hoursTxtField,checkLabel,calnderBtn,helpWhenTxtField,costTxtField,expenseTxtField,totalTxtField,postCommentsTxtView,transType,selectedObj,getHelperId,ReceivedDictionary,offObject,oneTxtField;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",getHelperId);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RequestAvailNotification:) name:@"RequestAvail" object:nil];
    seekerTxtField.text=getHelperId;
    self.title= @"Offer Help";
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[[userInfoDic valueForKey:@"userId"] stringValue];
    userName=[userInfoDic valueForKey:@"userName"];
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    if([userType isEqualToString:@"Helper"])
    {
        
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        
    }
    
    if (ReceivedDictionary) {
        
     
        userTalentId= [NSString stringWithFormat:@"%@",[ReceivedDictionary valueForKey:@"UserTalentId"]];
        talentTxtField.text= [ReceivedDictionary valueForKey:@"TalentName"];
        selectedSeekerId = [NSString stringWithFormat:@"%@",[ReceivedDictionary valueForKey:@"SelectedSeekerId"]];
        seekerTxtField.text= [ReceivedDictionary valueForKey:@"SelectedSeekerName"];
        costTxtField.text=[ReceivedDictionary valueForKey:@"rate"];
        totalTxtField.text=[ReceivedDictionary valueForKey:@"rate"];
       
    }
    
    else if (offObject) {
        seekerTxtField.text= offObject.selectedUserName;
        costTxtField.text= [NSString stringWithFormat:@"%@", offObject.talentRate];
        totalTxtField.text=[NSString stringWithFormat:@"%@", offObject.talentRate];
        talentTxtField.text= offObject.selectedTalentName;
        
        userTalentId= [NSString stringWithFormat:@"%@", offObject.selectedTalentId];
        
        selectedSeekerId = [NSString stringWithFormat:@"%@", offObject.selectedUserId];
        
          }
    
   
  
   
    
    expenseTxtField.text=0;

    //To make the border look very close to a UITextField
    [postCommentsTxtView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [postCommentsTxtView.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    postCommentsTxtView.layer.cornerRadius = 5;
    postCommentsTxtView.clipsToBounds = YES;
    
    self.expenseTxtField.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"Calender" object:nil];

    morningArray = [[NSArray alloc] initWithObjects:@"Morning",@"Afternoon",@"Evening", nil];
     hoursArray = [[NSArray alloc] initWithObjects:@"Hours",@"Day",@"One Job", nil];
   [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(320, 1005)];
    
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:nextDate];
    NSLog(@"%@",formattedDateString);
    
    NSLog(@"nextDate: %@ ...", nextDate);
    
    tymboxWindowDate = formattedDateString;
    //helpWhenTxtField.text=formattedDateString;
    
    NSString *urDateString=formattedDateString;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];

    NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    NSDate *dateString = [dateFormatter dateFromString:strDate];
    
    [dateFormatter setDateFormat:@"MMMM-dd-yyyy"];
    NSString *formattedDateString1 = [dateFormatter stringFromDate:dateString];
    NSLog(@"%@",formattedDateString1);
    helpWhenTxtField.text=formattedDateString1;
//    NSString *urDateString=nextDate;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
//    NSDate *dateString = [dateFormatter dateFromString:strDate];
//    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
//    NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
//    NSLog(@"%@",formattedDateString);
    
    if([transType isEqualToString:@"edit"])
    {
        
        NSLog(@"selectedobj====%@",selectedObj);
        transId = selectedObj.transId;
        seekerIdString=selectedObj.seekerId;
       seekerTxtField .text = selectedObj.seekerName;
        
        talentTxtField.text = selectedObj.user_Talent_Name;
        
        
        selectedTalentId = selectedObj.user_Talent_Id;
        
        seekerTxtField.enabled = false;
        talentTxtField.enabled = false;
        
        TransDetObj *transDet = [[TransDetObj alloc]init];
        transDet = [selectedObj.detArray objectAtIndex:0];
        costTxtField.text = [NSString stringWithFormat:@"%@",transDet.price];
        
        hoursTxtField.text =selectedObj.UOM ;
        expenseTxtField.text = [NSString stringWithFormat:@"%@",transDet.expense];
       // on.text = [NSString stringWithFormat:@"%@",transDet.quantity];
        
        
        NSString *urDateString=selectedObj.job_Req_Date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
        NSDate *dateString = [dateFormatter dateFromString:strDate];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
        NSLog(@"%@",formattedDateString);
        
        [dateFormatter setDateFormat:@"MMMM-dd-yyyy"];
        NSString *formattedDateString1 = [dateFormatter stringFromDate:dateString];
        NSLog(@"%@",formattedDateString1);
        
        helpWhenTxtField.text = formattedDateString;
        
        [self calculate];
    }
    //scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
      // Do any additional setup after loading the view.
}
- (void) RequestAvailNotification:(NSNotification *)notification {
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    NSString *urDateString=[theString objectForKey:@"Date"];
    tymboxWindowDate=[theString objectForKey:@"Date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    NSDate *dateString = [dateFormatter dateFromString:strDate];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
    NSLog(@"%@",formattedDateString);
    
    [dateFormatter setDateFormat:@"MMMM-dd-yyyy"];
    NSString *formattedDateString1 = [dateFormatter stringFromDate:dateString];
    NSLog(@"%@",formattedDateString1);
    
    //NSLog(@"date====%@",date);
    //NSDateFormatter* dateFormatterComp = [[NSDateFormatter alloc] init];
    //dateFormatterComp.dateFormat = @"MM-dd-yyyy";
    //NSString *compareDate = [NSString stringWithFormat:@"%@",[dateFormatterComp dateFromString:[theString objectForKey:@"Date"]]];
    
    helpWhenTxtField.text = formattedDateString1;
    //button.titleLabel.text = [theString objectForKey:@"Time"];
    
   
    MorningTxtField.text=[theString objectForKey:@"Time"];
    
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self animateTextField: textField up: NO];
//}
- (IBAction)ratetxtEndAction:(id)sender {
    
    [self calculate];
    
}
- (IBAction)quantityChangedAction:(id)sender {
    [self calculate];
}

- (IBAction)expencetxtEndAction:(id)sender {
    
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
    
    if(![costTxtField.text isEqualToString:@""])
    {
        rate = [costTxtField.text intValue];
    }
    
    if(![expenseTxtField.text isEqualToString:@""])
    {
        expence = [expenseTxtField.text intValue];
    }
    int total = (ratePer * rate) + expence;
    
    totalTxtField.text = [NSString stringWithFormat:@"%d",total];
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
//-(void) calculate{
//    int ratePer = 1;
//    int rate = 0;
//    int expence = 0;
////    
////    if(![ratePertxt.text isEqualToString:@""])
////    {
////        ratePer = [ratePertxt.text intValue];
////    }
//    
//    if(![costTxtField.text isEqualToString:@""])
//    {
//        rate = [costTxtField.text intValue];
//    }
//    
//    if(![expenseTxtField.text isEqualToString:@""])
//    {
//        expence = [expenseTxtField.text intValue];
//    }
//    int total = (ratePer * rate) + expence;
//    
//    totalTxtField.text = [NSString stringWithFormat:@"%d",total];
//}
- (void) incomingNotification:(NSNotification *)notification{
    NSString *theString = [notification object];
    NSLog(@"%@",theString);
    //helpWhenTxtField.text = theString;
    
  //  NSString *urDateString=theString;
    tymboxWindowDate=theString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   // NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *dateString = [dateFormatter dateFromString:theString];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
    NSLog(@"%@",formattedDateString);
    
    tymboxWindowDate=formattedDateString;
    
    [dateFormatter setDateFormat:@"MMMM-dd-yyyy"];
    NSString *formattedDateString1 = [dateFormatter stringFromDate:dateString];
    NSLog(@"%@",formattedDateString1);
    
    //NSLog(@"date====%@",date);
    //NSDateFormatter* dateFormatterComp = [[NSDateFormatter alloc] init];
    //dateFormatterComp.dateFormat = @"MM-dd-yyyy";
    //NSString *compareDate = [NSString stringWithFormat:@"%@",[dateFormatterComp dateFromString:[theString objectForKey:@"Date"]]];
    
    helpWhenTxtField.text = formattedDateString1;
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd/yyyy"];
    
    //NSString *strDate = [theString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    NSDate *dateString1 = [dateFormatter1 dateFromString:theString];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDateString2 = [dateFormatter1 stringFromDate:dateString1];
    NSLog(@"%@",formattedDateString2);
    
   // tymboxWindowDate=formattedDateString2;
    //button.titleLabel.text = [theString objectForKey:@"Time"];
    
    
   // MorningTxtField.text=[theString objectForKey:@"Time"];
 
}
- (IBAction)helpWithWhatAtion:(id)sender {
    [self performSegueWithIdentifier:@"helperTalents" sender:self];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[offerHelpTalentsTableViewController class]]) {
        offerHelpTalentsTableViewController *colorsViewConroller = segue.sourceViewController;
       if (colorsViewConroller.selectedCategory) {
            talentTxtField.text = colorsViewConroller.selectedCategory;
           userTalentId= colorsViewConroller.selectUserTalentId;
//            checkId = colorsViewConroller.selectedCategoryId;
//            NSLog(@"%@",colorsViewConroller.selectedCategory);
        }
        
       else if (colorsViewConroller.selectedSeeker){
       
           seekerTxtField.text= colorsViewConroller.selectedSeeker;
           selectedSeekerId=colorsViewConroller.selectedSeekerId;
       }
            }
    else if ([segue.sourceViewController isKindOfClass:[offerAvavlibilityTableViewController class]]){
        offerAvavlibilityTableViewController *colorsViewConroller = segue.sourceViewController;
        if (colorsViewConroller.selectedDate) {
            helpWhenTxtField.text = colorsViewConroller.selectedDate;
            //            checkId = colorsViewConroller.selectedCategoryId;
            //            NSLog(@"%@",colorsViewConroller.selectedCategory);
        }
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==21) {
        //textField.keyboardAppearance=uikeyboardapp
           [textField resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGPoint scrollPoint;
//    CGRect inputFieldBounds = [textField bounds];
//    inputFieldBounds = [textField convertRect:inputFieldBounds toView:scrollView];
//    scrollPoint = inputFieldBounds.origin;
//    scrollPoint.x = 0;
//    scrollPoint.y -= 100; // you can customize this value
//    [scrollView setContentOffset:scrollPoint animated:YES];
    
    [self animateTextField: textField up: YES];
    if (textField.tag==20) {
        [textField resignFirstResponder];
          check=@"";
       [self performSegueWithIdentifier:@"helperTalents" sender:self];
    }
    
    else if (textField.tag==21) {
//        offerHelpTalentsTableViewController *colorsViewConroller = [[offerHelpTalentsTableViewController alloc] init];
//        //BOOL check= YES;
//        NSString *check = @"Seek";
//        colorsViewConroller.value= check;
        [textField resignFirstResponder];
       check = @"Seek";
     [self performSegueWithIdentifier:@"helperTalents" sender:self];
        

    }
    
    else if (textField.tag==61 || textField.tag == 51){
        
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
        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearData)];
        [toolBar setItems:[NSArray arrayWithObjects: flexible, doneButton, nil]];
        // perTxtField.inputAccessoryView = toolBar;
        pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
        [pickerParentView addSubview:pickerView];
        [pickerParentView addSubview:toolBar];
       // [self.view addSubview:pickerParentView];
        textField.inputView = pickerParentView;
      }
    else if (textField.tag==10){
        [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"showCalender" sender:self];
       // textField.keyboardType=NO;
    }
    
   // [textField resignFirstResponder];
}
-(void)handleChanging:(id)sender{
    NSLog(@"Hitting");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self animateTextField: textField up: NO];
    if (textField.tag==222 || textField.tag==223) {
        int theInteger = [costTxtField.text intValue] + [expenseTxtField.text intValue];
                NSString *total = [NSString stringWithFormat:@"%d",theInteger];
            totalTxtField.text = total;

    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    if (pickerView.tag == 61){
        return [morningArray count];
    }
    else{
        return [hoursArray count];
    }}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView.tag == 61){
       return [morningArray objectAtIndex:row];
    }
    else{
       return [hoursArray objectAtIndex:row];
    }

}
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//
//{
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 300.0f, 60.0f)]; //x and width are mutually correlated
//    
//    label.textAlignment = NSTextAlignmentLeft;
//    
//    
//    label.text = [morningArray objectAtIndex:row];
//    
//    
//    return label;
//    
//    
//    if (pickerView.tag == 0){
//        return [morningArray objectAtIndex:row];
//    }
//    else{
//        return [hoursArray objectAtIndex:row];    }
//
//    
//}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 61){
    MorningTxtField.text = [morningArray objectAtIndex:row];
    }
    else{
        hoursTxtField.text = [hoursArray objectAtIndex:row];
    }
    
    //Write the required logic here that should happen after you select a row in Picker View.
}
-(void)pickerDoneClicked:(id)sender{
    
    [pickerParentView removeFromSuperview];
   // [MorningTxtField resignFirstResponder];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"helperTalents"]) {
        UINavigationController *navController = segue.destinationViewController;
        offerHelpTalentsTableViewController *photoController = [navController childViewControllers].firstObject;
      
        photoController.value=check;
    }
    
    else if ([[segue identifier] isEqualToString:@"offerHelperAvalibilty"]){
    
        UserAvailTableVCon *navController = segue.destinationViewController;
        //UserAvailTableVCon *photoController = [navController childViewControllers].firstObject;
        navController.actionType = @"User-Avail-Selection";
        navController.selectedHelperId = userId;
    }
    
    // etc...
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animateTextField:textField up:YES];
//    
//    if (textField.tag==55) {
//       // [self calenderButton:nil];
//    }
//}
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
    
    //self.helpwhenbtn.titleLabel.text = [self.dateFormatter stringFromDate:date];
    checkLabel.text = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    
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
    
    //calendar.frame = CGRectMake(10, 10, 300, 320);
    calendar.frame = CGRectMake(self.calnderBtn.frame.origin.x, self.calnderBtn.frame.origin.y - 200, 200, 220);
    [self.view addSubview:calendar];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    //[self.view addSubview:self.dateLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    //[textField resignFirstResponder];
////    if (textField==expenseTxtField) {
////        int theInteger = [costTxtField.text intValue] + [expenseTxtField.text intValue];
////        NSString *total = [NSString stringWithFormat:@"%d",theInteger];
////        totalTxtField.text = total;
////    }
////    else{
////    //[self animateTextField:textField up:NO];
////    }
//}


- (IBAction)tymBoxAction:(id)sender {
    [self performSegueWithIdentifier:@"pickaTymBoxWindow" sender:self];
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
    datePicker.backgroundColor = [UIColor whiteColor];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // NSDate *currentDate = [NSDate date];
    //  NSDate *yesterday = [NSDate dateWithString:@"2009-12-10 00:00:00 +0000"];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:yesterday options:0];
    //  [datePicker setMaximumDate:maxDate];
    
    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setFormatterBehavior:NSDateFormatterBehavior10_4];
    [FormatDate setDateFormat:@"yyyy/MM/dd"];
     UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    // toolBar.tintColor = [UIColor whiteColor];
    toolBar.barStyle=UIBarStyleBlackOpaque;
    [toolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick)];
    //flexSpace.tintColor = [UIColor colorWithRed:89/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f];
    UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelPickerDoneClick)];
    //flexSpace1.tintColor = [UIColor colorWithRed:89/255.0f green:204/255.0f blue:0/255.0f alpha:1.0f];
    [barItems addObject:flexSpace];
    [barItems addObject:flexSpace1];
    
    [toolBar setItems:barItems animated:YES];
    pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
    [pickerParentView addSubview:datePicker];
    [pickerParentView addSubview:toolBar];
    [self.scrollView addSubview:pickerParentView];
    helpWhenTxtField.inputView = pickerParentView;
    
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
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if(textField==nameTextField){
//        [nameTextField resignFirstResponder];
//        
//        //
//    }
//    else if(textField==pickerTextField){
//        
//        ///
//    }
//}

-(void)dateChanged
{
    FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setDateFormat:@"MM"];
}

-(void)DatePickerDoneClick
{
    helpWhenTxtField.text = [FormatDate stringFromDate:[datePicker date]];
    [helpWhenTxtField resignFirstResponder];
    // [self closeDatePicker:self];
}
-(void)CancelPickerDoneClick
{
    [helpWhenTxtField resignFirstResponder];
    //[self closeDatePicker:self];
}

- (IBAction)tapAction:(id)sender {
    [self.scrollView endEditing:YES];
}
- (IBAction)offerHelpButtonAction:(id)sender {
   /* alert = [UIAlertController alertControllerWithTitle:nil
                                                                 message:@"Please wait\n\n\n"
                                                          preferredStyle:UIAlertControllerStyleAlert];
             
                     spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                     spinner.center = CGPointMake(130.5, 65.5);
                     spinner.color = [UIColor blueColor];
                     [spinner startAnimating];
                     [alert.view addSubview:spinner];
                     [self presentViewController:alert animated:NO completion:nil];
    
    
*/
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSURL *requrl;
//    NSString *posttring;
//    NSMutableDictionary *Response;
//    NSData *responseData;
//    NSString *msg;
//    NSString *serviceString;
    
   
//    NSString *seekerTransID= @"2";
//    NSString *helperUserId= userId;
//    NSString *status=@"Open";
//    NSString *seekerFeedback=@"";
   NSString *quantity=@"1";
//    NSString *helperReachoutMsg=@"";
//    NSString *expenseComments=@"";
//    NSString *jobCompletedComments=@"";
//     [[NSNotificationCenter defaultCenter] postNotificationName: @"getUserTalentId" object: userTalentId];
//   
//    posttring =[NSString stringWithFormat:@"{\"Sek_Trans_ID\":\"%@\",\"Hlp_User_ID\":\"%@\",\"User_Talent_ID\":\"%@\",\"Status\":\"%@\",\"Seeker_Feedback\":\"%@\",\"Quantity\":\"%@\",\"Offer_Price\":\"%@\",\"Expense\":\"%@\",\"Transaction_Total\":\"%@\",\"Helper_Reach_Out_Msg\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Date\":\"%@\",\"Job_Complete_Comments\":\"%@\"}",seekerTransID,helperUserId,userTalentId,status,seekerFeedback,quantity,costTxtField.text,expenseTxtField.text,totalTxtField.text,helperReachoutMsg,expenseComments,helpWhenTxtField.text,jobCompletedComments];
    
    
    
     NSString *O_R_Type;
    
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    if([userType isEqualToString:@"Helper"])
    {
        O_R_Type = @"Offer";
        
    }else if([userType isEqualToString:@"Seeker"])
    {
        O_R_Type = @"Request";
    }
   // NSString *quantity1 = @"1";
     NSString *strdata;
   // NSLog(@"Time-Line==%@ === %@",button.titleLabel.text,jobBtn.titleLabel.text);
    if([transType isEqualToString:@"edit"])
    {
        NSString *urDateString=helpWhenTxtField.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *strDate = [urDateString stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
        NSDate *dateString = [dateFormatter dateFromString:strDate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *formattedDateString = [dateFormatter stringFromDate:dateString];
        NSLog(@"%@",formattedDateString);
        
        strdata =[NSString stringWithFormat:@"{\"Tans_ID\":\"%@\",\"User_ID\":\"%@\",\"Job_Req_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"%@\",\"jobreq_Datetype\":\"%@\"}",transId,userId,formattedDateString,MorningTxtField.text,hoursTxtField.text,postCommentsTxtView.text,costTxtField.text,@"1",expenseTxtField.text,totalTxtField.text,@"",@""];
        
    }
    else{
        
      strdata =[NSString stringWithFormat:@"{\"User_ID\":\"%@\",\"User_Type\":\"%@\",\"Job_Req_Date\":\"%@\",\"Time_Line\":\"%@\",\"UOM\":\"%@\",\"Reach_Out_Message\":\"%@\",\"User_Talent_Id\":\"%@\",\"Seeker_Id\":\"%@\",\"Price\":\"%@\",\"Quantity\":\"%@\",\"Expense\":\"%@\",\"Total\":\"%@\",\"Expense_Comments\":\"%@\",\"Job_Complete_Comments\":\"%@\",\"O_R_Type\":\"%@\",\"O_R_Status\":\"%@\",\"jobreq_Datetype\":\"%@\"}",userId,userType,tymboxWindowDate,MorningTxtField.text,hoursTxtField.text,postCommentsTxtView.text,userTalentId,selectedSeekerId,costTxtField.text,quantity,expenseTxtField.text,totalTxtField.text,@"",@"",O_R_Type,@"Open",@""];
    }
    [self checkWebService:strdata];
 }

- (void) checkWebService:(NSString *)strBody {
    
    NSString *serviceString;
    NSString *strdata = strBody;
    
    //serviceString=@"http://192.168.0.158:8080/TymBoxWeb/CreateHelperTrasactionServlet";
    NSString *msg;
    
    if([transType isEqualToString:@"edit"])
    {
        serviceString = @"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateTransMasterDetailServlet";
        msg=@"Offer Updated";
    }else{
        serviceString = @"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateTymboxTransServlet";
        msg=@"Sucessfully sent an offer";
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
    if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Already Reserved"]) {
        [self Stop];
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Selected Date and Timeline are reserved" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }
    
    else if ([[jsonDictionary objectForKey:@"info"] rangeOfString:@"Success"].location != NSNotFound) {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
        
        transID=[NSString stringWithFormat:@"%@",[jsonDictionary objectForKey:@"tansID"]];
        [self sendPushNotification];
        [self Stop];
        [self.navigationController popViewControllerAnimated:YES];
    }else if([[jsonDictionary objectForKey:@"info"] rangeOfString:@"Failure"].location != NSNotFound)
    {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Problem with Server" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }
    

    
}
-(void)sendPushNotification{

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;

    NSString *message= [NSString stringWithFormat:@"%@ Sent you an offer to help you on %@",userName,talentTxtField.text];
     NSString *urlString=[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/pushNotification?userid=%@&message=%@&transID=%@",selectedSeekerId,message,transID];
    
     NSURL *url= [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
//      NSURL *url= [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"GET"];
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    if (!responseData)
    {
       
        NSLog(@"Download Error: %@", error.localizedDescription);
        
    }
    else {
        
    }




}
-(void)Stop{
[MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (IBAction)pickWindow:(id)sender {
    
    
    [self performSegueWithIdentifier:@"offerHelperAvalibilty" sender:self];
}
@end
