//
//  HelperPfferViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 3/30/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "HelperPfferViewController.h"

@interface HelperPfferViewController ()
{
    NSArray *morningArray;
    NSArray *hoursArray;
     NSString *check;
    UIPickerView * pickerView;
    UIView  *pickerParentView ;
}
@end

@implementation HelperPfferViewController
@synthesize scrollView,helpWhoTxtField,helpWithWhatTxtField,whatDateTxtField,morningTxtField,oneTxtFeid,jobTxtField,priceTxtField,expenseTxtField,totalTxtField;
- (void)viewDidLoad {
    [super viewDidLoad];
   [scrollView setContentSize:CGSizeMake(320, 1005)];
    
    morningArray = [[NSArray alloc] initWithObjects:@"Morning",@"Afternoon",@"Evening", nil];
    hoursArray = [[NSArray alloc] initWithObjects:@"Hours",@"Day",@"One Job", nil];
    // Do any additional setup after loading the view.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    // [self animateTextField:textField up:YES];
    
       if (textField.tag==0) {
        check=@"";
        [self performSegueWithIdentifier:@"helperTalents" sender:self];
    }
    
    else if (textField.tag==1) {
        //        offerHelpTalentsTableViewController *colorsViewConroller = [[offerHelpTalentsTableViewController alloc] init];
        //        //BOOL check= YES;
        //        NSString *check = @"Seek";
        //        colorsViewConroller.value= check;
        check = @"Seek";
        [self performSegueWithIdentifier:@"helperTalents" sender:self];
        
        
    }
    
    else if (textField.tag==3 || textField.tag == 5){
        
        pickerView = [[UIPickerView alloc] init];
        pickerView.tag=textField.tag;
        [pickerView setDataSource: self];
        [pickerView setDelegate: self];
        pickerView.showsSelectionIndicator = YES;
        pickerView.backgroundColor = [UIColor whiteColor];
        // perTxtField.inputView = pickerView;
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutData)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearData)];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexible, doneButton, nil]];
        // perTxtField.inputAccessoryView = toolBar;
        pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
        [pickerParentView addSubview:pickerView];
        [pickerParentView addSubview:toolBar];
       // [self.view addSubview:pickerParentView];
        
        
        textField.inputView = pickerParentView;
    }
    else if (textField.tag==10){
        [self performSegueWithIdentifier:@"showCalender" sender:self];
    }
    else if (textField.tag==6){
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
       // morningTxtField.inputAccessoryView=UIKeyboardTypeNumberPad;
    }
    //[textField resignFirstResponder];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    if (pickerView.tag == 3){
        return [morningArray count];
    }
    else{
        return [hoursArray count];
    }}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (pickerView.tag == 3){
        return [morningArray objectAtIndex:row];
    }
    else{
        return [hoursArray objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 3){
        morningTxtField.text = [morningArray objectAtIndex:row];
    }
    else{
        jobTxtField.text = [hoursArray objectAtIndex:row];
    }
    
    //Write the required logic here that should happen after you select a row in Picker View.
}
-(void)pickerDoneClicked:(id)sender{
    
    [pickerParentView removeFromSuperview];
    // [MorningTxtField resignFirstResponder];
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    ///[textField resignFirstResponder];
   
    [textField resignFirstResponder];
    
    return YES;
    
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

@end
