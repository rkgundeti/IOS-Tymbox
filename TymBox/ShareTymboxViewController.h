//
//  ShareTymboxViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 4/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ShareTymboxViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate>
- (IBAction)showMenu;

@property (strong, nonatomic) IBOutlet UITextField *selectedTalentTxt;

- (IBAction)selectTalentAction:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *textEmailSeg;
- (IBAction)textEmailAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *contactName;
- (IBAction)getDeviceContactAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contact;

- (IBAction)sendInviteAction:(id)sender;
- (IBAction)getContacts:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *comments;
@end
