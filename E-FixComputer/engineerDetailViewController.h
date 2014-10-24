//
//  engineerDetailViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Engineer.h"
#import "ASIHTTPRequest.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface engineerDetailViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIAlertViewDelegate>{
    UIScrollView *myScrollerview;
}

@property (retain, nonatomic) Engineer *PassEng;
@property (retain, nonatomic) NSMutableArray *commentList;
@property (retain, nonatomic) UIViewController *rootViewController;
@property (retain, nonatomic) ASIHTTPRequest *requestList;
@property (retain, nonatomic) ASIHTTPRequest *requestList1;
- (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;

@end
