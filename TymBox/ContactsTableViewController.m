//
//  ContactsTableViewController.m
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactObj.h"
#import "ContactTVCell.h"

#import <AddressBook/AddressBook.h>

@interface ContactsTableViewController ()
{
    NSString *loggedInuserId;
    NSString *userId;
}
@end

@implementation ContactsTableViewController
@synthesize tableData;
@synthesize filteredseekerArray;
@synthesize contactSearchBar;
@synthesize selectType,selectedHelper,selectedUserType;
@synthesize isFiltered;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"userInfo"];
    userId=[userInfoDic valueForKey:@"userId"];
    
    //userType = [[NSUserDefaults standardUserDefaults]stringForKey:@"userType"];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Background_portrait.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
    self.title=@"Contacts";
    
//    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:12.0],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor, nil];
//    
//    self.navigationController.navigationBar.titleTextAttributes = size;
    
    
    self.tableData = [[NSMutableArray alloc] init];

    if ([selectType isEqualToString:@"HelperSelect"] || [selectType isEqualToString:@"SeekerSelect"]) {
        [self getPersonOutOfAddressBook];
    }
    else{
        
        [self getTymBoxUserService];
        //
        
    }
    
    NSLog(@"====%lu",(unsigned long)[tableData count]);
    filteredseekerArray =[[NSMutableArray alloc] initWithCapacity:[tableData count]];
    [self.tableView reloadData];
    
    
}

