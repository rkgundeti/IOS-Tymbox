//
//  AppDelegate.h
//  TymBox
//
//  Created by Vertex Offshore on 2/5/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL ComingFromFB;
@property (strong, nonatomic) ViewController *customLoginViewController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;

@end

