//
//  MyTalentsViewController.m
//  TymBox
//
//  Created by Vertex Offshore on 2/27/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "MyTalentsViewController.h"
#import "SWRevealViewController.h"
#import "TalentsListViewController.h"
#import "showTalentsTableViewController.h"
#import "WebService.h"
#import "MBProgressHUD.h"
@interface MyTalentsViewController ()

{
    NSString *checkId;
    NSString *talentID;
    UIPickerView * pickerView;
    UIView  *pickerParentView ;
    
    UIAlertController *alert;
    UIActivityIndicatorView *spinner;
    NSString *userId;
}
@end
@implementation MyTalentsViewController
@synthesize displayAllTheTalentsBtn,sideBarButton,TalentsList,TalentsSelectPickerView,searchTalentTxtFeild,idLabel,talentLabel,txtFieldTalent,snippetTxtField,rateTxtField,perTxtField,snippetTxtView,update,selectedTalentObj,addorUpdateAction,talentsBtn,addTalentsBtn,talentsButton,comingFromOfferHelp;
@synthesize existsTalents;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    
     [addTalentsBtn setTitle:@"Add Talent" forState:UIControlStateNormal];
    userId=[userInfoDic valueForKey:@"userId"];
    
    // self.navigationItem.leftBarButtonItem.enabled = NO;
    // [self.sideBarButton setEnabled:NO];
    
    self.navigationItem.hidesBackButton= NO;
    // [self.sideBarButton]
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background_portrait.png"]];
    
    
    [snippetTxtView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [snippetTxtView.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    snippetTxtView.layer.cornerRadius = 5;
    snippetTxtView.clipsToBounds = YES;
    // [self.view setBackgroundColor:[UIColor clearColor]];
    
    TalentsList= [[NSMutableArray alloc] initWithObjects:@"Hour",@"Day",@"Week", nil];
    //    SWRevealViewController *revealViewController = self.revealViewController;
    //    if ( revealViewController )
    //    {
    //        [self.sidebarButton setTarget: self.revealViewController];
    //        [self.sidebarButton setAction: @selector( revealToggle: )];
    //        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //    }
    
    
    
    //    http://192.168.2.42:8080/TymBoxWeb/AddNewUserTalentServlet?userId=8&talentId=7&rate=100&ratetype=high&desc=lakapote&createdby=rama&rating=5
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yourNotificationHandler:)
                                                 name:@"MODELVIEW DISMISS" object:nil];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    if([addorUpdateAction isEqualToString:@"Update"])
    {
        talentsButton.alpha =0;
        displayAllTheTalentsBtn.alpha =0;
        searchTalentTxtFeild.enabled = false;
        txtFieldTalent.enabled = false;
        
        searchTalentTxtFeild.text = selectedTalentObj.categoryName;
        txtFieldTalent.text = selectedTalentObj.talentName;
        NSLog(@"rate===%@",selectedTalentObj.rate);
        rateTxtField.text =[NSString stringWithFormat:@"%@",selectedTalentObj.rate];
        snippetTxtView.text = selectedTalentObj.comments;
        perTxtField.text = selectedTalentObj.rateType;
        NSLog(@"usertalentId===%@",selectedTalentObj.userTalentId);
        self.title = @"Update Talent";
//        NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
        
//        self.navigationController.navigationBar.titleTextAttributes = size;
        [addTalentsBtn setTitle:@"Update Talent" forState:UIControlStateNormal];
        //[addTalentBtn setTitle:@"Update Talent" forState:UIControlStateNormal];
    }
    
    else{
     [addTalentsBtn setTitle:@"Add Talent" forState:UIControlStateNormal];
    
    }
    
}
-(void)yourNotificationHandler:(NSNotification *)notice{
    NSString *str = [notice object];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[TalentsListViewController class]]) {
        TalentsListViewController *colorsViewConroller = segue.sourceViewController;
        if (colorsViewConroller.selectedCategory) {
            searchTalentTxtFeild.text = colorsViewConroller.selectedCategory;
            checkId = colorsViewConroller.selectedCategoryId;
            NSLog(@"%@",colorsViewConroller.selectedCategory);
        }
    }
    
}
- (IBAction)unwindToList2:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[showTalentsTableViewController class]]) {
        showTalentsTableViewController *colorsViewConroller = segue.sourceViewController;
        if (colorsViewConroller.selectedTalent) {
            txtFieldTalent.text =  colorsViewConroller.selectedTalent;
            talentLabel.text = colorsViewConroller.selectedTalent;
            talentID = colorsViewConroller.TalentId;
            // idLabel.text = colorsViewConroller.selectedCategoryId;
            NSLog(@"%@",colorsViewConroller.selectedTalent);
        }
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    
    //  [textField resignFirstResponder];
    if (textField.tag == 50) {
        
        //        pickerView = [[UIPickerView alloc] init];
        //        [pickerView sizeToFit];
        //        pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        //        pickerView.delegate = self;
        //        pickerView.dataSource = self;
        //        pickerView.showsSelectionIndicator = YES;
        //        //self.yourPickerView = pickerView;  //UIPickerView
        //
        //        perTxtField.inputView = pickerView;
        //
        //        // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
        //        // Prepare done button
        //        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        //        keyboardDoneButtonView.barStyle = UIBarStyleBlack;
        //        keyboardDoneButtonView.translucent = YES;
        //        keyboardDoneButtonView.tintColor = nil;
        //        [keyboardDoneButtonView sizeToFit];
        //
        //        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
        //                                                                        style:UIBarButtonItemStyleBordered target:self
        //                                                                       action:@selector(pickerDoneClicked:)];
        //
        //        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        //
        //        // Plug the keyboardDoneButtonView into the text field...
        //        perTxtField.inputAccessoryView = keyboardDoneButtonView;
        
        
        //            TalentsList= [[NSMutableArray alloc] initWithObjects:@"English",@"Spanish",@"French",@"Greek",
        //                         @"Japaneese",@"Korean",@"Hindi", nil];
        
        //            TalentsSelectPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
        //            TalentsSelectPickerView.showsSelectionIndicator = YES;
        //            TalentsSelectPickerView.hidden = NO;
        //            TalentsSelectPickerView.delegate = self;
        //            TalentsSelectPickerView.backgroundColor= [UIColor whiteColor];
        //            [self.view addSubview:TalentsSelectPickerView];
        
        
        // picker working//
        pickerView = [[UIPickerView alloc] init];
        [pickerView setDataSource: self];
        [pickerView setDelegate: self];
        pickerView.showsSelectionIndicator = YES;
        pickerView.backgroundColor = [UIColor whiteColor];
        // perTxtField.inputView = pickerView;
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutData:)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        //        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearData)];
        [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
        // perTxtField.inputAccessoryView = toolBar;
        pickerParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, 260)];
        [pickerParentView addSubview:pickerView];
        [pickerParentView addSubview:toolBar];
        perTxtField.inputView = pickerParentView;
        //  perTxtField.inputAccessoryView = toolBar;
        // [self.view addSubview:pickerParentView];
        
        // picker working
        //        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@" \n\n\n\n\n\n\n\n\n\n"
        //                                                              message:@""
        //                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        ////
        ////        pickerView = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
        ////        pickerView.momentary = YES;
        ////        closePicker.frame = CGRectMake(25, 0.0f, 50.0f, 30.0f);
        ////        closePicker.segmentedControlStyle = UISegmentedControlStyleBar;
        ////        closePicker.tintColor = [UIColor blackColor];
        ////        [closePicker addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
        ////        [alertController.view addSubview:closePicker];
        //
        //
        //        UIPickerView *pickerFiliter=[[UIPickerView alloc]init];
        //        pickerFiliter = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 40.0, 320.0, 120.0)];
        //        pickerFiliter.showsSelectionIndicator = YES;
        //        pickerFiliter.dataSource = self;
        //        pickerFiliter.delegate = self;
        //
        //        [alertController.view addSubview:pickerFiliter];
        //
        //
        //        [self presentViewController:alertController animated:YES completion:nil];
        
        
        //        - (IBAction)dismissActionSheet:(id)sender
        //        {
        //
        //            [alertController dismissViewControllerAnimated:YES completion:nil];
        //
        //        }
        
        //        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 180, 260)];
        //
        //        pickerView = [[UIPickerView alloc]init] ;
        //        pickerView.frame=CGRectMake(0, 44, 180,216);
        //        pickerView.delegate = self;
        //        pickerView.showsSelectionIndicator = YES;
        //
        //        UIToolbar* toolbar = [[UIToolbar alloc] init];
        //        toolbar.frame=CGRectMake(0,0,180,44);
        //        toolbar.barStyle = UIBarStyleBlackTranslucent;
        //        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //
        //
        //        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
        //                                                                       style:UIBarButtonItemStyleDone target:self
        //                                                                      action:@selector(doneClicked:)];
        //
        //
        //        [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
        //
        //        textField.inputAccessoryView = toolbar;
        //
        //        [view addSubview:toolbar];
        //        [view addSubview:pickerView];
        //        [self.view addSubview:view];
        
    }
    
}

