//
//  UserAddressViewController.h
//  TymBox030915
//
//  Created by Bhagavan on 3/23/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAddressViewController : UIViewController

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *pinCode;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *street;


@property (weak, nonatomic) IBOutlet UITextField *streettxt;
@property (weak, nonatomic) IBOutlet UITextField *citytxt;
@property (weak, nonatomic) IBOutlet UITextField *statetxt;
@property (weak, nonatomic) IBOutlet UITextField *ziptxt;
@property (weak, nonatomic) IBOutlet UITextField *countrytxt;
- (IBAction)done:(id)sender;

@end
