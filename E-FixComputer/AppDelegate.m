//
//  AppDelegate.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.

#import "AppDelegate.h"
#import "engListViewController.h"
#import "chatViewController.h"
#import "orderViewController.h"
#import "personCenter1ViewController.h"
#import "publicMethod.h"
#import "ToolKit.h"
#import "User.h"
#import "talk.h"
#import "Engineer.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation AppDelegate
@synthesize chatDelegate;
@synthesize xmppRosterStorage;
@synthesize xmppStream;
@synthesize xmppReconnect ;
@synthesize xmppRoster;
@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize xmppMessageArchivingModule;

engListViewController *viewController1;
chatViewController *viewController2;
orderViewController *viewController3;
personCenter1ViewController *viewController4;

#define tag_subcribe_alertView 100

- (void)setupStream {
    xmppStream = [[XMPPStream alloc]init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppReconnect = [[XMPPReconnect alloc]init];
    [xmppReconnect activate:self.xmppStream];
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:xmppRosterStorage];
    [xmppRoster activate:self.xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)showAlertView:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)myConnect{
    NSString *jid = [[NSUserDefaults standardUserDefaults]objectForKey:kMyJID];
    self.myJID = [jid substringToIndex:[jid rangeOfString:@"/"].location];
    NSLog(@"我的ID－－》》：%@",self.myJID);
    NSString *ps = [[NSUserDefaults standardUserDefaults]objectForKey:kPS];
    if (jid == nil || ps == nil) {
        return NO;
    }
    XMPPJID *myjid = [XMPPJID jidWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kMyJID]];
    NSError *error ;
    [xmppStream setMyJID:myjid];
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"my connected error : %@",error.description);
        return YES;
    }
    return YES;
}

//断开连接
- (BOOL)disconnect{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
    
    [self.xmppStream disconnect];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //初始化2个全局变量为空
    self.loginuser = nil;
    self.loginengineer = nil;
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:53/255.0 green:126/255.0 blue:189/255.0 alpha:1]];
    self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //创建TabBar所有的view controller
    viewController1 = [[engListViewController alloc] initWithNibName:@"engListViewController" bundle:nil];
    viewController2 = [[chatViewController alloc] initWithNibName:@"chatViewController" bundle:nil];
    viewController3 = [[orderViewController alloc] initWithNibName:@"orderViewController" bundle:nil];
    viewController4 = [[personCenter1ViewController alloc] initWithNibName:@"personCenter1ViewController" bundle:nil];
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
  
    self.tabBarController.viewControllers = @[nav1, nav2,nav3,nav4];
    
    self.window.rootViewController = self.tabBarController;
    [NSThread sleepForTimeInterval:1];
    
    [self.window makeKeyAndVisible];
    
    /** 注册推送通知功能, */
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
     //判断程序是不是由推送服务完成的
    if (launchOptions) {
        NSDictionary *pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (pushNotificationKey) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送通知" message:@"通知内容" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            
            [alert show];
        }
    }
    self.chatArray = [NSMutableArray array];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kMyJID];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kPS];
    [self setupStream];
    
    //加载普通用户.工程师,记住密码登入状态数据
    NSString *userpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:@"login.plist"];
    NSString *logintype = [[NSUserDefaults standardUserDefaults]stringForKey:@"logintype"];
    
    //登入的时候为普通用户则赋值给普通用户是工程师则赋值给工程师类
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:userpath]) {
        if ([logintype isEqualToString:@"user"]) {
            self.loginuser = [NSKeyedUnarchiver unarchiveObjectWithFile:userpath];
            NSString *badgeValue = [NSString stringWithContentsOfFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@AM.plist",self.loginuser.userid]] encoding:NSStringEncodingConversionAllowLossy error:nil];
//            if (![badgeValue isEqualToString:@"0"]) {
//                if ([badgeValue rangeOfString:@"-"].length) {
//                    viewController2.tabBarItem.badgeValue = nil;
//                }else{
//                    viewController2.tabBarItem.badgeValue = badgeValue;
//                }
//            }else{
//                viewController2.tabBarItem.badgeValue = nil;
//            }
            if ([badgeValue isEqualToString:@"new"]) {
                viewController2.tabBarItem.badgeValue = @"new";
            }else{
                viewController2.tabBarItem.badgeValue = nil;
            }
        }
        else{
            self.loginengineer = [NSKeyedUnarchiver unarchiveObjectWithFile:userpath];
            NSString *badgeValue = [NSString stringWithContentsOfFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@AM.plist",self.loginengineer.engineerid]] encoding:NSStringEncodingConversionAllowLossy error:nil];
//            if (![badgeValue isEqualToString:@"0"]) {
//                if ([badgeValue rangeOfString:@"-"].length) {
//                    viewController2.tabBarItem.badgeValue = nil;
//                }else{
//                    viewController2.tabBarItem.badgeValue = badgeValue;
//                }
//            }else{
//                viewController2.tabBarItem.badgeValue = nil;
//            }
            if ([badgeValue isEqualToString:@"new"]) {
                viewController2.tabBarItem.badgeValue = @"new";
            }else{
                viewController2.tabBarItem.badgeValue = nil;
            }
        }
        [publicMethod connectOpenfire];
    }
    
    return YES;
}

//    接收从APNS返回回来的deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"%@",token);
    self.deviceToken = token;
    
    NSString *strUTL;
    if (self.loginuser) {
        strUTL = [NSString stringWithFormat:@"%@push/GetUserAmount?loginuser_id=1",HOST];
    }else{
        strUTL = [NSString stringWithFormat:@"%@push/GetEngineerAmount?loginengineer_id=1",HOST];
    }
    NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:token forKey:@"deviceToken"];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"apns -> 注册推送功能时发生错误， 错误信息：\n%@",error);
}

