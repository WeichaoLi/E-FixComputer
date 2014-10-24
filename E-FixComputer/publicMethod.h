//
//  publicMethod.h
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"

@interface publicMethod : NSObject

//控件
+ (void)addNavigationBar:(UIViewController*)Controller; //添加导航条
+ (void)addTitleOnNavigationBar:(UIViewController*)Controller titleContent:(NSString*)titleContent;    //导航条上添加标题
+ (void)addBackButton:(UIViewController*)Controller action:(SEL)action;       //添加返回按钮
+ (void)addRightButton:(UIViewController*)Controller backGroundimage:(UIImage*)image action:(SEL)action;      //添加右边按钮
+ (void)addSearchButton:(UIViewController*)Controller action:(SEL)action;
+ (AppDelegate*)Add_appDelegate;   //全局

+ (void)addBtn1:(UIViewController*)Controller backGroundimage:(UIImage*)image action:(SEL)action;
+ (void)addBtn2:(UIViewController*)Controller backGroundimage:(UIImage*)image action:(SEL)action;
//网络
+ (UIImage*)GetImage:(NSString*)path;  //获取网络图片
+ (void)AsynchronousGainData:(ASIHTTPRequest*)request Target:(UIViewController*)Controller Path:(NSString*)path;//异步请求获取数据

//沙盒
+ (NSString*)getDocumentPath:(NSString*)filename;  //获取沙盒路径

//加密方法
+ (NSString *)md5:(NSString *)str;
+(BOOL)validateEmail:(NSString *)email;//判断邮箱
+(BOOL)validateUser:(NSString *)user;
+ (void)registerOpenfire;
+ (void)connectOpenfire;
+ (BOOL)allInformationReady;

+ (BOOL)isConnectionAvailable; //检测网络
+ (void)addActivityIndicatorView:(UIViewController*)viewcontroller;   //活动

@end
