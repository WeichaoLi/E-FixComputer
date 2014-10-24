//
//  engListViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class AppDelegate;

@interface engListViewController : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,CLLocationManagerDelegate,MKMapViewDelegate>{
    EGORefreshTableHeaderView *_PullDownRefreshView;
    EGORefreshTableHeaderView *_PullUpRefreshView;
    AppDelegate *appDelegate;
    BOOL _reloading;
}

@property (retain, nonatomic) CLLocationManager *currentLoaction;
@property (retain, nonatomic) ASIHTTPRequest *requestList;
@property (retain, nonatomic) NSMutableArray *EngList;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (copy, nonatomic) NSString *longitude;//经度
@property (copy, nonatomic) NSString *latitude;//纬度
- (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;

@end
