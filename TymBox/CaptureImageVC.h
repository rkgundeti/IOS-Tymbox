//
//  CaptureImageVC.h
//  TymBox030915
//
//  Created by Bhagavan on 3/23/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptureImageVC : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *takePhotobtn;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotobtn;

- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
