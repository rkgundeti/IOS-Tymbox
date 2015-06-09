//
//  IntroduceViewController.m
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "IntroduceViewController.h"
#import "ContactsTableViewController.h"
#import "HelperTalentsViewController.h"
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
@interface IntroduceViewController () <MFMessageComposeViewControllerDelegate>
{
    NSString *helperPhone;
    NSString *helperEmail;
    NSString *seekerPhone;
    NSString *seekerEmail;
    
    NSString *txtEmailSegmentStr;
    NSString *txtEmailSeekerSegmentStr;
    
    NSMutableArray *recipentsPhone;
    NSMutableArray *recipentsEmails;
    
    NSString *selectedTalentId;
    
    NSString *selectedHelperId;
    BOOL sendInviteToHelperThroughTymbox;
    BOOL sendInviteToSeekerThroughTymbox;
    NSString *IntroduceHelperId;
    NSString *IntroduceSeekerId;
    
    NSString *userId;
    
}

@property (nonatomic, strong) NSArray *files;

@end

@implementation IntroduceViewController
@synthesize  txtEmailSegment,helperOn;
@synthesize txtEmailSeekerSegment,seekerOn;
@synthesize chooseContactType,helperbtn,seekerbtn;
@synthesize scrollView;
@synthesize chooseHelperTxt,chooseSeekerTxt,chooseTalentTxt,enterHelperTxt,enterSeekerTxt;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
   
    sendInviteToHelperThroughTymbox=YES;
    sendInviteToSeekerThroughTymbox=YES;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];
    
    SWRevealViewController *reveal = self.revealViewController;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:reveal action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = barBtn;
    
//    UIGraphicsBeginImageContext(headerView1.frame.size);
//    [[UIImage imageNamed:@"backimg.png"] drawInRect:headerView1.bounds];
//    UIImage *headerImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    headerView1.backgroundColor = [UIColor colorWithPatternImage:headerImg];
//    
//    UIGraphicsBeginImageContext(headerView2.frame.size);
//    [[UIImage imageNamed:@"backimg.png"] drawInRect:headerView2.bounds];
//    UIImage *headerImg1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    headerView2.backgroundColor = [UIColor colorWithPatternImage:headerImg1];
//    
//    UIGraphicsBeginImageContext(headerView3.frame.size);
//    [[UIImage imageNamed:@"backimg.png"] drawInRect:headerView3.bounds];
//    UIImage *headerImg2 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    headerView3.backgroundColor = [UIColor colorWithPatternImage:headerImg2];
//    
//    UIGraphicsBeginImageContext(headerView4.frame.size);
//    [[UIImage imageNamed:@"greenBackimg.png"] drawInRect:headerView4.bounds];
//    UIImage *headerImg3 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
    //headerView4.backgroundColor = [UIColor colorWithPatternImage:headerImg3];
    
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"Background_portrait.png"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
    self.title=@"Introduce Friends";
//    
//    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor, nil];
//    
//    self.navigationController.navigationBar.titleTextAttributes = size;
//    
    
     _files = @[@"10 Great iPhone Tips.pdf", @"camera-photo-tips.html", @"foggy.jpg", @"Hello World.ppt", @"no more complaint.png", @"Why Appcoda.doc"];
    
    txtEmailSegmentStr = [NSString stringWithFormat:@"%@",[txtEmailSegment titleForSegmentAtIndex:0]];
    txtEmailSeekerSegmentStr = [NSString stringWithFormat:@"%@",[txtEmailSeekerSegment titleForSegmentAtIndex:0]];
    
    //[self getContactPhoneEmails];
    recipentsPhone = [[NSMutableArray alloc] init];
    recipentsEmails = [[NSMutableArray alloc] init];
    
    txtEmailSegment.alpha = 0;
   
    enterHelperTxt.alpha = 0;
   
    chooseHelperTxt.alpha =1;
