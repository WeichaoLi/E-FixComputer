//
//  chitchatViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "Message.h"

@interface chitchatViewController : UIViewController<EGORefreshTableHeaderDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    EGORefreshTableHeaderView *_PullDownRefreshView;
    BOOL _reloading;
}

@property (strong, nonatomic) UITableView *mytableview;
@property (retain, nonatomic) Message *passmessage;

@property (nonatomic, strong) NSMutableArray *userdataArray;

@end
