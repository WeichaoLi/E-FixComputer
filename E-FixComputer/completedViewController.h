//
//  completedViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface completedViewController : UIViewController<EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    EGORefreshTableHeaderView *_PullDownRefreshView;
    EGORefreshTableHeaderView *_PullUpRefreshView;
    BOOL _reloading;
}

@property (retain, nonatomic) UIViewController *rootviewcontroller;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (retain, nonatomic) NSMutableArray *SendOrderList;
@property (retain, nonatomic) NSMutableArray *ReceiveOrderList;

@end