//    self.helperOn.on=YES;
    [self.helperOn addTarget:self
                      action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    txtEmailSeekerSegment.alpha = 0;
    
    enterSeekerTxt.alpha = 0;
    
   
    chooseSeekerTxt.alpha = 1;
    
    
//     self.helperOn.on=YES;
    
    [self.seekerOn addTarget:self
                      action:@selector(seekerSelectionChanged:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helperContactNotification:) name:@"selectedHelperContact" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seekerContactNotification:) name:@"selectedSeekerContact" object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helperContactNotification:) name:@"selectedHelperTymBox" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seekerContactNotification:) name:@"selectedSeekerTymBox" object:nil];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTalentsNotification:) name:@"selectedTalents" object:nil];
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) helperContactNotification:(NSNotification *)notification{
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    if([chooseContactType isEqualToString:@"HelperSelect"])
    {
        //enterHelperlbl.text = [theString objectForKey:@"helperName"];
        enterHelperTxt.text = [theString objectForKey:@"helperName"];
        
        
    }else if([chooseContactType isEqualToString:@"HelperSelectTymBox"])
    {
        //chooseHelperlbl.text = [theString objectForKey:@"helperName"];
        chooseHelperTxt.text = [theString objectForKey:@"helperName"];
        IntroduceHelperId = [theString objectForKey:@"userId"];
        
    }
    
    selectedHelperId = [theString objectForKey:@"userId"];
    NSLog(@"workPhone===%@",[theString objectForKey:@"workPhone"]);
    helperPhone = [theString objectForKey:@"workPhone"];
    NSLog(@"workEmail===%@",[theString objectForKey:@"workEmail"]);
    helperEmail = [theString objectForKey:@"workEmail"];
    
}

- (void) seekerContactNotification:(NSNotification *)notification{
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    if([chooseContactType isEqualToString:@"SeekerSelect"])
    {
        //enterSeekerlbl.text = [theString objectForKey:@"seekerName"];
        enterSeekerTxt.text = [theString objectForKey:@"seekerName"];
    
    }else if([chooseContactType isEqualToString:@"SeekerSelectTymBox"])
    {
        //chooseSeekerlbl.text = [theString objectForKey:@"seekerName"];
        chooseSeekerTxt.text = [theString objectForKey:@"seekerName"];
        IntroduceSeekerId = [theString objectForKey:@"userId"];
    }
    
    
    
    seekerPhone = [theString objectForKey:@"workPhone"];
    
    NSLog(@"workEmail===%@",[theString objectForKey:@"workEmail"]);
    seekerEmail = [theString objectForKey:@"workEmail"];
    
}



- (void) selectedTalentsNotification:(NSNotification *)notification{
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    chooseTalentTxt.text = [theString objectForKey:@"talentName"];
    
    //NSLog(@"workPhone===%@",[theString objectForKey:@"talentId"]);
    selectedTalentId = [theString objectForKey:@"userTalentId"];
    
    
}

- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
//        txtEmailSegment.alpha = 0;
//        //enterHelperlbl.alpha = 0;
//        enterHelperTxt.alpha = 0;
//        //chooseHelperlbl.alpha = 1;
//        chooseSeekerTxt.alpha = 1;
        
        txtEmailSegment.alpha=0;
        chooseHelperTxt.alpha=1;
        
        chooseHelperTxt.placeholder=@"Choose Helper";
        
        sendInviteToHelperThroughTymbox=YES;
        
        
        
    } else {
        
        txtEmailSegment.alpha=1;
        chooseHelperTxt.alpha=1;
        chooseHelperTxt.placeholder=@"Enter Helper";
        sendInviteToHelperThroughTymbox=NO;
//        txtEmailSegment.alpha = 1;
//        //enterHelperlbl.alpha = 1;
//        enterHelperTxt.alpha = 1;
//        //chooseHelperlbl.alpha = 0;
//        chooseHelperTxt.alpha = 0;
        
    }
    //[self getContactPhoneEmails];
}



