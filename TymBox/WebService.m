//
//  WebService.m
//  CrotusSample
//
//  Created by User on 24/06/14.
//  Copyright (c) 2014 Crotus Technologies. All rights reserved.
//

#import "WebService.h"
#import "ShowProcessing.h"

ShowProcessing *show;

@implementation WebService

//+(NSMutableArray *)getWebServiceResponse:(NSString *)serviceName tag:(NSInteger)tag
//{
//    NSMutableArray *listofEmployees;
//    
//    NSError *error;
//    
//    NSURL *url=[NSURL URLWithString:[WebService getWebServiceUrlString:serviceName]];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    // Call the web service, and (if it's successful) store the raw data that it returns
//    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
//    if (!data)
//    {
//        NSLog(@"Download Error: %@", error.localizedDescription);
//        
//    }else if(tag==99){
//        
//        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSLog(@" 1.dictionary values are : %@",jsonArray);
//        
//        listofEmployees=[jsonArray mutableCopy];
//        return listofEmployees;
//        
//    }
//    else
//    {
//        
//        
//        // Parse the (binary) JSON data from the web service into an NSDictionary object
//        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSLog(@"2.dictionary values are : %@",jsonArray);
//        
//        if (jsonArray == nil) {
//            NSLog(@"JSON Error: %@", error);
//        }
//        
//        switch (tag) {
//            case 100:
//            {
//                NSLog(@"company");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllCompanyResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//            }
//            case 101:
//            {
//                NSLog(@"region");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllRegionResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//            }
//            case 102:
//            {
//                NSLog(@"subregion");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllSubRegionResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//            }
//            case 103:
//            {
//                NSLog(@"country");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllCountryResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//            }
//            case 104:
//            {
//                NSLog(@"channel");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllChannelResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//            }
//            case 105:
//            {
//                NSLog(@"kPIEvaluation");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllKPIEvaluationResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//                
//            }
//            case 106:
//            {
//                NSLog(@"kPIEvaluationMeticDetails");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllKPIEvaluationMeticDetailsResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//            }
//                
//            case 107:
//            {
//                NSLog(@"kPIEvaluationValue");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllKPIEvaluationValueResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//                
//            case 108:
//            {
//                NSLog(@"kPIEvaluationDetails");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllKPIEvaluationDetailsResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//                
//            case 109:
//            {
//                NSLog(@"AllHub");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllHubResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 110:
//            {
//                NSLog(@"AllLocation");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllLocationResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 111:
//            {
//                NSLog(@"AllStoreLocation");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllStoreLocationResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 112:
//            {
//                NSLog(@"AllAgecny");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllAgencyResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 113:
//            {
//                NSLog(@"AllAccrediationGroup");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllAccrediationGroupResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 114:
//            {
//                NSLog(@"AllAccrediation");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllAccrediationResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 115:
//            {
//                NSLog(@"AllLevel");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllLevelResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//                
//            case 116:
//            {
//                NSLog(@"AllLegend");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllLegendResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 117:
//            {
//                NSLog(@"AllScale");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllScaleResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 118:
//            {
//                NSLog(@"AllScaleDetail");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllScaleDetailResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//                
//            case 119:
//            {
//                NSLog(@"AllKPI");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllKPIResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 120:
//            {
//                NSLog(@"AllSpecialisation");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllSpecialisationResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 121:
//            {
//                NSLog(@"AllKPIDetail");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllKPIDetailResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 122:
//            {
//                NSLog(@"AllGroupKPI");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllGroupKPIResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 123:
//            {
//                NSLog(@"AllGroupKPIDetail");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllGroupKPIDetailResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 124:
//            {
//                NSLog(@"GetAllManagingGroupKPIResult");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllManagingGroupKPIResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 125:
//            {
//                NSLog(@"GetAllTrainingResult");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllTrainingResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 126:
//            {
//                NSLog(@"GetAllEmployeeAccrediationResult");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllEmployeeAccrediationResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//                
//            case 127:
//            {
//                NSLog(@"GetAllEmployeeSpecilizationResult");
//                NSArray *resultArray = [jsonArray objectForKey:@"GetAllEmployeeSpecilizationResult"];
//                listofEmployees = [[NSMutableArray alloc]initWithArray:resultArray];
//                break;
//                
//            }
//            case 128:
//            {
//                NSLog(@"GetAllEmployeeSpecilizationResult");
//                NSDictionary *resultArray = [jsonArray objectForKey:@"UpdateKPIEvaluationFromiOSResult"];
//                NSString *resultArray1 = [resultArray objectForKey:@"Result"];
//                listofEmployees = [[NSMutableArray alloc]initWithObjects:resultArray1, nil];
//                break;
//                
//            }
//
//            default:
//                break;
//        }
//        
//    }
//    return listofEmployees;
//    
//    
//}

