//
//  SeekersOpenOffersViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 4/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "SeekersOpenOffersViewController.h"
#import "MBProgressHUD.h"
#import "SeekerTrans.h"
#import "SeekerOpenCell.h"
@interface SeekersOpenOffersViewController ()
{

    NSString *userID;
    NSMutableArray *totalArray;
    NSArray *jsonArray;

}
@end

@implementation SeekersOpenOffersViewController
@synthesize segment,tabelView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Open Offers";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]]];
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userID=[userInfoDic valueForKey:@"userId"];
    
    self.tabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getSeekerRequestsOffers];
    // Do any additional setup after loading the view.
}
-(void)getSeekerRequestsOffers{
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        
        
     
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
      
        
        
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetSeekerTrasactionServlet?userid=%@",userID]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        [theRequest setHTTPMethod:@"GET"];
        NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
        
        totalArray=[[NSMutableArray alloc] init];
        jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        for (NSMutableDictionary *dict in jsonArray)
        {
            NSLog(@"dict===%@",dict);
            
            
            SeekerTrans *c = [[SeekerTrans alloc] init];
            
            c.talentName = [dict objectForKey:@"talent_name"];
           // c.required_date = [dict objectForKey:@"required_date"];
            c.required_date=[self chnageDateFormat:[dict objectForKey:@"required_date"]];
            
            [totalArray addObject:c];
        }
        
        
        NSLog(@"%lu",(unsigned long)totalArray.count);
        /*
         int i;
         for (i=0; i<[jsonArray count]; i++) {
         //            [categoryArray addObject:[[jsonArray objectAtIndex:i] valueForKey:@"categryName"]];
         //            [categoryId addObject:[[jsonArray objectAtIndex:i] valueForKey:@"ID"]];
         
         }
         */
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
          
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tabelView reloadData];
            
            
        });
    });
    
    
    //    NSLog(@"%@",categoryArray);
    //    NSLog(@"%@",categoryId);
    //
    
}
-(NSString *) chnageDateFormat:(NSString *)firstString{
    NSString *dateString = firstString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *newDateString = [dateFormatter stringFromDate:date];

    return newDateString;
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
    return [totalArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeekerOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    SeekerTrans *h = (totalArray)[indexPath.row];
   // cell.helperName.text=h.helperName;
    cell.talentName.text=h.talentName;
    cell.date.text=h.required_date;
    
    cell.imageView.image= [UIImage imageNamed:@"SeekImage.png"];
    cell.helperName.text=@"Partha";
    
    
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
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];
    Helper *helpererm = (totalHelpers)[indexPath.row];
    sendArray= [self getInflowId:helpererm.helperId];
    // NSMutableArray *array= [self getInflowId:helperTransactionId];
    NSLog(@"%@",sendArray);
    
    [self performSegueWithIdentifier:@"ReachOut" sender:self];
    
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

- (IBAction)SegmentAction:(id)sender {
}
@end
