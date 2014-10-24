//
//  AppDelegate.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

//引出2个类
@class User;
@class Engineer;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;



//定义2个全局变量loginUser和loginEngineer
@property (retain, nonatomic) User *loginuser;
@property(strong, nonatomic) Engineer *loginengineer;

@property (retain, nonatomic) NSString *deviceToken;

@end
