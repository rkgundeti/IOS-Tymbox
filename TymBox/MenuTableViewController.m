//
//  MenuTableViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/20/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "MenuTableViewController.h"
#import "SWRevealViewController.h"
#import "MenuTableViewController.h"
#import "MyTalentsViewController.h"
#import "HelpersCornerViewController.h"
#import "UserAvailTableVCon.h"
#import "ShareTymboxViewController.h"
#import "HelperPeopleViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "ViewController.h"
#import "MyCoomitmentsController.h"
#import "Offer-Seeker-ViewCon.h"
@interface MenuTableViewController ()
{

    NSArray *menuImages;
     NSString *selectedMenu;
    BOOL Helper;
    
    NSString *loginType;
}
@end

@implementation MenuTableViewController{

    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    selectedMenu = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    if ([selectedMenu isEqualToString:@"Helper"]) {
        
        Helper=YES;
        
    }
    
    
    
    
    
    if (Helper) {
        
        
        menuImages=[[NSMutableArray alloc] initWithObjects:@"Helpers CornerM.png",@"Share TymboxM.png",@"Share TymboxM.png",@"Introduce FriendsM.png",@"Offer-HelpM.png",@"My-TalentsM.png",@"My-AvailabilityM.png",@"My-ProfileM.png",@"Job-HistoryM.png",@"AboutM.png",@"LogoutM.png", nil];
        
        menuItems=[[NSMutableArray alloc] initWithObjects:@"Helpers Corner",@"People", @"Share Tymbox", @"Introduce Friends",@"Offer Help", @"My Talents", @"My Avaliability", @"Job History", @"My Profile", @"About", @"Logout", nil];
    }
    
    
    else{
        
        
        menuItems = [[NSMutableArray alloc] initWithObjects:@"Seekers Corner",@"People", @"Share Tymbox", @"Introduce Friends",@"Seek Help", @"Job History", @"My Profile", @"About", @"Logout",nil];
        
        menuImages=[[NSMutableArray alloc] initWithObjects:@"Helpers CornerM.png",@"Share TymboxM.png",@"Share TymboxM.png",@"Introduce FriendsM.png",@"Offer-HelpM.png",@"Job-HistoryM.png",@"My-ProfileM.png",@"AboutM.png",@"LogoutM.png",nil];
        
        
    }

    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings-bg@2x.png"]];
    self.tableView.separatorColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"setting-menu-dividerM.png"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text=[menuItems objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:[menuImages objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell.textLabel.text isEqualToString:@"My Talents"]) {
        [self performSegueWithIdentifier:@"MyTalents" sender:self];
    }
    
    else if ([selectedCell.textLabel.text isEqualToString:@"My Avaliability"]){
     [self performSegueWithIdentifier:@"My avalibility" sender:self];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"People"]){
        [self performSegueWithIdentifier:@"HelpersPeople" sender:self];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"Offer Help"]){
        [self performSegueWithIdentifier:@"SOHelp" sender:self];
    }
   
    
    else if ([selectedCell.textLabel.text isEqualToString:@"Seekers Corner"]){
        [self performSegueWithIdentifier:@"HelpersCorner" sender:self];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"Helpers Corner"]){
        [self performSegueWithIdentifier:@"HelpersCorner" sender:self];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"Share Tymbox"]){
        [self performSegueWithIdentifier:@"ShareTymbox" sender:self];
    }
    
    else if ([selectedCell.textLabel.text isEqualToString:@"Introduce Friends"]){
        [self performSegueWithIdentifier:@"introduceFriends" sender:self];
    }
    else if ([selectedCell.textLabel.text isEqualToString:@"Job History"]){
        [self performSegueWithIdentifier:@"jobHIstory" sender:self];
    }
    
    else if ([selectedCell.textLabel.text isEqualToString:@"My Profile"]){
        [self performSegueWithIdentifier:@"My Profile" sender:self];
    }
    
   
    else if ([selectedCell.textLabel.text isEqualToString:@"Logout"]){
        
        
        NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
        
 NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
        
        loginType=[userInfoDic valueForKey:@"loginType"];
          ViewController *hi=[[ViewController alloc] init];
        
        if ([loginType isEqualToString:@"FB"]) {
           // [hi facebookLoginBtnTouched:self];
             [FBSession.activeSession closeAndClearTokenInformation];
        }
        
        else{
        
           
            [hi signOut ];
        }
        NSLog(@"defs===%@",defs);
        [defs removeObjectForKey:@"userInfo"];
        
        NSDictionary * dict = [defs dictionaryRepresentation];
        for (id key in dict) {
            NSLog(@"%@",key);
            [defs removeObjectForKey:key];
        }
        [defs synchronize];
        
        
        [self performSegueWithIdentifier:@"Logout" sender:self];
        
        
        
        
    }
  
   // [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"MyTalents"]) {
        UINavigationController *navController = segue.destinationViewController;
        MyTalentsViewController *photoController = [navController childViewControllers].firstObject;
        NSLog(@"photoController===%@",photoController);