-(void) getTymBoxUserService
{
    
      NSString *URL_LOGIN;
    
     URL_LOGIN= [NSString stringWithFormat:@"http://hyd.vertexcs.com:8081/TymBoxWeb/GetFriendListServlet?userid=%@",userId];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
    NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseCode = [NSString stringWithFormat:@"%ld",(long)[response statusCode]];
    
    NSLog(@"responseCode====%@",responseCode);
    NSLog(@"~~~~~ Status code: %ld", (long)[response statusCode]);
    
    
    if(respData != nil){
        
        if ([response statusCode] >= 200 && [response statusCode] < 300) {
            
            NSError *serializeError = nil;
            NSMutableArray *jsonArray = [NSJSONSerialization
                                         JSONObjectWithData:respData
                                         options:NSJSONReadingMutableContainers
                                         error:&serializeError];
            
            tableData = [[NSMutableArray alloc]init];
            //availService = [NSMutableDictionary dictionary];
            
            for (NSMutableDictionary *dict in jsonArray)
            {
                NSLog(@"dict===%@",dict);
                
                
                //NSString *downLoadedId=  [ [dict objectForKey:@"user_Id"] stringValue];
                
                 if ([selectedUserType isEqualToString:@"Helper"]) {
                     
                     if ([[dict objectForKey:@"user_type"] isEqualToString:@"Helper"]) {
                         ContactObj *c = [[ContactObj alloc] init];
                         c.fullName = [dict objectForKey:@"referedToName"];
                         c.userId = [dict objectForKey:@"refered_to"];
                         [tableData addObject:c];

                     }
                     
                 }
                
                 else {
                 
                     if ([[dict objectForKey:@"user_type"] isEqualToString:@"Seeker"]) {
                         ContactObj *c = [[ContactObj alloc] init];
                         c.fullName = [dict objectForKey:@"referedToName"];
                         c.userId = [dict objectForKey:@"refered_to"];
                         [tableData addObject:c];
                     }
                 }

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
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (void)getPersonOutOfAddressBook
{
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error) {
            NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
        }
        
        if (granted) {
            // if they gave you permission, then just carry on
            
            [self listPeopleInAddressBook:addressBook];
        } else {
            // however, if they didn't give you permission, handle it gracefully, for example...
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
        
        CFRelease(addressBook);
    });
//    CFErrorRef error = NULL;
//    
//    
//    
//   ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
//    
//    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
//        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//            
//            if (granted) {
//            
//                if (addressBookRef != nil)
//                {
//                    NSLog(@"Succesful.");
//                    
//                    NSArray *allContacts = (__bridge_transfer NSArray
//                                            *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
//                    NSUInteger i = 0;
//                    for (i = 0; i < [allContacts count]; i++)
//                    {
//                        ContactObj *person = [[ContactObj alloc] init];
//                        
//                        ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
//                        NSString *firstName = (__bridge_transfer NSString
//                                               *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
//                        NSString *lastName =  (__bridge_transfer NSString
//                                               *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
//                        NSString *fullName = [NSString stringWithFormat:@"%@ %@",
//                                              firstName, lastName];
//                        
//                        person.firstName = firstName;
//                        person.lastName = lastName;
//                        person.fullName = fullName;
//                        
//                        NSString *homeemail;
//                        NSString *workemail;
//                        //email
//                        ABMultiValueRef emails = ABRecordCopyValue(contactPerson,
//                                                                   kABPersonEmailProperty);
//                        NSUInteger j = 0;
//                        for (j = 0; j < ABMultiValueGetCount(emails); j++)
//                        {
//                            NSString *email = (__bridge_transfer NSString
//                                               *)ABMultiValueCopyValueAtIndex(emails, j);
//                            if (j == 0)
//                            {
//                                person.homeEmail = email;
//                                homeemail = email;
//                                NSLog(@"person.homeEmail = %@ ", person.homeEmail);
//                            }
//                            else if (j==1)
//                                person.workEmail = email;
//                            workemail = email;
//                        }
//                        
//                        NSString *homePhone;
//                        NSString *workPhone;
//                        
//                        // Get the phone numbers as a multi-value property.
//                        ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
//                        for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
//                            CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
//                            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
//                            NSLog(@"currentPhoneValue====%@",currentPhoneValue);
//                            
//                            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
//                                homePhone =  (__bridge NSString *)(currentPhoneValue);
//                            }
//                            
//                            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
//                                workPhone =  (__bridge NSString *)currentPhoneValue;
//                            }
//                            
//                            //CFRelease(currentPhoneLabel);
//                            //CFRelease(currentPhoneValue);
//                        }
//                        //CFRelease(phonesRef);
//                        /*
//                         // Get the first street address among all addresses of the selected contact.
//                         ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
//                         if (ABMultiValueGetCount(addressRef) > 0) {
//                         NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
//                         
//                         [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"address"];
//                         [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zipCode"];
//                         [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
//                         }
//                         CFRelease(addressRef);
//                         */
//                        
//                        // If the contact has an image then get it too.
//                        
//                        UIImage *contactImageData;
//                        
//                        if (ABPersonHasImageData(contactPerson)) {
//                            contactImageData = (__bridge UIImage *)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail);
//                            
//                            //[contactInfoDict setObject:contactImageData forKey:@"image"];
//                            //image = [NSString stringWithFormat:@"%@",contactImageData];
//                        }
//                        
//                        
//                        [tableData addObject:[ContactObj newContact:fullName firstName:firstName lastName:lastName homeEmail:homeemail workEmail:workemail homePhone:homePhone workPhone:workPhone userId:@"" photo:contactImageData]];
//                        
//                        //[self.tableData addObject:person];
//                    }     
//                }          
//
//            
//            }
//            
//            });
//    }
//    CFRelease(addressBookRef);
}
- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    //NSInteger numberOfPeople = [allPeople count];
    
    
    if (addressBook != nil)
                        {
                            NSLog(@"Succesful.");
        
                            NSArray *allContacts = (__bridge_transfer NSArray
                                                    *)ABAddressBookCopyArrayOfAllPeople(addressBook);
                            NSUInteger i = 0;
                            for (i = 0; i < [allContacts count]; i++)
                            {
                                ContactObj *person = [[ContactObj alloc] init];
        
                                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                                NSString *firstName = (__bridge_transfer NSString
                                                       *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                                NSString *lastName =  (__bridge_transfer NSString
                                                       *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                                NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                                                      firstName, lastName];
        
                                person.firstName = firstName;
                                person.lastName = lastName;
                                person.fullName = fullName;
        
                                NSString *homeemail;
                                NSString *workemail;
                                //email
                                ABMultiValueRef emails = ABRecordCopyValue(contactPerson,
                                                                           kABPersonEmailProperty);
                                NSUInteger j = 0;
                                for (j = 0; j < ABMultiValueGetCount(emails); j++)
                                {
                                    NSString *email = (__bridge_transfer NSString
                                                       *)ABMultiValueCopyValueAtIndex(emails, j);
                                    if (j == 0)
                                    {
                                        person.homeEmail = email;
                                        homeemail = email;
                                        NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                                    }
                                    else if (j==1)
                                        person.workEmail = email;
                                    workemail = email;
                                }
        
                                NSString *MobilePhone;
                                NSString *homePhone;
                                NSString *workPhone;
        
                                // Get the phone numbers as a multi-value property.
                                ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                                for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
                                    CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
                                    CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
                                    NSLog(@"currentPhoneValue====%@",currentPhoneValue);
        
                                    if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                                        MobilePhone =  (__bridge NSString *)(currentPhoneValue);
                                        
                                    }
//                                    if (CFStringCompare(currentPhoneLabel, kABPersonHomePageLabel, 0) == kCFCompareEqualTo) {
//                                        homePhone =  (__bridge NSString *)(currentPhoneValue);
//                                        
//                                    }
//        
//                                    if (CFStringCompare(currentPhoneLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
//                                        workPhone =  (__bridge NSString *)currentPhoneValue;
//                                    }
        
                                    //CFRelease(currentPhoneLabel);
                                    //CFRelease(currentPhoneValue);
                                }
                                //CFRelease(phonesRef);
                                /*
                                 // Get the first street address among all addresses of the selected contact.
                                 ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
                                 if (ABMultiValueGetCount(addressRef) > 0) {
                                 NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
        
                                 [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressStreetKey] forKey:@"address"];
                                 [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressZIPKey] forKey:@"zipCode"];
                                 [contactInfoDict setObject:[addressDict objectForKey:(NSString *)kABPersonAddressCityKey] forKey:@"city"];
                                 }
                                 CFRelease(addressRef);
                                 */
        
                                // If the contact has an image then get it too.
        
                                UIImage *contactImageData;
        
                                if (ABPersonHasImageData(contactPerson)) {
                                    contactImageData = (__bridge UIImage *)ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail);
        
                                    //[contactInfoDict setObject:contactImageData forKey:@"image"];
                                    //image = [NSString stringWithFormat:@"%@",contactImageData];
                                }
                                
                                
//                                [tableData addObject:[ContactObj newContact:fullName firstName:firstName lastName:lastName homeEmail:homeemail workEmail:workemail homePhone:homePhone workPhone:workPhone userId:@"" photo:contactImageData]];
                                
                                
                                [tableData addObject:[ContactObj newContact:fullName firstName:firstName lastName:lastName homeEmail:homeemail workEmail:workemail homePhone:homePhone workPhone:workPhone mobilePhone:MobilePhone userId:@"" photo:contactImageData]];
                                //[self.tableData addObject:person];
                            }     
                        }          
        

    
