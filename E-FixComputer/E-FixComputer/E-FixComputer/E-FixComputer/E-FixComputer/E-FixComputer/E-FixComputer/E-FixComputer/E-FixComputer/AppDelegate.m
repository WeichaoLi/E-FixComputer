//
//  AppDelegate.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "AppDelegate.h"
#import "mainViewController.h"
#import "chatViewController.h"
#import "orderViewController.h"
#import "personCenter1ViewController.h"
#import "publicMethod.h"
#import "ToolKit.h"
#import "User.h"
#import "Engineer.h"
#import "ASIHTTPRequest.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化2个全局变量为空
    self.loginuser = nil;
    self.loginengineer = nil;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //创建TabBar所有的view controller
    mainViewController *viewController1 = [[mainViewController alloc] initWithNibName:@"mainViewController" bundle:nil];
    chatViewController *viewController2 = [[chatViewController alloc] initWithNibName:@"chatViewController" bundle:nil];
    orderViewController *viewController3 = [[orderViewController alloc] initWithNibName:@"orderViewController" bundle:nil];
    personCenter1ViewController *viewController4 = [[personCenter1ViewController alloc] initWithNibName:@"personCenter1ViewController" bundle:nil];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:viewController1];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:viewController2];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:viewController3];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:viewController4];

    nav1.navigationBar.hidden = YES;
    nav2.navigationBar.hidden = YES;
    nav3.navigationBar.hidden = YES;
    nav4.navigationBar.hidden = YES;
    //创建TabBar
    self.tabBarController = [[UITabBarController alloc] init];
    //tabbar的颜色
    self.tabBarController.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"渐变2.png"]];
    //将所有的View controller赋值给TabBar
    self.tabBarController.viewControllers = @[nav1, nav2,nav3,nav4];
    //显示tabbar
    self.window.rootViewController = self.tabBarController;
    
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bookimage.png"]];

    [NSThread sleepForTimeInterval:0.6];
    
    [self.window makeKeyAndVisible];
    
    /** 注册推送通知功能, */
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
     //判断程序是不是由推送服务完成的
    if (launchOptions) {
        NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (pushNotificationKey) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送通知" message:@"通知内容" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            
            [alert show];
        }
    }
    
    return YES;
}

//    接收从APNS返回回来的deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"apns-> 格式化生成的devToken: %@",token);
    self.deviceToken = token;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"apns -> 注册推送功能时发生错误， 错误信息：\n%@",error);
}

//获取远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    int badge = [[[userInfo objectForKey:@"apns"] objectForKey:@"badge"] integerValue];
    application.applicationIconBadgeNumber += badge;
    
    //网络请求
    NSString *strUTL = [NSString stringWithFormat:@"%@order/gainordercount?id=1&status=0",HOST];
    NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
    
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"查看", nil];
        [alert show];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *datastring = [request responseString];
    NSLog(@"您有 %@ 条信息",datastring);
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