//       NSString *photoFilename = [NSString stringWithFormat:@"%@_photo", [menuItems objectAtIndex:indexPath.row]];
//        photoController.photoFilename = photoFilename;
    }
    
    
   
    else if ([segue.identifier isEqualToString:@"My avalibility"]){
    
    
        UserAvailTableVCon *navController = segue.destinationViewController;
        NSLog(@"photoController===%@",navController);
//        UserAvailTableVCon *photoController = [navController childViewControllers].firstObject;
    
    
    }
    
    else if ([segue.identifier isEqualToString:@"SOHelp"]){
        
        
        Offer_Seeker_ViewCon *navController = segue.destinationViewController;
        
        navController.comingFromMenu=YES;
        //        UserAvailTableVCon *photoController = [navController childViewControllers].firstObject;
        
        
    }
    
    else if ([segue.identifier isEqualToString:@"jobHIstory"]){
        
        
        MyCoomitmentsController *navController = segue.destinationViewController;
        navController.ComingFromJobHistory=YES;
        //        UserAvailTableVCon *photoController = [navController childViewControllers].firstObject;
        
        
    }
    else if ([segue.identifier isEqualToString:@"HelpersPeople"]){
        
        
        UINavigationController *navController = segue.destinationViewController;
        HelperPeopleViewController *photoController = [navController childViewControllers].firstObject;
        NSLog(@"photoController===%@",photoController);
        
    }
    
    else if ([segue.identifier isEqualToString:@"introduceFriends"]){
        
        
        UINavigationController *navController = segue.destinationViewController;
        UserAvailTableVCon *photoController = [navController childViewControllers].firstObject;
         NSLog(@"photoController===%@",photoController);
        
    }
    
    else if ([segue.identifier isEqualToString:@"Share Tymbox"]){
        
        
        UINavigationController *navController = segue.destinationViewController;
        ShareTymboxViewController *photoController = [navController childViewControllers].firstObject;
         NSLog(@"photoController===%@",photoController);
        
    }
    else if ([segue.identifier isEqualToString:@"My Profile"]){
        
        
        UINavigationController *navController = segue.destinationViewController;
        ProfileViewController *photoController = [navController childViewControllers].firstObject;
         NSLog(@"photoController===%@",photoController);
        
    }
    else if ([segue.identifier isEqualToString:@"HelpersCorner"]) {
//        UINavigationController *navController = segue.destinationViewController;
//        HelpersCornerViewController *photoController = [navController childViewControllers].firstObject;
        
        HelpersCornerViewController  *photo= segue.destinationViewController;
         NSLog(@"photoController===%@",photo);
        //       NSString *photoFilename = [NSString stringWithFormat:@"%@_photo", [menuItems objectAtIndex:indexPath.row]];
        //        photoController.photoFilename = photoFilename;
    }
    
    
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
       swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
        
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
