//
//  ViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/5/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "ViewController.h"
#import "createAccount.h"
#import "entryScreenViewController.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "WebService.h"
#import "AppDelegate.h"
@interface ViewController ()
{
    UIActivityIndicatorView *spinner;
    UIActivityIndicatorView *spinner1;
      NSMutableArray *jsonArray;
    NSString *faceBookUserId;
    NSString *facebookEmailId;
    NSString *faceBookName;
    
   // MBProgressHUD *hud;

}
@end
static NSString * const kClientId = @"245665220570-d1t3hcv3ceadsqrv8q9l4sbmhre0t9a2.apps.googleusercontent.com";
@implementation ViewController
@synthesize loginButton,accToken,logINUserName,emailAddressTxtField,passwordTxtField,signInButton,FBEmailIdString,FBFullNameString,fbUserDictionary,pressedFbLogin,fbLoginPlz;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
   
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapScroll];
    
    
    GPPSignInButton *button = [[GPPSignInButton alloc] init];
    [button setStyle:kGPPSignInButtonStyleWide];
    
    [self.signInButton addSubview:button];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientId;
    
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    signIn.scopes = @[ @"profile" ];
    signIn.scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    signIn.shouldFetchGoogleUserID=YES;
    signIn.shouldFetchGoogleUserEmail=YES;
    
    //NSLog(@"%@",signIn.scopes = @[ @"profile" ]);
    signIn.delegate = self;
    
   
}

- (void) tapped
{
    [self.view endEditing:YES];
}

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



-(void)doFaceBookStuff
{
    pressedFbLogin=YES;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.ComingFromFB=YES;
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             // [self createFaceBookAccount];
             
         }];
        
        // [self createFaceBookAccount];
    }
}
- (IBAction)facebookLoginBtnTouched:(id)sender
{
    pressedFbLogin=YES;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.ComingFromFB=YES;

    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
         [self performSegueWithIdentifier:@"loggedInUser" sender:self];
    }
    
    

}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        // 3. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        //Handle Error
                    } else {
                        
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.gender);
                        NSMutableDictionary *googleResults = [[NSMutableDictionary alloc] init];
                        
                        NSString *email = [NSString stringWithFormat:@"%@",[GPPSignIn sharedInstance].authentication.userEmail];
                        
                        [googleResults setValue:email forKey:@"Email"];
                        
                        
                        [googleResults setValue:[person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName] forKey:@"User Name"];
                        
                        [googleResults setValue:person.gender forKey:@"Gender"];
                        
                         [self myRockinFunction:googleResults];
                        
                        
                       
                        
                        
                    }
                }];
    
    }
}

-(void)myRockinFunction:(NSMutableDictionary*) fb_result{
    NSLog(@"%@",fb_result);
    
    
    
    facebookEmailId= [fb_result valueForKey:@"Email"];
    faceBookName= [fb_result valueForKey:@"User Name"];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD showWhileExecuting:@selector(createFaceBookAccount) onTarget:self withObject:nil animated:YES];
//       [self  createFaceBookAccount];
}
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}


- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"foobar"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"accToken====%@",accToken);
        
        createAccount* controller =
        (createAccount*)[[segue destinationViewController] topViewController];
        [controller setAccessToken:self.accToken];
        
       
    }
    else if([segue.identifier isEqualToString:@"loggedInUser"])
    {
        entryScreenViewController* controller =
        (entryScreenViewController*)[[segue destinationViewController] topViewController];
         NSLog(@"accToken====%@",controller);
        //[controller setLoggedInUser:logINUserName];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.scrollView endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.scrollView endEditing:YES];
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) myTask {
    sleep(3);
}
-(void)hudWasHidden { // Remove HUD from screen when the HUD was hidden
    [HUD removeFromSuperview];
}
- (void)createFaceBookAccount {
   
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
    
    
    if (pressedFbLogin || fbLoginPlz) {
        facebookEmailId= [fbUserDictionary valueForKey:@"email"];
        
        faceBookName = [fbUserDictionary valueForKey:@"first_name"];
    }
    
    NSURL *url;
     if (pressedFbLogin || fbLoginPlz) {
       url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/NewAccountServlet?u=%@&e=%@&p=%@&ph=%@&gender=%@&boy=%@&login_type=%@",faceBookName,facebookEmailId,@"",@"",@"",@"",@"facebook"]];
    
     }
    
     else{
    NSString *stringUrl=[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/NewAccountServlet?u=%@&e=%@&p=%@&ph=%@&gender=%@&boy=%@&login_type=%@",faceBookName,facebookEmailId,@"",@"",@"",@"",@"google"];
         
         url= [NSURL URLWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         
         
     
     }
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        if (!responseData)
        {
                       NSLog(@"Download Error: %@", error.localizedDescription);
            
        }
        else {
            
            NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",myString);
            // Parse the (binary) JSON data from the web service into an NSDictionary object
          NSMutableDictionary  *jsonFaceD = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            NSLog(@"2.dictionary values are : %@",jsonArray);
            
            if (jsonFaceD == nil) {
                 NSLog(@"JSON Error: %@", error);
            }
            
            else{
              
                
                NSString *result = [jsonFaceD objectForKey:@"infoUserExists"];
                if ([result isEqualToString:@"User Exists"]){
                
                    
                    faceBookUserId= [jsonFaceD objectForKey:@"infoUserId"];
//                    faceBookUserId= [NSString stringWithFormat:@"%@",[jsonFaceD objectForKey:@"infoSuccess"]];
                    
                    NSMutableDictionary *des= [[NSMutableDictionary alloc] init];
                    
                    [des setValue:facebookEmailId forKey:@"email"];
                    
                    [des setValue:@"" forKey:@"phone"];
                    
                    [des setValue:faceBookUserId forKey:@"userId"];
                    
                    [des setValue:faceBookName forKey:@"userName"];
                    
                    if (pressedFbLogin || fbLoginPlz) {
                        [des setValue:@"FB" forKey:@"loginType"];
                    }
                    else{
                    
                     [des setValue:@"Google" forKey:@"loginType"];
                        
                    }
                    NSLog(@"%@",des);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:des forKey:@"userInfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                   // [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self performSegueWithIdentifier:@"loggedInUser" sender:self];
                    
                }
                
                else{
                
                    faceBookUserId= [jsonFaceD objectForKey:@"infoSuccess"];
                    
                    NSMutableDictionary *des= [[NSMutableDictionary alloc] init];
                    
                     [des setValue:facebookEmailId forKey:@"email"];
                    
                     [des setValue:@"" forKey:@"phone"];
                    
                     [des setValue:faceBookUserId forKey:@"userId"];
                    
                     [des setValue:faceBookName forKey:@"userName"];
                    
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:des forKey:@"userInfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSegueWithIdentifier:@"loggedInUser" sender:self];
                
                    
                }
                
            }
        }
    }
    

-(void)perform{
[self performSegueWithIdentifier:@"loggedInUser" sender:self];
}
- (IBAction)unwindToList:(UIStoryboardSegue *)segue{



}
- (BOOL) validateEmail: (NSString *) email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}


- (IBAction)LoginBtnAction:(id)sender {
    
 
    if (emailAddressTxtField.text.length==0 && passwordTxtField.text.length ==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter Email ID & Password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
      
    }
    else if (emailAddressTxtField.text.length==0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please enter your e-mail address" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

   else if ( passwordTxtField.text.length ==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter your password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

   else if (![self validateEmail:emailAddressTxtField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Enter Valid Email Address" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [emailAddressTxtField becomeFirstResponder];
        return;
    }
  
   else{
       // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       [HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
   }
    
}
-(void)doSomeFunkyStuff{
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/LoginServlet?u=%@&p=%@",emailAddressTxtField.text,passwordTxtField.text]];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"GET"];
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    if (!responseData)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",myString);
        // Parse the (binary) JSON data from the web service into an NSDictionary object
        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (!jsonArray.count==0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:[jsonArray objectAtIndex:0] forKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
                
                [self performSegueWithIdentifier:@"loggedInUser" sender:self];
                                          });
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User details are wrong" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }
}

@end
