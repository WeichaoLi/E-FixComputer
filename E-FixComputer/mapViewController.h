//
//  mapViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "engineerDetailViewController.h"
@interface mapViewController : UIViewController<ASIHTTPRequestDelegate,CLLocationManagerDelegate,MKMapViewDelegate>{
    MKMapView *mapView;
    engineerDetailViewController *detailViewController;
}
typedef double CLLocationDistance;
@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (strong, nonatomic) IBOutlet engineerDetailViewController *detailViewController;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) ASIHTTPRequest *requestList;
@property (retain, nonatomic) NSMutableArray *position;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *longitude;//经度
@property (copy, nonatomic) NSString *latitude;//纬度
@property (copy, nonatomic) NSString *name;
@property double distance;
@property (copy, nonatomic) MKAnnotationView *image;
@property (retain, nonatomic) UIView *rightCalloutAccessoryView;
@property (copy, nonatomic) NSString *englocation;//工程师位置
@property (copy, nonatomic) NSString *userlocation;//用户位置

@property (retain, nonatomic) Engineer *PassEng;
- (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;
@end
