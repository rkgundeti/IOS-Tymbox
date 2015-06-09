//
//  calenderViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/26/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "calenderViewController.h"
#import "SACalendar.h"
#import "DateUtil.h"
@interface calenderViewController () <SACalendarDelegate>

@end

@implementation calenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SACalendar *calendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 50, 320, 500)
                                            scrollDirection:ScrollDirectionVertical
                                              pagingEnabled:YES];

    
    calendar.delegate = self;
    
    [self.view addSubview:calendar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    NSLog(@"%02i/%02/%i",month,year);
    
    NSLog(@"%i",day);
     NSLog(@"%i",month);
     NSLog(@"%i",year);
    NSString *finalString = [NSString stringWithFormat:@"%i/%i/%i",month,day,year];
    NSLog(@"%@",finalString);
    [[NSNotificationCenter defaultCenter] postNotificationName: @"Calender" object: finalString];
    [self dismissViewControllerAnimated:YES completion:nil];

}

// Prints out the month and year displaying on the calendar
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    NSLog(@"%02/%i",month,year);
    
    //NSString *date= [NSString stri]
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
