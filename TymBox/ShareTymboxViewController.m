//
//  ShareTymboxViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "ShareTymboxViewController.h"
#import "SWRevealViewController.h"
#import "ContactsTableViewController.h"
#import "HelperTalentsViewController.h"
#import <MessageUI/MessageUI.h>
@interface ShareTymboxViewController ()
{
    NSString *selectedTalentID;
    NSString *txtEmailStr;
    NSString *contactPhone;
    NSString *contactEmail;
    NSString *finalPhn;
    NSString *finalEmail;

}

@property (nonatomic, strong) NSArray *files;
@end

@implementation ShareTymboxViewController
@synthesize selectedTalentTxt,textEmailSeg,contactName,comments,contact;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];

    _files = @[@"10 Great iPhone Tips.pdf", @"camera-photo-tips.html", @"foggy.jpg", @"Hello World.ppt", @"no more complaint.png", @"Why Appcoda.doc"];
    SWRevealViewController *reveal = self.revealViewController;
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:reveal action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = barBtn;
    
    [comments.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [comments.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    comments.layer.cornerRadius = 5;
    comments.clipsToBounds = YES;
    
    NSString *commentsStr = comments.text;
    
   // comments.text = [NSString stringWithFormat:@"%@ %@",commentsStr,@"RKG"];
    
    comments.text=@"Welcome to Tymbox";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTalentsNotification:) name:@"selectedTalents" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(helperContactNotification:) name:@"selectedHelperContact" object:nil];
    // Do any additional setup after loading the view.
}
- (void) selectedTalentsNotification:(NSNotification *)notification{
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    selectedTalentTxt.text = [theString objectForKey:@"talentName"];
    
    //NSLog(@"workPhone===%@",[theString objectForKey:@"talentId"]);
    selectedTalentID = [theString objectForKey:@"userTalentId"];
    
    
}
- (IBAction)selectTalentAction:(id)sender {
    
    [self performSegueWithIdentifier:@"getUserTalents" sender:self];
}

