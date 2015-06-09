//
//  TransMasterObj.h
//  TymBox030915
//
//  Created by Bhagavan on 4/8/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransMasterObj : NSObject


@property (strong, nonatomic) NSString *transId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *user_Type;
@property (strong, nonatomic) NSString *job_Req_Date;
@property (strong, nonatomic) NSString *time_Line;
@property (strong, nonatomic) NSString *UOM;
@property (strong, nonatomic) NSString *reach_Out_Message;
@property (strong, nonatomic) NSString *user_Talent_Id;
@property (strong, nonatomic) NSString *user_Talent_Name;
@property (strong, nonatomic) NSString *seekerId;
@property (strong, nonatomic) NSString *createdById;
@property (strong, nonatomic) NSString *seekerName;
@property (strong, nonatomic) NSString *offer_Request_Type;
@property (strong, nonatomic) NSString *Date_Type;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSMutableArray *detArray;
@end
