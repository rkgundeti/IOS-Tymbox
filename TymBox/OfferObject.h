//
//  OfferObject.h
//  TymBox030915
//
//  Created by Rama Krishna.G on 07/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferObject : NSObject

@property (strong, nonatomic) NSString *selectedUserName;
@property (strong, nonatomic) NSString *selectedUserId;
@property (strong, nonatomic) NSString *selectedTalentName;
@property (strong, nonatomic) NSString *selectedTalentId;
@property (strong, nonatomic) NSString *talentRate;
@property (strong, nonatomic) NSString *talentExpense;
@property (strong, nonatomic) NSString *talentJobDate;
@property (strong, nonatomic) NSString *talentJobType;
@property (strong, nonatomic) NSString *talentQuantity;
@property (strong, nonatomic) NSString *talentTotal;

@end