- (void) helperContactNotification:(NSNotification *)notification{
    NSMutableString *stringPhoneNumber= [[NSMutableString alloc] init];
    
    NSMutableDictionary *theString = [notification object];
    NSLog(@"theString====%@",theString);
    
    //NSString *exPhone= [[theString objectForKey:@"homePhone"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([[theString objectForKey:@"mobilePhone"] isEqual:[NSNull null]]) {
        
       
    }
    
    else{
        contact.text=[theString objectForKey:@"helperName"];
        NSLog(@"%@",[theString objectForKey:@"mobilePhone"]);
        
        stringPhoneNumber= [NSMutableString stringWithFormat:@"%@",[theString objectForKey:@"mobilePhone"]];
        finalPhn=[theString objectForKey:@"mobilePhone"];
        
        
               //stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    }
    
//    else if (![[theString objectForKey:@"mobilePhone"] isEqual:[NSNull null]]){
//    finalPhn=[NSString stringWithFormat:@"%@-%@",[theString objectForKey:@"helperName"],[[theString objectForKey:@"mobilePhone"] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
//    
//    }
//    else{
//    
//    
//     finalPhn=[NSString stringWithFormat:@"%@-%@",[theString objectForKey:@"helperName"],[[theString objectForKey:@"workPhone"] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
//    }
//    

    if ([theString objectForKey:@"workEmail"]) {
        
//        contactName.text= [NSString stringWithFormat:@"%@-%@",[theString objectForKey:@"helperName"],[theString objectForKey:@"workEmail"]];
        finalEmail= [NSString stringWithFormat:@"%@-%@",[theString objectForKey:@"helperName"],[theString objectForKey:@"workEmail"]];
    }
    else{
//        contactName.text= [NSString stringWithFormat:@"%@-%@",[theString objectForKey:@"helperName"],[theString objectForKey:@"homeEmail"]];
        finalEmail= [NSString stringWithFormat:@"%@-%@",[theString objectForKey:@"helperName"],[theString objectForKey:@"homeEmail"]];
    }

    
    if (textEmailSeg.selectedSegmentIndex==0) {
        //contactName.text = [theString objectForKey:@"helperName"];
        
        
        contactName.text=stringPhoneNumber;
       
    }
    else{
        contactName.text=finalEmail;
        
    }
    
    
    
    NSLog(@"workPhone===%@",[theString objectForKey:@"workPhone"]);
    contactPhone = [theString objectForKey:@"workPhone"];
    NSLog(@"workEmail===%@",[theString objectForKey:@"workEmail"]);
    contactEmail = [theString objectForKey:@"workEmail"];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"getUserTalents"])
    {
        
        HelperTalentsViewController *controller = [segue destinationViewController];
        controller.comingFromShareTymbox = YES;
        NSLog(@"controller===%@",controller);
        
    }else if([segue.identifier isEqualToString:@"getDeviceContacts"])
    {
        
        ContactsTableViewController *controller = [segue destinationViewController];
        NSLog(@"controller===%@",controller);
        controller.selectType =@"HelperSelect";
        
    }
    
    //getDeviceContacts
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
  
    
    [self animateTextView:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
     [self animateTextView:NO];
}
- (void) animateTextView:(BOOL) up
{
    const int movementDistance =-130;; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);

    [UIView beginAnimations: @"animateTextView" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getDeviceContactAction:(id)sender {
    
    [self performSegueWithIdentifier:@"getDeviceContacts" sender:self];
}
- (IBAction)textEmailAction:(id)sender {
    
    if(textEmailSeg.selectedSegmentIndex == 0)
    {
        //self.view.backgroundColor = [UIColor redColor];
        contactName.text=finalPhn;
       // [contactName setPlaceholder:@"enter phone #"];
        contactName.keyboardType=UIKeyboardTypeNumberPad;
        txtEmailStr = [NSString stringWithFormat:@"%@",[textEmailSeg titleForSegmentAtIndex:0]];
        
    }
    else if(textEmailSeg.selectedSegmentIndex == 1)
    {
        //self.view.backgroundColor = [UIColor greenColor];
        contactName.text=finalEmail;
       // [contactName setPlaceholder:@"enter email address"];
        contactName.keyboardType=UIKeyboardTypeEmailAddress;
        txtEmailStr = [NSString stringWithFormat:@"%@",[textEmailSeg titleForSegmentAtIndex:1]];
    }
}
- (IBAction)sendInviteAction:(id)sender {
    
    if(textEmailSeg.selectedSegmentIndex == 0)
    {
        NSString *selectedFile = [_files objectAtIndex:0];
        //[self showSMS:selectedFile];
        
        if (!contactName.text.length==0) {
             [self showSMS:selectedFile];
        }
        else{
        
            UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a phone number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
           
            [anAlert show];
        }
        
    }
    else{
        
        if ([self NSStringIsValidEmail:contactName.text]) {
            [self sendEmail];
        }
        else{
            
            UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a valid E-mail address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [anAlert show];
        }
        
        
    
    }
    
    
    
 
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (void)showSMS:(NSString*)file {
    
   // NSLog(@"recipentsPhone====%@",recipentsPhone);
    
    
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
   // NSArray *recipents = recipentsPhone;
    else{
        
        
      
        NSArray* foo = [contactName.text componentsSeparatedByString: @"-"];
    NSArray *recipents = [NSArray arrayWithObject:[foo objectAtIndex:1]];
    
    //NSArray *recipents = @[@"12345678", @"72345524"];
//    NSString *message = [NSString stringWithFormat:@"Just sent the %@ file to your email. Please check!", file];
    
     NSString *message = [NSString stringWithFormat:@"Welcome to Tymbox"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
       [[messageController navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    }
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
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your message has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)sendEmail{
    
    
    if ([MFMailComposeViewController   canSendMail]){
        // Email Subject
        NSString *emailTitle = @"Welcome to Tymbox";
        // Email Content
        NSString *messageBody = @"Welcome to Tymbox";
        // To address
        
        NSArray *recArray=[contactName.text componentsSeparatedByString:@"-"];
        
        NSArray *toRecipents = [NSArray arrayWithObject:[recArray objectAtIndex:1]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [[mc navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
        else{
            UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"error" message:@"No mail account setup on device" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [anAlert addButtonWithTitle:@"Cancel"];
            [anAlert show];
        }
  

//    //email subject
//    NSString * subject = @"Welcome to Tymbox";
//    //email body
//    NSString * body = @"Hey check this new app, it's awesome man";
//    //recipient(s)
//   // NSLog(@"recipentsEmails====%@",recipentsEmails);
//   // NSArray * recipients = recipentsEmails;
//    
//    NSArray * recipients = [NSArray arrayWithObjects:@"Sadik.m@vertexcs.com", nil];
//    
//    //create the MFMailComposeViewController
//    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
//    composer.mailComposeDelegate = self;
//    [composer setSubject:subject];
//    [composer setMessageBody:body isHTML:NO];
//    //[composer setMessageBody:body isHTML:YES]; //if you want to send an HTML message
//    [composer setToRecipients:recipients];
//    
//    //get the filepath from resources
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
//    
//    //read the file using NSData
//    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
//    // Set the MIME type
//    /*you can use :
//     - @"application/msword" for MS Word
//     - @"application/vnd.ms-powerpoint" for PowerPoint
//     - @"text/html" for HTML file
//     - @"application/pdf" for PDF document
//     - @"image/jpeg" for JPEG/JPG images
//     */
//    NSString *mimeType = @"image/png";
//    
//    //add attachement
//    [composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
//    
//    //present it on the screen
//    [self presentViewController:composer animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
