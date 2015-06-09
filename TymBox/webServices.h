//
//  webServices.h
//  TymBox
//
//  Created by Vertex Offshore on 4/15/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface webServices : NSObject
+(NSMutableArray *)getResponse:(NSURL *) stringUrl;
@end