- (void)seekerSelectionChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
//        txtEmailSeekerSegment.alpha = 0;
//        //enterSeekerlbl.alpha = 0;
//        enterSeekerTxt.alpha = 0;
//        //chooseSeekerlbl.alpha = 1;
//        chooseSeekerTxt.alpha = 1;
        
        chooseSeekerTxt.alpha=1;
        chooseSeekerTxt.placeholder=@"Choose Seeker";
        txtEmailSeekerSegment.alpha=0;
        
        sendInviteToSeekerThroughTymbox=YES;
        
    } else {
//        txtEmailSeekerSegment.alpha = 1;
//        //enterSeekerlbl.alpha = 1;
//        enterSeekerTxt.alpha = 1;
//        //chooseSeekerlbl.alpha = 0;
//        chooseSeekerTxt.alpha = 0;
        
        chooseSeekerTxt.alpha=1;
        chooseSeekerTxt.placeholder=@"Enter Seeker";
        txtEmailSeekerSegment.alpha=1;
         sendInviteToSeekerThroughTymbox=NO;
    }
    //[self getContactPhoneEmails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        [textField resignFirstResponder];
        if ([helperOn isOn]) {
            chooseContactType = @"HelperSelectTymBox";
        }else {
            chooseContactType = @"HelperSelect";
        }
        [self performSegueWithIdentifier:@"ChooseHelperContact" sender:self];
    }
    
    else if (textField.tag==2){
        [textField resignFirstResponder];
        if ([seekerOn isOn]) {
            chooseContactType = @"SeekerSelectTymBox";
        }else {
            chooseContactType = @"SeekerSelect";
        }
        [self performSegueWithIdentifier:@"ChooseSeekerContact" sender:self];
    
    }

}
- (IBAction)chooseHelperAction:(id)sender {
    if ([helperOn isOn]) {
        chooseContactType = @"HelperSelectTymBox";
    }else {
        chooseContactType = @"HelperSelect";
    }
    [self performSegueWithIdentifier:@"ChooseHelperContact" sender:self];
    
}

- (IBAction)chooseSeekerAction:(id)sender {
    if ([seekerOn isOn]) {
        chooseContactType = @"SeekerSelectTymBox";
    }else {
        chooseContactType = @"SeekerSelect";
    }
    [self performSegueWithIdentifier:@"ChooseSeekerContact" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChooseHelperContact"]) {
        NSLog(@"chooseContactType===%@",chooseContactType);
        
        ContactsTableViewController *controller = [segue destinationViewController];
        if([chooseContactType isEqualToString:@"HelperSelect"])
        {
            controller.selectType = @"HelperSelect";
            
        }else if([chooseContactType isEqualToString:@"HelperSelectTymBox"])
        {
            
            controller.selectedHelper = @"";
            controller.selectType = @"HelperSelectTymBox";
            controller.selectedUserType=@"Helper";
            
        }
        
    }else if ([segue.identifier isEqualToString:@"ChooseSeekerContact"]) {
        NSLog(@"chooseContactType===%@",chooseContactType);
        
        ContactsTableViewController *controller = [segue destinationViewController];
        if([chooseContactType isEqualToString:@"SeekerSelect"])
        {
            controller.selectType = @"SeekerSelect";
        }else if([chooseContactType isEqualToString:@"SeekerSelectTymBox"])
        {
            controller.selectedHelper = selectedHelperId;
            controller.selectType = @"SeekerSelectTymBox";
             controller.selectedUserType=@"Seeker";
        }
        
    }else if([segue.identifier isEqualToString:@"getUserTalents"])
    {
        
        HelperTalentsViewController *controller = [segue destinationViewController];
        controller.comingFromShareTymbox=YES;
        NSLog(@"controller===%@",controller);
        
    }
}



- (IBAction)helperSegment:(id)sender {
    
    if(txtEmailSegment.selectedSegmentIndex == 0)
    {
        //self.view.backgroundColor = [UIColor redColor];
        txtEmailSegmentStr = [NSString stringWithFormat:@"%@",[txtEmailSegment titleForSegmentAtIndex:0]];
        
    }
    else if(txtEmailSegment.selectedSegmentIndex == 1)
    {
        //self.view.backgroundColor = [UIColor greenColor];
        txtEmailSegmentStr = [NSString stringWithFormat:@"%@",[txtEmailSegment titleForSegmentAtIndex:1]];
    }
    
    //[self getContactPhoneEmails];
    
    
}

