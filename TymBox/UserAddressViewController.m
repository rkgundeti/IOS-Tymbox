//
//  UserAddressViewController.m
//  TymBox030915
//
//  Created by Bhagavan on 3/23/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "UserAddressViewController.h"

@interface UserAddressViewController ()

@end

@implementation UserAddressViewController
@synthesize street,city,pinCode,country,state;
@synthesize streettxt,statetxt,citytxt,ziptxt,countrytxt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"country==%@===%@==%@==%@==%@",country,city,state,country,pinCode);
    if (![street isEqualToString:@""]) {
        streettxt.text = street;
    }
    if (![city isEqualToString:@""]) {
        citytxt.text = city;
    }
    if (![state isEqualToString:@""]) {
        statetxt.text = state;
    }
    if (![country isEqualToString:@""]) {
        countrytxt.text = country;
    }
    if (![pinCode isEqualToString:@""]) {
        ziptxt.text = pinCode;
    }
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Background_portrait.png"] drawInRect:self.view.bounds];
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"<" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 40, 30)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:eng_btn];
    
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    
    //NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil];
    
    //self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    
    self.title = @"Update Address";
    
    // Do any additional setup after loading the view.
}

- (IBAction)back:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)done:(id)sender {
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%@",self.streettxt.text] forKey:@"street"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.citytxt.text] forKey:@"city"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.statetxt.text] forKey:@"state"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.ziptxt.text] forKey:@"zip"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.countrytxt.text] forKey:@"country"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressupdate" object: dict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -60; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