//    for (NSInteger i = 0; i < numberOfPeople; i++) {
//        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
//        ContactObj *personm = [[ContactObj alloc] init];
//        
//        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
//        NSLog(@"Name:%@ %@", firstName, lastName);
//        
//        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
//        
//        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
//        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
//            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
//            NSLog(@"  phone:%@", phoneNumber);
//        }
////        [tableData addObject:[ContactObj newContact:fullName firstName:firstName lastName:lastName homeEmail:homeemail workEmail:workemail homePhone:homePhone workPhone:workPhone userId:@"" photo:contactImageData]];
////        CFRelease(phoneNumbers);
    
        
        
        NSLog(@"=============================================");

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        
        filteredseekerArray = [[NSMutableArray alloc] init];
        
        for (ContactObj* obj in tableData)
        {
            NSRange nameRange = [obj.fullName rangeOfString:text options:NSCaseInsensitiveSearch];
            //NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound )
            {
                [filteredseekerArray addObject:obj];
            }
        }
       
    }
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredseekerArray count];
    }
    
    else
    {
        return [tableData count];
    }
    */
    NSUInteger rowCount;
    if(self.isFiltered)
        rowCount = filteredseekerArray.count;
    else
        rowCount = tableData.count;
    
    return rowCount;
    //return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //static NSString *CellIdentifier = @"CloudCell";
    ContactTVCell *cell = (ContactTVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[ContactTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    ContactObj *person = nil;
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        person = [filteredseekerArray objectAtIndex:indexPath.row];
    }
    
    else
    {
        person = [tableData objectAtIndex:indexPath.row];
    }
    */
    if(isFiltered)
    {
        person = [filteredseekerArray objectAtIndex:indexPath.row];
    }
    else
    {
        person = [tableData objectAtIndex:indexPath.row];
    }
    
    cell.fullnamelbl.text = person.fullName;
   /*
    cell.emaillbl.text = person.workEmail;
    cell.phonelbl.text = person.workPhone;
    NSLog(@"tempObject===%@====%@",person.fullName,person.workPhone);

    cell.contactImage.image = person.photo; //[UIImage imageNamed:@"MainBG.png"];
    
*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactObj *Obj = nil;
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Obj = [filteredseekerArray objectAtIndex:indexPath.row];
    }
    
    else
    {
        Obj = [tableData objectAtIndex:indexPath.row];
    }
    */
    if(isFiltered)
    {
        Obj = [filteredseekerArray objectAtIndex:indexPath.row];
    }
    else
    {
        Obj = [tableData objectAtIndex:indexPath.row];
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
   [dict setValue:[NSString stringWithFormat:@"%@",Obj.mobilePhone] forKey:@"mobilePhone"];    [dict setValue:[NSString stringWithFormat:@"%@",Obj.workPhone] forKey:@"workPhone"];
    [dict setValue:[NSString stringWithFormat:@"%@",Obj.workEmail] forKey:@"workEmail"];
    [dict setValue:[NSString stringWithFormat:@"%@",Obj.userId] forKey:@"userId"];
    [dict setValue:[NSString stringWithFormat:@"%@",Obj.homePhone] forKey:@"homePhone"];
    [dict setValue:[NSString stringWithFormat:@"%@",Obj.homeEmail] forKey:@"homeEmail"];
    
    
    
    if ([selectType isEqualToString:@"HelperSelect"]) {
        
        [dict setValue:[NSString stringWithFormat:@"%@",Obj.fullName] forKey:@"helperName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedHelperContact" object: dict];
    
    }else if ([selectType isEqualToString:@"HelperSelectTymBox"]) {
        
        [dict setValue:[NSString stringWithFormat:@"%@",Obj.fullName] forKey:@"helperName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedHelperTymBox" object: dict];

    }else if ([selectType isEqualToString:@"SeekerSelect"]) {
        
        [dict setValue:[NSString stringWithFormat:@"%@",Obj.fullName] forKey:@"seekerName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedSeekerContact" object: dict];
    
    }else if ([selectType isEqualToString:@"SeekerSelectTymBox"]) {
        
        [dict setValue:[NSString stringWithFormat:@"%@",Obj.fullName] forKey:@"seekerName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedSeekerTymBox" object: dict];
    
    }
    
    //
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [filteredseekerArray removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName contains[c] %@", searchText];
    filteredseekerArray = [NSMutableArray arrayWithArray:[tableData filteredArrayUsingPredicate:predicate]];
}


#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}
*/
@end