//获取远程通知(后台运行)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    
    if (self.loginengineer || self.loginuser) {
        viewController3.tabBarItem.badgeValue = @"new";
    }
//    NSString *badge2 = [[userInfo objectForKey:@"apns"] objectForKey:@"order_badge"];
//    NSLog(@"预约:%@",badge2);
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *datastring = [request responseString];
    NSLog(@"%@",datastring);
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.error);
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender{
//    NSLog(@"xmppStreamWillConnect");
    NSLog(@"连接服务器：我的id－－－－》%@",[self.myJID substringToIndex:[self.myJID rangeOfString:@"@"].location]);
    self.chatArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@unread.plist",[self.myJID substringToIndex:[self.myJID rangeOfString:@"@"].location]]]];
//    if ([publicMethod Add_appDelegate].loginuser != nil){
//        self.chatArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@unread.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
//    }else{
//        self.chatArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@unread.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
//    }
    if (self.chatArray == nil) {
        self.chatArray = [NSMutableArray array];
    }
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
//    NSLog(@"xmppStreamDidConnect");
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kPS]) {
        NSError *error ;
        if (![self.xmppStream authenticateWithPassword:[[NSUserDefaults standardUserDefaults]objectForKey:kPS] error:&error]) {
            NSLog(@"error authenticate : %@",error.description);
        }
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
//    NSLog(@"xmppStreamDidRegister");
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kPS]) {
        NSError *error ;
        if (![self.xmppStream authenticateWithPassword:[[NSUserDefaults standardUserDefaults]objectForKey:kPS] error:&error]) {
            NSLog(@"error authenticate : %@",error.description);
        }else{
            NSLog(@"注册成功");
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
//    [self showAlertView:@"当前用户已经存在"];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"xmppStreamDidAuthenticate");
    XMPPPresence *presence = [XMPPPresence presence];
	[[self xmppStream] sendElement:presence];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"didNotAuthenticate:%@",error.description);
}

- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource{
    NSLog(@"alternativeResourceForConflictingResource: %@",conflictingResource);
    return @"IOS";
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    NSLog(@"didReceiveIQ: %@",iq.description);
    
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"didReceiveMessage: %@",message.description);
    
    NSString *body = [[message elementForName:@"body"] stringValue];
    talk *atalk = [[talk alloc] init];
    atalk.content = body;
    
    if (atalk.content != nil) {
        viewController2.tabBarItem.badgeValue = @"new";
        [viewController2.tabBarItem.badgeValue writeToFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@AM.plist",[self.myJID substringToIndex:[self.myJID rangeOfString:@"@"].location]]] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
//        viewController2.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[viewController2.tabBarItem.badgeValue intValue]+1];
//        [viewController2.tabBarItem.badgeValue writeToFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@AM.plist",[self.myJID substringToIndex:[self.myJID rangeOfString:@"@"].location]]] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
        
        atalk.toName = message.toStr;
        if ([message.toStr rangeOfString:@"/"].length) {
            atalk.toName = [message.toStr substringToIndex:[message.toStr rangeOfString:@"/"].location];
        }
        atalk.fromName = message.fromStr;
        if ([message.fromStr rangeOfString:@"/"].length) {
            atalk.fromName = [message.fromStr substringToIndex:[message.fromStr rangeOfString:@"/"].location];
        }
        
        NSDate *senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm"];
        NSString *  morelocationString=[dateformatter stringFromDate:senddate];
        atalk.date = morelocationString ;
        
        [self.chatArray addObject:atalk];
        
        [NSKeyedArchiver archiveRootObject:self.chatArray toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@unread.plist",[self.myJID substringToIndex:[self.myJID rangeOfString:@"@"].location]]]];
        
        [self.chatDelegate getNewMessage:self Message:message];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"newMessage" object:nil];
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"didReceivePresence: %@",presence.description);
    if (presence.status) {
        if ([self.chatDelegate respondsToSelector:@selector(friendStatusChange:Presence:)]) {
            [self.chatDelegate friendStatusChange:self Presence:presence];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
    NSLog(@"didReceiveError: %@",error.description);
}

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
    NSLog(@"didSendIQ:%@",iq.description);
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSLog(@"didSendMessage:%@",message.description);
}

- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
    NSLog(@"didSendPresence:%@",presence.description);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error{
    NSLog(@"didFailToSendIQ:%@",error.description);
    [publicMethod connectOpenfire];
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    NSLog(@"didFailToSendMessage:%@",error.description);
    [publicMethod connectOpenfire];
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
    NSLog(@"didFailToSendPresence:%@",error.description);
    [publicMethod connectOpenfire];
}

- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender{
    NSLog(@"xmppStreamWasToldToDisconnect");
    [publicMethod connectOpenfire];
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"xmppStreamConnectDidTimeout");
    [publicMethod connectOpenfire];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"xmppStreamDidDisconnect: %@",error.description);
    [publicMethod connectOpenfire];
}

@end
