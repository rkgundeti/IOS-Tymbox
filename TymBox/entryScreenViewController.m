//
//  entryScreenViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "entryScreenViewController.h"
#import "HelpersCornerViewController.h"

@implementation entryScreenViewController
@synthesize helperButton,seekerButton,check,userType,window,lblQuote;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
    lblQuote.text = @"something else";
    [UIView commitAnimations];
    
     NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    
    NSLog(@"%@",userInfoDic);
   // [self.view setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];

    helperButton.layer.cornerRadius = 8;
    helperButton.layer.borderWidth = 4;
    helperButton.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    seekerButton.layer.cornerRadius = 8;
    seekerButton.layer.borderWidth = 4;
    seekerButton.layer.borderColor = [UIColor clearColor].CGColor;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([check isEqualToString:@"Helper"]) {
//        check =@"Helper";
//    }
//    else{
//        check =@"Seeker";
//
//    }
//    if ([segue.identifier isEqualToString:@"HelperSeeker"]) {
//        HelpersCornerViewController *HSC=(HelpersCornerViewController*)[segue destinationViewController];
//        NSLog(@"%@",check);
//        [HSC setWhoIsHe:check];
//    }
//   
//
//}
- (IBAction)HelperBtnAction:(id)sender {
    
    
//HelpersCornerViewController *chicha= [[HelpersCornerViewController alloc] init];
//   check=@"Helper";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Helper" forKey:@"userType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"HelperSeeker" sender:self];
    
    
}

- (IBAction)seekerBtnAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Seeker" forKey:@"userType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"HelperSeeker" sender:self];
//    HelpersCornerViewController *chicha= [[HelpersCornerViewController alloc] init];
//    chicha.whoIsHe=@"Seeker";
     //[self performSegueWithIdentifier:@"HelperSeeker" sender:self];
}
@end
