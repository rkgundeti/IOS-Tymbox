//
//  SeekerPFViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/29/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "SeekerPFViewController.h"
#import "TransMasterObj.h"
#import "TransDetObj.h"
#import "MBProgressHUD.h"
@interface SeekerPFViewController ()
{
    NSMutableArray *detArray;
    NSString *userId;
    NSString *userType;
    NSString *transId;
    NSString *helperId;
    NSString *seekerId;
    NSString *utId;
    NSMutableArray *ratingArray;
    NSString *selectedRowString;

}
@end

@implementation SeekerPFViewController
@synthesize tableView,scrollView;
@synthesize selectedObj,rateLabel,talentLabel,expenseLabel,totalLabel,statLabel,quantityLabel,unitLabel,seekerName,tymboxDate,actualDateLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"Post Feedback";
    ratingArray= [[NSMutableArray alloc] initWithObjects:@"High Five! Job well Done!",@"Never Landed",@"No comment on the job", nil];
    
  
 
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[[userInfoDic valueForKey:@"userId"] stringValue];
    userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    TransDetObj *detObj = [[TransDetObj alloc]init];
    
    detArray = [[NSMutableArray alloc]init];
    
    detArray = selectedObj.detArray;
    
    detObj = [detArray objectAtIndex:0];
    transId=selectedObj.transId;
    NSString *check= [NSString stringWithFormat:@"%@",selectedObj.userId];
    if ([userId isEqualToString:check]) {
        helperId=selectedObj.userId;
    }
     helperId=selectedObj.userId;
    seekerId = selectedObj.seekerId;
    utId=selectedObj.user_Talent_Id;
    rateLabel.text = [NSString stringWithFormat:@"%@",detObj.price];
    NSLog(@"%@",detObj.price);
    //rateTypeTxt.text = [NSString stringWithFormat:@"%@",rateType];
    // selectedHelperId = [NSString stringWithFormat:@"%@",selectedObj.userId];
    talentLabel.text =[NSString stringWithFormat:@"%@",selectedObj.user_Talent_Name];
    expenseLabel.text = [NSString stringWithFormat:@"%@",detObj.expense];
    totalLabel.text = [NSString stringWithFormat:@"%@",detObj.total];
    statLabel.text=@"Completed";
    seekerName.text =[NSString stringWithFormat:@"%@",selectedObj.seekerName];
    tymboxDate.text=@"NA";
    actualDateLabel.text = [NSString stringWithFormat:@"%@",selectedObj.job_Req_Date];
    quantityLabel.text=[NSString stringWithFormat:@"%@",detObj.quantity];
    unitLabel.text=@"Job";
    //oneTxtField.text = [NSString stringWithFormat:@"%@",detObj.quantity];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];


    // Do any additional setup after loading the view.
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [ratingArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [ratingArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    selectedRowString = selectedCell.textLabel.text;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}
- (IBAction)postFeedbackBtnAction:(id)sender {
    
    NSURL *requrl;
    NSString *posttring;
    NSMutableDictionary *Response;
    NSData *responseData;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    requrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateFeedbackServlet"]];
    
    posttring =[NSString stringWithFormat:@"{\"SeekerId\":\"%@\",\"HelperId\":\"%@\",\"UTID\":\"%@\",\"TransId\":\"%@\",\"Comments\":\"%@\",\"Helper_Rating\":\"%@\",\"Seeker_Rating\":\"%@\",\"user_type\":\"%@\"}",seekerId,helperId,utId,transId,@"",@"0",selectedRowString,userType];
    
    
    
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [posttring length]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:requrl];
    [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [posttring dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    if (!responseData)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        
    }
    //**************************************    AFTER GETTING RESPONSE    *******************************************
    NSDictionary *jsonDictionary;
    jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if (jsonDictionary == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Error in Api" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
        
        NSLog(@"JSON Error: %@", error);
    }
    
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"Successfully Inserted to DB"]) {
            
            UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Updated your feedback" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert1 show];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
    }
    
    

}
@end
