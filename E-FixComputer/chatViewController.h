//
//  chatViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@class chitchatViewController;
#import "EGORefreshTableHeaderView.h"

@interface chatViewController : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_PullDownRefreshView;
    BOOL _reloading;
    chitchatViewController *chitchat;
}

@property (strong, nonatomic) UITableView *mytableview;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (retain, nonatomic) NSMutableArray *messageList;

@end
