//
//  PostFeedbackViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/27/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "PostFeedbackViewController.h"
#import "TransMasterObj.h"
#import "TransDetObj.h"
#import "MBProgressHUD.h"
@interface PostFeedbackViewController ()
{
 NSMutableArray *detArray;
NSString *userId;
NSString *userType;
    NSString *transId;
    NSString *helperId;
    NSString *seekerId;
    NSString *utId;
    int finalRating;
    NSString *FR;
}
@end

@implementation PostFeedbackViewController
@synthesize rateView;
@synthesize statusLabel,selectedObj,rateLabel,talentLabel,expenseLabel,totalLabel,statLabel,seekerName,actualDateLabel,tymboxDate,quantityLabel,unitLabel;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title= @"Post Feedback";
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
    self.rateView.notSelectedImage = [UIImage imageNamed:@"Empty.png"];
   // self.rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"Full.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    // Do any additional setup after loading the view.
}
- (void)viewDidUnload
{
    [self setRateView:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    self.statusLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];
    finalRating= (int)rating;
    FR= [NSString stringWithFormat:@"%d",finalRating];
    
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

- (IBAction)postFeedbackBtnAction:(id)sender {
    
    NSURL *requrl;
    NSString *posttring;
    NSMutableDictionary *Response;
    NSData *responseData;
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    requrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/CreateFeedbackServlet"]];
    
    posttring =[NSString stringWithFormat:@"{\"SeekerId\":\"%@\",\"HelperId\":\"%@\",\"UTID\":\"%@\",\"TransId\":\"%@\",\"Comments\":\"%@\",\"Helper_Rating\":\"%@\",\"Seeker_Rating\":\"%@\",\"user_type\":\"%@\"}",seekerId,helperId,utId,transId,@"",FR,@"",userType];
    

    
    
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
            
            UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Request Sent sucessfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert1 show];
            
            
        }
    }

    
    
}
@end
