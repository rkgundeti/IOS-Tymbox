//
//  SeekHelpEntryScreen.m
//  TymBox
//
//  Created by Vertex Offshore on 5/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "SeekHelpEntryScreen.h"
#import "SeekHelpTableViewCell.h"
#import "Helper.h"
#import "MapHelperTalentViewController.h"
@interface SeekHelpEntryScreen ()
{
    NSString *userId;
    NSMutableArray *friendsArray;
    NSArray *FriendsjsonArray;
    NSString *getFriendsURl;
    NSString *getFriendsURl2;
    NSMutableArray *friendsIds;
    NSMutableArray *nameOfTheFriends;
    NSMutableArray *totalHelpers;
    NSString *check;
    

}
@end

@implementation SeekHelpEntryScreen
@synthesize segment,tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Seek Help";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
    friendsArray = [[NSMutableArray alloc] init];
    totalHelpers = [[NSMutableArray alloc] init];
    friendsIds = [NSMutableArray array];
    nameOfTheFriends= [NSMutableArray array];
    
    getFriendsURl = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId];
    
    getFriendsURl2 = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@&ReferTo=ReferTo",userId];
    
    [self getHelperTransactions:getFriendsURl];
    [self getHelperTransactions2:getFriendsURl2];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    // Do any additional setup after loading the view.
}
-(void)getHelperTransactions2:(NSString *)RequestedUrl{
    
    
    NSURL *url6=[NSURL URLWithString:RequestedUrl];
    FriendsjsonArray = [self getResponse:url6];
    
    for (NSMutableDictionary *dict1 in FriendsjsonArray){
        
        if ([[dict1 objectForKey:@"status"] isEqualToString:@"Accepted"]) {
            Helper *c = [[Helper alloc] init];
            c.helperName = [dict1 objectForKey:@"itroducedByName"];
            c.helperId= [dict1 objectForKey:@"introduced_By"];
            c.talentsCount= [NSString stringWithFormat:@"%d",[self getTalents:c.helperId]];
            [totalHelpers addObject:c];
            [friendsIds addObject:[dict1 objectForKey:@"introduced_By"]];
            [nameOfTheFriends addObject:[dict1 objectForKey:@"itroducedByName"]];
           // [totalHelpers addObject:c];
            
        }
    }
    
    NSLog(@"%@",friendsIds);
 }
-(void)getHelperTransactions:(NSString *)RequestedUrl{
    
    
    NSURL *url6=[NSURL URLWithString:RequestedUrl];
    FriendsjsonArray = [self getResponse:url6];
    
    for (NSMutableDictionary *dict1 in FriendsjsonArray){
        
        if ([[dict1 objectForKey:@"status"] isEqualToString:@"Accepted"] &&  [[dict1 objectForKey:@"user_type"] isEqualToString:@"Helper"]) {
              Helper *c = [[Helper alloc] init];
            c.helperName = [dict1 objectForKey:@"referedToName"];
            c.helperId= [dict1 objectForKey:@"refered_to"];
            c.talentsCount= [NSString stringWithFormat:@"%d",[self getTalents:c.helperId]];
            [friendsIds addObject:[dict1 objectForKey:@"refered_to"]];
             [nameOfTheFriends addObject:[dict1 objectForKey:@"referedToName"]];
             [totalHelpers addObject:c];
            
        }
    }
    
    NSLog(@"%@",friendsIds);
    
    
    
}

-(NSInteger)getTalents: (NSString *) userIdString{
    
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserTalentServlet?userId=%@",userIdString]];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        if (!responseData)
        {
            NSLog(@"Download Error: %@", error.localizedDescription);
            
        }
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
   
    

    return jsonArray.count;
    
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    cell.helperNameLabel.text= h.helperName;
    cell.talentsCount.text=h.talentsCount;
    cell.imageView.image= [UIImage imageNamed:@"SeekImage.png"];
    
    // [self getInflowId:helperTransactionId];
    // NSMutableArray *array= [self getInflowId:helperTransactionId];
    //NSLog(@"%@",array);
    // Display recipe in the table cell
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table-row.png"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"People I know   Talents they have";
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string = @"People I know                         Talents they have";

    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    Helper *helpererm = (totalHelpers)[indexPath.row];
    // sendArray= [self getInflowId:helpererm.helperId];
    
    NSLog(@"%@",helpererm.helperId);
   check=helpererm.helperId;
    
    [self performSegueWithIdentifier:@"SelectedHelperTalents" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectedHelperTalents"]) {
        
        MapHelperTalentViewController *vc = segue.destinationViewController;
      
        vc.helperId = check;
        
        //vcToPushTo.idValue = [check intValue];
        
    }
    
 
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentSelection:(id)sender {
}
@end