+(NSDictionary *)WebServiceResponseWithGet:(NSString *)serviceName tag:(NSInteger)tag
{
    show = [[ShowProcessing alloc]init];
    NSDictionary *listofdict;
    
    NSError *error;
    
//    NSURL *url=[NSURL URLWithString:[WebService getWebServiceUrlString:serviceName]];
        NSURL *url=[NSURL URLWithString:serviceName];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"xapplication/json" forHTTPHeaderField:@"Content-Type"];
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        
    }
        // Parse the (binary) JSON data from the web service into an NSDictionary object
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"2.dictionary values are : %@",jsonArray);
        
        if (jsonArray == nil) {
            NSLog(@"JSON Error: %@", error);
        }
        switch (tag) {
            case 200:
            {
                NSLog(@"ValidateLoginUserResult");
                listofdict = jsonArray;
                break;
    
            }
            default:
                break;
        }
    
    [show ProcessingStop];
    return listofdict;

}

//+(NSDictionary *)postWebServiceResponse:(NSString *)serviceName tag:(NSInteger)tag withUserDetails:(UserDetails *)userDetails 
//{
//    NSData *jsonData = nil;
//    NSString *udid = [self uniqueIDForDevice];
//    switch (tag) {
//        case 200:
//        {
//            jsonData = [[NSString stringWithFormat:@"{ EveCount: %@, EveDate: \"%@\", IOSDeviceId: \"%@\",IsPosted: \"N\", KPIGroupId: %@, LMID: %@, empId: %@ }", userDetails.M_EveCount,userDetails.M_EveDate ,udid ,userDetails.M_KPIGroupId,[[NSUserDefaults standardUserDefaults] objectForKey:@"ManagerId"] ,userDetails.M_empid] dataUsingEncoding:NSUTF8StringEncoding];
//            break;
//        }
//        case 201:
//        {
//            jsonData = [[NSString stringWithFormat:@"{ EveID: %@, IOSPKey:%@, KPIComments: \"%@\", KPIID: %@,MatricID: %@, MatricValue: %@,IOSDeviceId:\"%@\",empId:%@,EveDate:\"%@\"}", userDetails.MD_EvalMaster_ID,userDetails.MD_Eval_ID ,userDetails.MD_KPI_Comments ,userDetails.MD_KPI_ID ,userDetails.MD_Metric_ID ,userDetails.MD_Metric_value,udid,userDetails.MD_Emp_ID,userDetails.MD_Eval_Date] dataUsingEncoding:NSUTF8StringEncoding];
//        }
//        default:
//            break;
//    }
//    
//    NSDictionary *listofdict;
//    NSError *error;
//    NSURL *url=[NSURL URLWithString:[WebService getWebServiceUrlString:serviceName]];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    
//    //    NSData *jsonData = [[NSString stringWithFormat:@"{ EveDetId: 0, EveDate: \"02-02-2014 00:00:00\",EveID: 1, IOSDeviceId: \"1\",IsPosted: \"N\", KPIGroupId: 1, LMID: 1, empId: 2 }"] dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *myStrin = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",myStrin);
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:jsonData];
//    //[request setValue:[NSString stringWithFormat:@"%ld", (long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
//    // Call the web service, and (if it's successful) store the raw data that it returns
//    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
//    if (!data)
//    {
//        NSLog(@"Download Error: %@", error.localizedDescription);
//        
//    }
//    NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",myString);
//    // Parse the (binary) JSON data from the web service into an NSDictionary object
//    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    NSLog(@"2.dictionary values are : %@",jsonArray);
//    
//    if (jsonArray == nil) {
//        NSLog(@"JSON Error: %@", error);
//    }
//    
//    return listofdict;
//    
//}
//
//+(NSString*)getWebServiceUrlString:(NSString *) webURLString
//{
//    NSString *String=@"http://1.23.183.15/pecatwcf/PECATService1.svc/";
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",String,webURLString];
//    NSLog(@"url string is : %@",urlString);
//    return urlString;
//}
//
//
//+(NSString*)uniqueIDForDevice
//{
//    NSString* uniqueIdentifier = nil;
//    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] )
//    { // >=iOS 7
//        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    } else
//    { //<=iOS6, Use UDID of Device
//        CFUUIDRef uuid = CFUUIDCreate(NULL);
//        //uniqueIdentifier = ( NSString*)CFUUIDCreateString(NULL, uuid);- for non- ARC
//        uniqueIdentifier = ( NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));// for ARC
//        CFRelease(uuid);
//    }
//    
//    return uniqueIdentifier;
//}
//
@end
