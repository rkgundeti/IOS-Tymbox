//
//  SeekHelpViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/2/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "SeekHelpViewController.h"
#import "SeekHelpTableViewCell.h"
#import "MBProgressHUD.h"
#import "Helper.h"
#import "TalentsListViewController.h"
#import "showTalentsTableViewController.h"
#import "SeekerReachOutController.h"
@interface SeekHelpViewController ()
{
 NSString *userId;
NSMutableArray *totalHelpers;
NSMutableArray *jsonArray;
    NSMutableArray *friendsArray;
    NSArray *FriendsjsonArray;
    NSString *checkId;
    NSString *talentID;
    NSMutableArray *sendArray;
    NSString *getFriendsURl;
    NSString *getFriendsURl2;
    NSMutableArray *friendsIds;
    NSMutableDictionary *sendDictionary;
}
@end

@implementation SeekHelpViewController
@synthesize CategoryTxtField,talentTxtField;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Seekers Corner";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
    friendsArray = [[NSMutableArray alloc] init];
    friendsIds = [NSMutableArray array];
    
     getFriendsURl = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId];
    
     getFriendsURl2 = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@&ReferTo=ReferTo",userId];
    
    http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=45&ReferTo=ReferTo
    [self getHelperTransactions:getFriendsURl];
    [self getHelperTransactions2:getFriendsURl2];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
   // [self getAllHelpers];
    // Do any additional setup after loading the view.
}

-(void)getHelperTransactions2:(NSString *)RequestedUrl{
   
    
    NSURL *url6=[NSURL URLWithString:RequestedUrl];
    FriendsjsonArray = [self getResponse:url6];
    
    for (NSMutableDictionary *dict1 in FriendsjsonArray){
        
        if ([[dict1 objectForKey:@"status"] isEqualToString:@"Accepted"]) {
            
            [friendsIds addObject:[dict1 objectForKey:@"introduced_By"]];
            
        }
    }
    
    NSLog(@"%@",friendsIds);
    
    
    
}
-(void)getHelperTransactions:(NSString *)RequestedUrl{
 
    
     NSURL *url6=[NSURL URLWithString:RequestedUrl];
     FriendsjsonArray = [self getResponse:url6];
    
    for (NSMutableDictionary *dict1 in FriendsjsonArray){
        
        if ([[dict1 objectForKey:@"status"] isEqualToString:@"Accepted"] &&  [[dict1 objectForKey:@"user_type"] isEqualToString:@"Helper"]) {
           
            [friendsIds addObject:[dict1 objectForKey:@"refered_to"]];
            
            }
    }
    
    NSLog(@"%@",friendsIds);



}

-(NSMutableArray *)getResponse:(NSURL *) stringUrl{
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    //        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.42:8080/TymBoxWeb/CategoryServlet"]];
    // http://192.168.0.187:8080/TymBoxWeb/CategoryServlet
    
    
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:stringUrl];
    [theRequest setHTTPMethod:@"GET"];
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    
    return arr;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==0) {
        [self performSegueWithIdentifier:@"GetCategory" sender:self];
    }
    else if (textField.tag==1) {
        [self performSegueWithIdentifier:@"GetTalent" sender:self];

    }

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GetTalent"]) {
        
        showTalentsTableViewController *vc = (showTalentsTableViewController *)[[segue destinationViewController] topViewController];
        //        NSLog(@"%@",idLabel.text);
//        NSString *check = [NSString stringWithFormat:@"%@",idLabel.text];
//        //vcToPushTo.selectedIdToShow =
//        
//        NSString *check1 = @"Sadik";
        vc.selectedIdToShow = checkId;
        
        //vcToPushTo.idValue = [check intValue];
        
    }
    
  else if ([segue.identifier isEqualToString:@"ReachOut"]) {
        
        SeekerReachOutController *detail= [segue destinationViewController];
       NSLog(@"%@",sendDictionary);
        detail.sendDictionary=sendDictionary;
        
    }

}
- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[TalentsListViewController class]]) {
        TalentsListViewController *colorsViewConroller = segue.sourceViewController;
        if (colorsViewConroller.selectedCategory) {
            CategoryTxtField.text = colorsViewConroller.selectedCategory;
            checkId = colorsViewConroller.selectedCategoryId;
            NSLog(@"%@",colorsViewConroller.selectedCategory);
        }
    }
    
}
- (IBAction)unwindToList2:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[showTalentsTableViewController class]]) {
        showTalentsTableViewController *colorsViewConroller = segue.sourceViewController;
        if (colorsViewConroller.selectedTalent) {
            talentTxtField.text =  colorsViewConroller.selectedTalent;
            //talentLabel.text = colorsViewConroller.selectedTalent;
            talentID = colorsViewConroller.TalentId;
            // idLabel.text = colorsViewConroller.selectedCategoryId;
            [self getAllHelpers];
            NSLog(@"%@",colorsViewConroller.selectedTalent);
        }
    }
    
}

-(void)getAllHelpers{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
             
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
       
        
        
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/HelperListServlet?userid=%@&tid=%@",userId,talentID]];
        
        
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        totalHelpers=[[NSMutableArray alloc] init];
        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        for (NSMutableDictionary *dict in jsonArray)
        {
            NSLog(@"dict===%@",dict);
            
            
            Helper *c = [[Helper alloc] init];
            c.helperName = [dict objectForKey:@"user_Name"];
            c.helperId= [dict objectForKey:@"user_Id"];
            
            if ([friendsIds containsObject:[dict objectForKey:@"user_Id"]]) {
                 [totalHelpers addObject:c];
            }
            else{
                NSLog(@"Not his friends");
            
            }
           // c.numberOfTalents = [dict objectForKey:@"talent_name"];
           
            
           
        }
        
        
     //   NSLog(@"%lu",(unsigned long)totalTransactions.count);
       
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
            
            
        });
    });
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [totalHelpers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeekHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Helper *h = (totalHelpers)[indexPath.row];
    cell.helperNameLabel.text=h.helperName;
    cell.imageView.image= [UIImage imageNamed:@"SeekImage.png"];
  
    
    
 
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    Helper *helpererm = (totalHelpers)[indexPath.row];
   // sendArray= [self getInflowId:helpererm.helperId];
    
    NSLog(@"%@",helpererm.helperId);
     NSLog(@"%@",helpererm.helperName);
    NSLog(@"%@",talentTxtField.text);
    
    
    sendDictionary = [[NSMutableDictionary alloc] init];
    //[sendDictionary setValue:helpererm.helperId forKey:@"HelperId"];
    
    [sendDictionary setObject:helpererm.helperId forKey:@"HelperId"];
    
   // [sendDictionary setValue:helpererm.helperName forKey:@"HelperName"];
    
     [sendDictionary setObject:helpererm.helperName forKey:@"HelperName"];
    
   // [sendDictionary setValue:talentTxtField.text forKey:@"TalentName"];
    
    [sendDictionary setObject:talentTxtField.text forKey:@"TalentName"];
    // NSMutableArray *array= [self getInflowId:helperTransactionId];
    NSLog(@"%@",sendArray);
    
    [self performSegueWithIdentifier:@"ReachOut" sender:self];
    
}


-(NSMutableArray*)getInflowId:(NSString*)title
{
    
    for (int i=0; i< [jsonArray count]; i++)
    {
        NSString *TITle = [[jsonArray objectAtIndex:i] objectForKey:@"userId"];
        
        if([TITle isEqual:title])
        {
            return [jsonArray objectAtIndex:i];
        }
        
    }
    
    return nil;
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
