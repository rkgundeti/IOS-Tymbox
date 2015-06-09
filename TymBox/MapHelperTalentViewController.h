//
//  MapHelperTalentViewController.h
//  TymBox
//
//  Created by Vertex Offshore on 5/4/15.
//  Copyright (c) 2015 Vertex Offshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "OfferObject.h"
@interface MapHelperTalentViewController : UIViewController<MKMapViewDelegate>
{
 OfferObject *offerObj;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)  BOOL ShowTalents;
@property(nonatomic,assign)  BOOL ShowSeekers;

@property(nonatomic,assign)  BOOL comingFromHelpersSegment;
@property(nonatomic,assign)  BOOL comingFromSeekersSegment;
@property(nonatomic,assign)  BOOL comingFromHelperTalentsSegment;
@property(nonatomic,assign)  BOOL comingFromSeekerTalentsSegment;
@property(strong,nonatomic) NSString *helperName;
@property(strong,nonatomic) NSString *helperId;
@property(strong,nonatomic) NSString *helpWho;
@property(strong,nonatomic) NSString *helpWhoId;
@property(strong,nonatomic) NSString *talentId;
@property(strong,nonatomic) OfferObject *offerObj;


@end
