//
//  offerAvavlibilityTableViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/25/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "offerAvavlibilityTableViewController.h"
#import "UserAvailableObj.h"
#import "offerAvalibilityTableViewCell.h"
@interface offerAvavlibilityTableViewController ()
{
    NSMutableArray *userAvailservice;
        NSMutableDictionary *availService;

    NSMutableArray *dateArray;
    NSMutableArray *dayArray;
    NSMutableArray *morningArray;
    NSMutableArray *aftrenoonArray;
    NSMutableArray *eveningArray;
}
@end

@implementation offerAvavlibilityTableViewController
@synthesize selectedDate,selectedDay,selectedTime;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getThingsDone];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getThingsDone{

    dateArray = [NSMutableArray array];
    dayArray = [NSMutableArray array];
    morningArray = [NSMutableArray array];
    aftrenoonArray = [NSMutableArray array];
    eveningArray = [NSMutableArray array];
    
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *URL_LOGIN = @"http://hyd.vertexcs.com:8081/TymBoxWeb/GetUserAvailabilityServlet?userid=1";
            
            
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
            NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
            
            NSLog(@"responseCode====%@",responseCode);
            NSLog(@"~~~~~ Status code: %d", [response statusCode]);
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                //Stop your activity indicator or anything else with the GUI
                
                if(respData != nil){
                    
                    if ([response statusCode] >= 200 && [response statusCode] < 300) {
                        
                        NSError *serializeError = nil;
                        NSMutableArray *jsonArray = [NSJSONSerialization
                                                     JSONObjectWithData:respData
                                                     options:NSJSONReadingMutableContainers
                                                     error:&serializeError];
                        
                        userAvailservice = [[NSMutableArray alloc]init];
                        availService = [NSMutableDictionary dictionary];
                        
                        for (NSMutableDictionary *dict in jsonArray)
                        {
                            NSLog(@"dict===%@",dict);
                            
//                            [dateArray addObject:[dict objectForKey:@"Date"]];
//                            [dayArray addObject:[dict objectForKey:@"Date"]];
//                            [morningArray addObject:[dict objectForKey:@"Date"]];
//                            [aftrenoonArray addObject:[dict objectForKey:@"Date"]];
//                            [eveningArray addObject:[dict objectForKey:@"Date"]];
                            
                            UserAvailableObj *c = [[UserAvailableObj alloc] init];
                            c.UID = [dict objectForKey:@"UID"];
                            c.Day = [dict objectForKey:@"Day"];
                            c.Date = [dict objectForKey:@"Date"];
                            c.Morning = [dict objectForKey:@"Morning"];
                            c.Afternoon = [dict objectForKey:@"Afternoon"];
                            c.Evening = [dict objectForKey:@"Evening"];
                            
                            [userAvailservice addObject:c];
                            
                            [availService setObject:c forKey:[dict objectForKey:@"Date"]];
                        }
                    }else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    
                }else
                {
                    
                    //if ([responseCode isEqualToString:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Problem with DB Service" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    //}
                }
                NSLog(@"userAvailservice====%@",userAvailservice);
                
                NSLog(@"availService====%@",[availService allKeys]);
                
                NSLog(@"%@",availService);
                
                
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
    return [userAvailservice count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    offerAvalibilityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UserAvailableObj *tempObject= [userAvailservice objectAtIndex:indexPath.row];
    
    cell.dateLabel.text = tempObject.Date;
    cell.dayLabel.text = tempObject.Day;
    
    
//     cell.morningBtn.titleLabel.text=@"MButton";
//     cell.afterBtn.titleLabel.text=@"AButton";
//     cell.eveningBtn.titleLabel.text=@"EButton";
    
    cell.morningBtn.tag = indexPath.row;
    [cell.morningBtn addTarget:self action:@selector(morBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([tempObject.Morning isEqualToString:@"Available"]) {
        [cell.morningBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.morningBtn setBackgroundImage:[UIImage imageNamed:@"morning.png"] forState:UIControlStateNormal];
    }
    
    
    cell.afterBtn.tag = indexPath.row;
    [cell.afterBtn addTarget:self action:@selector(afterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([tempObject.Afternoon isEqualToString:@"Available"]) {
        [cell.afterBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.afterBtn setBackgroundImage:[UIImage imageNamed:@"afternoon.png"] forState:UIControlStateNormal];
    }
    
    cell.eveningBtn.tag = indexPath.row;
    [cell.eveningBtn addTarget:self action:@selector(eveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([tempObject.Evening isEqualToString:@"Available"]) {
        [cell.eveningBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.eveningBtn setBackgroundImage:[UIImage imageNamed:@"night.png"] forState:UIControlStateNormal];
    }

    /*
    cell.morningBtn.tag= indexPath.row;
    
    if ([tempObject.Morning isEqualToString:@"Available"]) {
        if ([cell.morningBtn.titleLabel.text isEqualToString:@"MButton"]) {
            cell.morningBtn.titleLabel.text=@"Available";
        }
             
    }
    else{
        if ([cell.morningBtn.titleLabel.text isEqualToString:@"MButton"]) {
            cell.morningBtn.titleLabel.text=@"Not";
        }
    }
     cell.afterBtn.tag= indexPath.row;
    if ([tempObject.Afternoon isEqualToString:@"Available"]) {
        
        cell.afterBtn.titleLabel.text=@"Available";
        
    }
    else{
        cell.afterBtn.titleLabel.text=@"Not";
    }
     cell.eveningBtn.tag= indexPath.row;
    if ([tempObject.Evening isEqualToString:@"Available"]) {
        
        cell.eveningBtn.titleLabel.text=@"Available";
        
    }
    else{
        cell.eveningBtn.titleLabel.text=@"Not";
    }
    
    */
    
//    UserAvailableObj *tempObject = [userAvailibities objectAtIndex:indexPath.row];
//    NSLog(@"tempObject===%@====%@",tempObject.Date,tempObject.Day);
//    cell.Date.text = tempObject.Date;
//    
//    cell.Day.text = tempObject.Day;
    

    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
   
//    UserAvailableObj *tempObject= [userAvailservice objectAtIndex:indexPath.row];
//    self.selectedDate = tempObject.Date;
//    self.selectedTime = @"Morning";
//    
//       //self.selectedTalent = [categoryId[indexPath.row] stringValue];
//    
//    // NSInteger *check =[self getCategoryId:self.selectedCategory];
//    //self.selectedCategoryId=
//    
//    [self performSegueWithIdentifier:@"closeMyTime" sender:self];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)morBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
    UserAvailableObj *tempObject = [userAvailservice objectAtIndex:senderButton.tag];
    if ([tempObject.Morning isEqualToString:@"Available"]) {
        
        self.selectedDate = tempObject.Date;
        self.selectedTime = @"Morning";
        [self performSegueWithIdentifier:@"closeMyTime" sender:self];}
    
    
    
    else{
        
        NSLog(@"He is not avalible");
    }

}
-(void)afterBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
     UserAvailableObj *tempObject = [userAvailservice objectAtIndex:senderButton.tag];

    if ([tempObject.Afternoon isEqualToString:@"Available"]) {
    
        self.selectedDate = tempObject.Date;
        self.selectedTime = @"Afternoon";
        [self performSegueWithIdentifier:@"closeMyTime" sender:self];}
 
   

else{

    NSLog(@"He is not avalible");
}
}
-(void)eveBtnClick:(id)sender {
    UIButton *senderButton = (UIButton *)sender;
     UserAvailableObj *tempObject = [userAvailservice objectAtIndex:senderButton.tag];
    
    if ([tempObject.Evening isEqualToString:@"Available"]) {
        
        self.selectedDate = tempObject.Date;
        self.selectedTime = @"Evening";
        [self performSegueWithIdentifier:@"closeMyTime" sender:self];}
    
    
    
    else{
        
        NSLog(@"He is not avalible");
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
