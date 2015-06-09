//
//  TransDetObj.h
//  TymBox030915
//
//  Created by Bhagavan on 4/8/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransDetObj : NSObject

@property (strong, nonatomic) NSString *trans_det_ID;
@property (strong, nonatomic) NSString *trans_ID;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSString *expense;
@property (strong, nonatomic) NSString *total;
@property (strong, nonatomic) NSString *expense_Comments;
@property (strong, nonatomic) NSString *createdBy;

@end