-(void)pickerDoneClicked:(id)sender{
    
    [perTxtField resignFirstResponder];
    
}
-(void)logoutData:(id)sender{
    
    [perTxtField resignFirstResponder];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self animateTextView:textView up:YES];
//}
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//   [self animateTextView:textView up:NO];
//}
//- (void) animateTextView:(BOOL) up
//{
//    const int movementDistance =-130;; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    int movement= movement = (up ? -movementDistance : movementDistance);
//    NSLog(@"%d",movement);
//
//    [UIView beginAnimations: @"animateTextView" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)displayAllTheTalentsBtnAction:(id)sender {
    
    //    TalentsList= [[NSMutableArray alloc] initWithObjects:@"English",@"Spanish",@"French",@"Greek",
    //                 @"Japaneese",@"Korean",@"Hindi", nil];
    //
    //    TalentsSelectPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    //    TalentsSelectPickerView.showsSelectionIndicator = YES;
    //    TalentsSelectPickerView.hidden = NO;
    //    TalentsSelectPickerView.delegate = self;
    //    TalentsSelectPickerView.backgroundColor= [UIColor blueColor];
    //    [self.view addSubview:TalentsSelectPickerView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    return [TalentsList count];
}
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [TalentsList objectAtIndex:row];
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 300.0f, 60.0f)]; //x and width are mutually correlated
    
    label.textAlignment = NSTextAlignmentLeft;
    
    
    label.text = [TalentsList objectAtIndex:row];
    
    
    return label;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
    perTxtField.text = [TalentsList objectAtIndex:row];
    
    //Write the required logic here that should happen after you select a row in Picker View.
}
- (IBAction)AddTalentsBtnAction:(id)sender {
    
    
    NSString *alertList=@"" ;
    if ([snippetTxtView.text length]==0)
    {
        alertList=[(alertList) stringByAppendingString:@"\nPlease enter snippet of the Talent"];
    }
    
    if ([rateTxtField.text length] == 0){
        alertList=[(alertList) stringByAppendingString:@"\nPlease enter rate"];
        
    }
    
    if ([searchTalentTxtFeild.text length]==0) {
        alertList=[(alertList) stringByAppendingString:@"\nPlease select the Category"];
    }
    
    if ([txtFieldTalent.text length]==0) {
        alertList=[(alertList) stringByAppendingString:@"\nPlease select the talent"];
    }
    
    if ([alertList length]) {
        NSString *name = [NSString stringWithFormat:@"%@",alertList ];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:name delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    else{
        
        
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSString *serviceString;
        NSString *strdata;
        if([addorUpdateAction isEqualToString:@"Update"])
        {
            serviceString=@"http://hyd.vertexcs.com:8081/TymBoxWeb/UpdateUserTalentServlet";
            
            strdata =[NSString stringWithFormat:@"{\"userTalentId\":\"%@\",\"userId\":\"%@\",\"talentId\":\"%@\",\"userName\":\"%@\",\"categoryName\":\"%@\",\"talentName\":\"%@\",\"rate\":\"%@\",\"rateType\":\"%@\"}",selectedTalentObj.userTalentId,selectedTalentObj.userId,selectedTalentObj.talentId,selectedTalentObj.userName,selectedTalentObj.categoryName,selectedTalentObj.talentName,rateTxtField.text,perTxtField.text];
            
        }
        else{
            serviceString = [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/AddNewUserTalentServlet?userId=%@&talentId=%@&rate=%@&ratetype=%@&desc=%@&createdby=Sadik&rating=0",userId,talentID,rateTxtField.text,perTxtField.text,snippetTxtView.text];
        }
        
        NSString *key = [NSString stringWithFormat:@"%@-%@",talentID,perTxtField.text];
        if([existsTalents objectForKey:key])
        {
            NSString *msg = [NSString stringWithFormat:@"Record already exists with this (%@/%@/%@) combination",txtFieldTalent.text,rateTxtField.text,perTxtField.text];
            //[self alertStatus:@"Record already exists with this combination" :@"Error" :0];
            UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert1 show];
        }
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *escapedUrlString = [serviceString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            
            
            
            NSURL *url=[NSURL URLWithString:escapedUrlString];
            
            
            //    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            //       [theRequest setHTTPMethod:@"GET"];
            //    [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            NSData *requestData = [strdata dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            [theRequest setValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            NSString *msg;
            
            if([addorUpdateAction isEqualToString:@"Update"])
            {
                msg=@"Talent Updated";
                [theRequest setHTTPBody: requestData];
                [theRequest setHTTPMethod:@"POST"];
            }
            else{
                msg=@"Talent added";
                [theRequest setHTTPMethod:@"GET"];
            }
            
            
            NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
            
            if (!responseData)
            {
                NSLog(@"Download Error: %@", error.localizedDescription);
                
            }
            NSDictionary *jsonDictionary;
            jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            
            if (jsonDictionary == nil) {
                NSLog(@"JSON Error: %@", error);
            }
            
            else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([[jsonDictionary objectForKey:@"info"] isEqualToString:@"success"]) {
                    
                    UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert1 show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                
            }
        }
    }
}
- (IBAction)talentsBtnAction:(id)sender {
    
    if ([searchTalentTxtFeild.text length]==0) {
        UIAlertView *alert1= [[UIAlertView alloc] initWithTitle:@"" message:@"Please select the Category" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert1 show];
    }
    
    else{
        [self performSegueWithIdentifier:@"talentsTalents" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"talentsTalents"]) {
        
        showTalentsTableViewController *vc = (showTalentsTableViewController *)[[segue destinationViewController] topViewController];
        //        NSLog(@"%@",idLabel.text);
        NSString *check = [NSString stringWithFormat:@"%@",idLabel.text];
        //vcToPushTo.selectedIdToShow =
        
        NSString *check1 = @"Sadik";
        vc.selectedIdToShow = checkId;
        
        //vcToPushTo.idValue = [check intValue];
        
    }
}
- (IBAction)cancelBtnAction:(id)sender {
    [ self dismissViewControllerAnimated:YES completion:nil];
}
@end