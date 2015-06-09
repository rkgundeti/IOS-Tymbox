//
//  webServices.m
//  TymBox
//
//  Created by Vertex Offshore on 4/15/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import "webServices.h"

@implementation webServices
+(NSMutableArray *)getResponse:(NSURL *) stringUrl{
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    //        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.42:8080/TymBoxWeb/CategoryServlet"]];
    // http://192.168.0.187:8080/TymBoxWeb/CategoryServlet
    
    
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:stringUrl];
    [theRequest setHTTPMethod:@"GET"];
    NSData *responseData =[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    
    return arr;
}

@end
