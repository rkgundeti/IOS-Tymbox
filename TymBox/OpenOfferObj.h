//
//  OpenOfferObj.h
//  TymBox030915
//
//  Created by Bhagavan on 4/1/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenOfferObj : NSObject

@property (strong, nonatomic) NSString *offeredTo;
@property (strong, nonatomic) NSString *offeredCategory;
@property (strong, nonatomic) NSString *offeredcatId;
@property (strong, nonatomic) NSString *offeredTalent;
@property (strong, nonatomic) NSString *offeredTalId;
@property (strong, nonatomic) NSString *offeredDate;

@property (strong, nonatomic) NSString *offeredquantity;
@property (strong, nonatomic) NSString *offeredPrice;

@property (strong, nonatomic) NSString *offeredexpense;
@property (strong, nonatomic) NSString *offeredTotal;

@property (strong, nonatomic) NSMutableArray *offerDetails;

@end
