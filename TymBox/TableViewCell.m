//
//  TableViewCell.m
//  TableViewInsideCell
//
//  Created by Bushra on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewCell.h"
#import "TransDetObj.h"
#import "MyCustomCell.h"

@implementation TableViewCell

@synthesize tableViewInsideCell;
@synthesize data,dataArray,mainObj,offeredToLbl,offeredDateLbl,offeredTalentLbl,headerView;
@synthesize headerView1;

- (void)dealloc {
    
}

- (void)awakeFromNib
{
    
    // Initialization code
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"[dataArray count]===%d",[dataArray count]);
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
    }
    */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *loggedInuserId = [defaults stringForKey:@"user_id"];
    
    NSString *selectedMenu = [[NSUserDefaults standardUserDefaults] stringForKey:@"selectedMenu"];
    
    NSLog(@"dataArray===%@,    %d",dataArray,[dataArray count]);
    NSLog(@"===mainObj===%@",mainObj);
    
        
    UIGraphicsBeginImageContext(headerView.frame.size);
    //[[UIImage imageNamed:@"cellback.png"] drawInRect:headerView.bounds];
    [[UIImage imageNamed:@"table-row.png"] drawInRect:headerView.bounds];
    
    UIImage *headerImg2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    headerView.backgroundColor = [UIColor colorWithPatternImage:headerImg2];
    
    UIGraphicsBeginImageContext(headerView1.frame.size);
    [[UIImage imageNamed:@"ios5-texture.png"] drawInRect:headerView1.bounds];
    UIImage *headerImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    headerView1.backgroundColor = [UIColor colorWithPatternImage:headerImg];
    
    
    TransDetObj *detObj = [[TransDetObj alloc] init];
    detObj = [dataArray objectAtIndex:indexPath.row];
    
    NSLog(@"====%@,  %@,   %@",mainObj.userId,mainObj.user_Talent_Id,mainObj.job_Req_Date);
    
    if([selectedMenu isEqualToString:@"Helper"])
    {
        offeredToLbl.text = [NSString stringWithFormat:@"%@",mainObj.seekerName];
        
    }else if([selectedMenu isEqualToString:@"Seeker"])
    {
        //selectedTab = @"Request";
        offeredToLbl.text = [NSString stringWithFormat:@"%@",mainObj.userName];
        
    }
    
    
    offeredTalentLbl.text = [NSString stringWithFormat:@"%@",mainObj.user_Talent_Name];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateNotFormatted = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",mainObj.job_Req_Date]];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSString * dateFormatted = [dateFormatter stringFromDate:dateNotFormatted];
    
    offeredDateLbl.text = dateFormatted;
    
    
    MyCustomCell *myCellView = nil;
    static NSString *TableViewCellIdentifier = @"CountryCell";
    
    //this method dequeues an existing cell if one is available or creates a new one
    //if no cell is available for reuse, this method returns nil
    myCellView = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (myCellView == nil){
        //initialize the cell view from the xib file
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MyCustomCell"
                                                      owner:self options:nil];
        myCellView = (MyCustomCell *)[nibs objectAtIndex:0];
    }
    
    myCellView.quantityLObl.font = [UIFont boldSystemFontOfSize:12.0f];
    myCellView.quantityLObl.textAlignment =  NSTextAlignmentCenter;
    //myCellView.quantityLObl.layer.borderColor = [UIColor whiteColor].CGColor;
    //myCellView.quantityLObl.layer.borderWidth = 1.0;
    [myCellView.quantityLObl setTextColor:[UIColor whiteColor]];
    
    myCellView.priceLbl.font = [UIFont boldSystemFontOfSize:12.0f];
    myCellView.priceLbl.textAlignment =  NSTextAlignmentCenter;
    //myCellView.priceLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    //myCellView.priceLbl.layer.borderWidth = 1.0;
    [myCellView.priceLbl setTextColor:[UIColor whiteColor]];
    
    myCellView.expenseLbl.font = [UIFont boldSystemFontOfSize:12.0f];
    myCellView.expenseLbl.textAlignment =  NSTextAlignmentCenter;
    //myCellView.expenseLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    //myCellView.expenseLbl.layer.borderWidth = 1.0;
    [myCellView.expenseLbl setTextColor:[UIColor whiteColor]];
    
    myCellView.totalLbl.font = [UIFont boldSystemFontOfSize:12.0f];
    myCellView.totalLbl.textAlignment =  NSTextAlignmentCenter;
    //myCellView.totalLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    //myCellView.totalLbl.layer.borderWidth = 1.0;
    [myCellView.totalLbl setTextColor:[UIColor whiteColor]];
    
    myCellView.modifiedBy.font = [UIFont boldSystemFontOfSize:12.0f];
    myCellView.modifiedBy.textAlignment =  NSTextAlignmentLeft;
    //myCellView.totalLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    //myCellView.totalLbl.layer.borderWidth = 1.0;
    [myCellView.modifiedBy setTextColor:[UIColor redColor]];
    
    NSLog(@"===%@  ,%@  ,%@  ,%@",detObj.quantity,detObj.price,detObj.expense,detObj.total);
    NSLog(@"detObj.createdBy====%@",detObj.createdBy);
    
    myCellView.quantityLObl.text = [NSString stringWithFormat:@"%@",detObj.quantity];
    myCellView.priceLbl.text = [NSString stringWithFormat:@"%@",detObj.price];
    myCellView.expenseLbl.text = [NSString stringWithFormat:@"%@",detObj.expense];
    myCellView.totalLbl.text = [NSString stringWithFormat:@"%@",detObj.total];
    myCellView.modifiedBy.text = [NSString stringWithFormat:@"%@",detObj.createdBy];
    
    return myCellView;
    
    /*
    cell.textLabel.text = detObj.offeredDate;
    cell.detailTextLabel.text = detObj.offeredPrice;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"table-row.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    return cell;
    */
    
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}


@end