- (IBAction)seekerSegment:(id)sender {
    
    if(txtEmailSeekerSegment.selectedSegmentIndex == 0)
    {
        //self.view.backgroundColor = [UIColor redColor];
        txtEmailSeekerSegmentStr = [NSString stringWithFormat:@"%@",[txtEmailSeekerSegment titleForSegmentAtIndex:0]];
        
    }
    else if(txtEmailSegment.selectedSegmentIndex == 1)
    {
        //self.view.backgroundColor = [UIColor greenColor];
        txtEmailSeekerSegmentStr = [NSString stringWithFormat:@"%@",[txtEmailSeekerSegment titleForSegmentAtIndex:1]];
    }
    
    //[self getContactPhoneEmails];
    
}



- (IBAction)introduceActionBtn:(id)sender {
    
    if (sendInviteToHelperThroughTymbox && sendInviteToSeekerThroughTymbox) {
        NSURL *requrl;
        NSString *posttring;
        NSMutableDictionary *Response;
        NSData *responseData;

        
        requrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateHelperSeekerFriendServlet"]];
        
        posttring =[NSString stringWithFormat:@"{\"Introduced_By\":\"%@\",\"Helper_Refer_ToId\":\"%@\",\"Seeker_Refer_ToId\":\"%@\",\"Comment\":\"%@\",\"Helper_Status\":\"%@\",\"Seeker_Status\":\"%@\"}",userId,IntroduceHelperId,IntroduceSeekerId,@"",@"",@""];
        
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Error in Api" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert1 show];
            
            NSLog(@"JSON Error: %@", error);
        }
        
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Successfully Inserted to DB"]) {
               
                UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Request Sent sucessfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert1 show];
                
                
            }
            
            
        }
        
    }
    
    else{
    [self getContactPhoneEmails];
    if ([recipentsEmails count]>0)
    {
        [self sendEmail];
    }
    if ([recipentsPhone count]>0)
    {
        NSString *selectedFile = [_files objectAtIndex:0];
        [self showSMS:selectedFile];
    }
    }
    
    
}

- (IBAction)searchTalents:(id)sender {
    
    [self performSegueWithIdentifier:@"getUserTalents" sender:self];
    //
}


-(void) getContactPhoneEmails{
    
    recipentsPhone = [[NSMutableArray alloc]init];
    recipentsEmails = [[NSMutableArray alloc]init];
    
    if([txtEmailSegmentStr isEqualToString:@"Text"])
    {
        [recipentsPhone addObject:helperPhone];
        
    }else if([txtEmailSegmentStr isEqualToString:@"Email"])
    {
        [recipentsEmails addObject:helperEmail];
    }
    
    if([txtEmailSeekerSegmentStr isEqualToString:@"Text"])
    {
        [recipentsPhone addObject:seekerPhone];
        
    }else if([txtEmailSeekerSegmentStr isEqualToString:@"Email"])
    {
        [recipentsEmails addObject:seekerEmail];
    }
    
    
}

- (void)showSMS:(NSString*)file {
    
    NSLog(@"recipentsPhone====%@",recipentsPhone);
    
    
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = recipentsPhone;
    
    //NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction methods
- (void)sendEmail{
    //email subject
    NSString * subject = @"send mail test";
    //email body
    NSString * body = @"How did you find the Android-IOS-Tutorials Website ?";
    //recipient(s)
    NSLog(@"recipentsEmails====%@",recipentsEmails);
    NSArray * recipients = recipentsEmails;
    
    //NSArray * recipients = [NSArray arrayWithObjects:@"contact@androidiostutorials.com", nil];
    
    //create the MFMailComposeViewController
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:NO];
    //[composer setMessageBody:body isHTML:YES]; //if you want to send an HTML message
    [composer setToRecipients:recipients];
    
    //get the filepath from resources
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    
    //read the file using NSData
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    // Set the MIME type
    /*you can use :
     - @"application/msword" for MS Word
     - @"application/vnd.ms-powerpoint" for PowerPoint
     - @"text/html" for HTML file
     - @"application/pdf" for PDF document
     - @"image/jpeg" for JPEG/JPG images
     */
    NSString *mimeType = @"image/png";
    
    //add attachement
    [composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
    
    //present it on the screen
    [self presentViewController:composer animated:YES completion:NULL];
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled"); break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved"); break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent"); break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]); break;
        default:
            break;
    }
    
    // close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
