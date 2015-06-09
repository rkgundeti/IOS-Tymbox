//
//  WebService.h
//  CrotusSample
//
//  Created by User on 24/06/14.
//  Copyright (c) 2014 Crotus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserDetails.h"

@interface WebService : NSObject

//+ (NSMutableArray *)getWebServiceResponse:(NSString *)serviceName tag:(NSInteger)tag;
//+ (NSString*)getWebServiceUrlString:(NSString *) webURLString;
+ (NSDictionary *)WebServiceResponseWithGet:(NSString *)serviceName tag:(NSInteger)tag;
//+ (NSDictionary *)postWebServiceResponse:(NSString *)serviceName tag:(NSInteger)tag withUserDetails:(UserDetails *)userDetails;
@end