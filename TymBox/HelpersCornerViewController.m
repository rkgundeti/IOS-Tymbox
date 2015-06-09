//
//  HelpersCornerViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/18/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "HelpersCornerViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "Offer-Seeker-ViewCon.h"
#include "MyTalentsViewController.h"
@interface HelpersCornerViewController ()
{

    BOOL helperHasTalents;
    NSString *userId;
    NSMutableArray *dataArray;
    NSString *selectedMenu;
    
    BOOL Helper;
}
@end

@implementation HelpersCornerViewController
@synthesize offerHelpButton,openOffersButton,openInvitationsButton,myCommitmentsButton,leaveFeedbackButton,whoIsHe;

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
     selectedMenu = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    
    if ([selectedMenu isEqualToString:@"Helper"]) {
        
        Helper=YES;
        
    }
    
    if (Helper) {
        
        [self.offerHelpButton setTitle:@"Offer Help" forState:UIControlStateNormal];
         [self.myCommitmentsButton setTitle:@"My Commitments" forState:UIControlStateNormal];
        //offerHelpButton.titleLabel.text=@"Offer Help";
    }
    else{
    [self.offerHelpButton setTitle:@"Seek Help" forState:UIControlStateNormal];
    [self.myCommitmentsButton setTitle:@"Helpers Coming" forState:UIControlStateNormal];
      //offerHelpButton.titleLabel.text=@"Seek Help";
    }
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedMenu = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    if ([selectedMenu isEqualToString:@"Helper"]) {
         self.title=@"Helpers Corner";
       // offerHelpButton.titleLabel.text=@"Offer Help";
    }
    else{
    self.title=@"Seekers Corner";
         //offerHelpButton.titleLabel.text=@"Seek Help";
    }
    
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
    NSLog(@"%@",whoIsHe);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];

   //[self.view setBackgroundColor:[UIColor clearColor]];
    
    // Chnaging the Button corner radius
    
    offerHelpButton.layer.cornerRadius = 8;
    offerHelpButton.layer.borderWidth = 4;
    offerHelpButton.layer.borderColor = [UIColor clearColor].CGColor;
    openOffersButton.layer.cornerRadius = 8;
    openOffersButton.layer.borderWidth = 4;
    openOffersButton.layer.borderColor = [UIColor clearColor].CGColor;
    openInvitationsButton.layer.cornerRadius = 8;
    openInvitationsButton.layer.borderWidth = 4;
    openInvitationsButton.layer.borderColor = [UIColor clearColor].CGColor;
    myCommitmentsButton.layer.cornerRadius = 8;
    myCommitmentsButton.layer.borderWidth = 4;
    myCommitmentsButton.layer.borderColor = [UIColor clearColor].CGColor;
    leaveFeedbackButton.layer.cornerRadius = 8;
    leaveFeedbackButton.layer.borderWidth = 4;
    leaveFeedbackButton.layer.borderColor = [UIColor clearColor].CGColor;
    // Chnaging the Button corner radius
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
//    UIBarButtonItem *leftMenuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon.png"] style:NO target:self action:@selector(revealToggle:)];
//    self.navigationItem.leftBarButtonItem = leftMenuButton;
    // Do any additional setup after loading the view.
}
-(void) checkForTalentCount{


   NSString  *URL_LOGIN = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",userId];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            
            if (jsonArray.count==0) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Tymbox"
                                              message:@"You don't have talents"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"Add Talent"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [self performSegueWithIdentifier:@"addTalentfromOH" sender:self];
                                         
                                     }];
                
                [alert addAction:ok];
                
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            
            else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];

             [self performSegueWithIdentifier:@"offerHelpM" sender:self];
            
            }
            }
    }

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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"offerHelpM"]) {
    
        Offer_Seeker_ViewCon *OFV= segue.destinationViewController;
        NSLog(@"OFV====%@",OFV);
    }
    
    else if([segue.identifier isEqualToString:@"addTalentfromOH"])
    {
        MyTalentsViewController *destViewController = segue.destinationViewController;
        //destViewController.update=YES;
        destViewController.comingFromOfferHelp = YES;
    }


}
- (IBAction)offerHelpBtnAction:(id)sender {
    if ([offerHelpButton.titleLabel.text isEqualToString:@"Offer Help"]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD showWhileExecuting:@selector(checkForTalentCount) onTarget:self withObject:nil animated:YES];
    }
    else{
    
        [self performSegueWithIdentifier:@"offerHelpM" sender:self];
    }
  
   
    
}
@end
