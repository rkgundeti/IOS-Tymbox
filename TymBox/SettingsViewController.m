//
//  SettingsViewController.m
//  TymBox030915
//
//  Created by Bhagavan on 3/23/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize notificationbtn,bankInfobtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Settings";
    
    notificationbtn.enabled = false;
    bankInfobtn.enabled= false;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Background_portrait.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
