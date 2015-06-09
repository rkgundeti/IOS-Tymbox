//
//  AppDelegate.m
//  TymBox
//
//  Created by Vertex Offshore on 2/5/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
@interface AppDelegate ()
{

    BOOL createFaceBookAccount;
    NSString *FBfullNameString;
    NSString *FBEmailId;
    NSString *savedUser;
   
    
}
@end

@implementation AppDelegate
@synthesize ComingFromFB;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    savedUser= [userInfoDic valueForKey:@"userId"] ;
    
    ViewController *customLoginViewController = [[ViewController alloc] init];
    self.customLoginViewController = customLoginViewController;
    
  
//   [[self window] setRootViewController:customLoginViewController];
    
    
    [self.window setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];

    
//    [[UINavigationBar appearance] setBarTintColor:                                                           [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           boldSystemFontOfSize:20], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"footer-portrait.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //   Change the Tab bar back ground image
    
//    UIImage* tabBarBackground = [UIImage imageNamed:@"footer-tab-bar.png"];
//    [[UITabBar appearance] setBackgroundImage:tabBarBackground];

//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
//    {    // The iOS device = iPhone or iPod Touch
//        
    
//        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        //UIViewController *initialViewController = nil;
//        if (iOSDeviceScreenSize.height == 667)
//        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
//            
//            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
//            UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            // Instantiate the initial view controller object from the storyboard
//            initialViewController = [iPhone35Storyboard instantiateInitialViewController];
//        }
    
//        if (iOSDeviceScreenSize.height == 568) 
//        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
        
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
    
    /*
       NSString *storyboardId = savedUser ? @"entryScreenViewController" : @"ViewController";
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
    
    UIViewController *initViewController = [iPhone4Storyboard instantiateViewControllerWithIdentifier:storyboardId];

            
            // Instantiate the initial view controller object from the storyboard
//            initialViewController = [iPhone4Storyboard instantiateInitialViewController];
       // }
       
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
        */
    
    
    NSString *storyboardId = savedUser ? @"entryScreenViewController" : @"ViewController";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initViewController;
//    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//        
//    {   // The iOS device = iPad
//        
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        splitViewController.delegate = (id)navigationController.topViewController;
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        UIButton *faceBookLoginButton = [self.customLoginViewController faceBookLoginButton];
        [faceBookLoginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    }
    return YES;

}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Show alert for push notifications recevied while the
    // app is running
//    NSString *message = [[userInfo objectForKey:@"aps"]
//                         objectForKey:@"alert"];
    NSString *yu= [[userInfo objectForKey:@"aps"]
                   objectForKey:@"mykey1"];
    
    NSDictionary *diu= [userInfo objectForKey:@"mykey1"];
    
    NSString *message = [NSString stringWithFormat:@"my dictionary is %@", diu];
    
    NSLog(@"Com on ===  %@",diu);
    NSLog(@"%@",yu);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
  
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"devToken=%@",deviceToken);
    
    NSString * Token = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
   
    
    [[NSUserDefaults standardUserDefaults] setObject:Token forKey:@"Device_Token"];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        
        [FBRequestConnection startWithGraphPath:@"me"
                                     parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Set the use full name.
                                      
                                      [self myRockinFunction:result];
                                      FBfullNameString = [NSString stringWithFormat:@"%@ %@",
                                                          [result objectForKey:@"first_name"],
                                                          [result objectForKey:@"last_name"]
                                                          ];
                                      
                                      // Set the e-mail address.
                                      FBEmailId = [result objectForKey:@"email"];
                                      
                                      // Get the user's profile picture.
                                      //NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                      ViewController* appDelegate = [[ViewController alloc] init];
                                      appDelegate.FBFullNameString=FBfullNameString;
                                      appDelegate.FBEmailIdString= FBEmailId;
                                      //                                      self.imgProfilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                                      //
                                      // Make the user info visible.
                                      //[self hideUserInfo:NO];
                                      
                                      // Stop the activity indicator from animating and hide the status label.
                                      // self.lblStatus.hidden = YES;
                                      // [self.activityIndicator stopAnimating];
                                      // self.activityIndicator.hidden = YES;
                                  }
                                  else{
                                      NSLog(@"%@", [error localizedDescription]);
                                  }
                              }];
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }


    
    /*
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        [FBRequestConnection startWithGraphPath:@"me"
                                     parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Set the use full name.
                                      
                                        [self myRockinFunction:result];
                                   FBfullNameString = [NSString stringWithFormat:@"%@ %@",
                                                               [result objectForKey:@"first_name"],
                                                               [result objectForKey:@"last_name"]
                                                               ];
                                      
                                      // Set the e-mail address.
                                     FBEmailId = [result objectForKey:@"email"];
                                      
                                      // Get the user's profile picture.
                                      NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                      ViewController* appDelegate = [[ViewController alloc] init];
                                      appDelegate.FBFullNameString=FBfullNameString;
                                      appDelegate.FBEmailIdString= FBEmailId;
//                                      self.imgProfilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
//                                      
                                      // Make the user info visible.
                                      //[self hideUserInfo:NO];
                                      
                                      // Stop the activity indicator from animating and hide the status label.
                                     // self.lblStatus.hidden = YES;
                                     // [self.activityIndicator stopAnimating];
                                     // self.activityIndicator.hidden = YES;
                                  }
                                  else{
                                      NSLog(@"%@", [error localizedDescription]);
                                  }
                              }];
        
        
        // Show the user the logged-in UI
        [self userLoggedIn];
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
       
    }
     
     */
}

-(void)myRockinFunction:(NSDictionary*) fb_result{
    NSLog(@"%@",fb_result);
    createFaceBookAccount=YES;
    ViewController* appDelegate = [[ViewController alloc] init];
    appDelegate.FBFullNameString=FBfullNameString;
    appDelegate.FBEmailIdString= FBEmailId;
    appDelegate.fbUserDictionary=fb_result;
    appDelegate.fbLoginPlz=YES;
    
    [appDelegate  createFaceBookAccount];
    [appDelegate perform];
}
-(void)call{
    

}
// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    UIButton *faceBookLoginButton = [self.customLoginViewController faceBookLoginButton];
    [faceBookLoginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
    [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    UIButton *faceBookLoginButton = self.customLoginViewController.faceBookLoginButton;
    
    [faceBookLoginButton setTitle:@"Log out" forState:UIControlStateNormal];
    

  
    
    // Welcome message
    [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    if (ComingFromFB) {
        ViewController *vc= [[ViewController alloc] init];
        vc.fbLoginPlz=YES;
         return [FBSession.activeSession handleOpenURL:url];
    }
    else{
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }

}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "vertex.TymBox" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TymBox" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TymBox.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
