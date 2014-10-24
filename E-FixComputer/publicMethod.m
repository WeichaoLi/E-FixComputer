//
//  publicMethod.m
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "publicMethod.h"
#import "ToolKit.h"
#import "User.h"
#import "Engineer.h"
#import "Reachability.h"
#import <CommonCrypto/CommonDigest.h>

@implementation publicMethod


+ (void)addNavigationBar:(UIViewController *)Controller{
    UINavigationBar *nav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 54)];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [Controller.view addSubview:nav];
}

+ (void)addTitleOnNavigationBar:(UIViewController *)Controller titleContent:(NSString *)titleContent{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 160, 35)];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleContent;
    [Controller.view addSubview:title];
}

+ (void)addBackButton:(UIViewController *)Controller action:(SEL)action{
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(3,25,30,24)];
    leftbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]];
    [leftbutton addTarget:Controller action:action forControlEvents:UIControlEventTouchDown];
    [Controller.view addSubview:leftbutton];
}

+ (void)addRightButton:(UIViewController *)Controller backGroundimage:(UIImage *)image action:(SEL)action{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(290, 25, 30, 31)];
    rightButton.backgroundColor = [UIColor colorWithPatternImage:image];
    [rightButton addTarget:Controller action:action forControlEvents:UIControlEventTouchDown];
    [Controller.view addSubview:rightButton];
}

+ (void)addBtn1:(UIViewController*)Controller backGroundimage:(UIImage*)image action:(SEL)action{
     UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
     [btn1 setFrame:CGRectMake(2, 24, 100, 25)];
     btn1.backgroundColor = [UIColor colorWithPatternImage:image];
     [btn1 addTarget:Controller action:action forControlEvents:UIControlEventTouchDown];
     [Controller.view addSubview:btn1];
    
    }

+ (void)addBtn2:(UIViewController*)Controller backGroundimage:(UIImage*)image action:(SEL)action{
     UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
     [btn2 setFrame:CGRectMake(255, 24, 75, 24)];
     btn2.backgroundColor = [UIColor colorWithPatternImage:image];
     [btn2 addTarget:Controller action:action forControlEvents:UIControlEventTouchDown];
     [Controller.view addSubview:btn2];
}

+ (void)addSearchButton:(UIViewController*)Controller action:(SEL)action;{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(292, 24, 50, 35)];
    
    btn.titleLabel.textColor =[UIColor blackColor];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"20131.png"]];
    [btn addTarget:Controller action:action forControlEvents:UIControlEventTouchDown];
    [Controller.view addSubview:btn];

}

+ (AppDelegate *)Add_appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

+ (UIImage*)GetImage:(NSString *)path{
    NSString *image = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,path];
    NSURL *url = [NSURL URLWithString:image];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

+ (void)AsynchronousGainData:(ASIHTTPRequest *)request Target:(UIViewController *)Controller Path:(NSString *)path{
    NSString *strUTL = [NSString stringWithFormat:@"%@%@",HOST,path];
    
    NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    request = [ASIHTTPRequest requestWithURL:url];
    
    request.delegate = Controller;
    
    [request startAsynchronous];
}

+ (NSString*)getDocumentPath:(NSString *)filename{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    return [path stringByAppendingPathComponent:filename];
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+ (void)registerOpenfire{
    if (![self allInformationReady]) {
        return;
    }
    if ([[[publicMethod Add_appDelegate] xmppStream] isConnected] && [[[publicMethod Add_appDelegate] xmppStream] supportsInBandRegistration]) {
        NSError *error ;
        
        if ([publicMethod Add_appDelegate].loginuser) {
            [[publicMethod Add_appDelegate].xmppStream setMyJID:[XMPPJID jidWithUser:[NSString stringWithFormat:@"1_%@",[publicMethod Add_appDelegate].loginuser.userid] domain:OFHOST resource:@"XMPPIOS"]];
        }
        if ([publicMethod Add_appDelegate].loginengineer) {
            [[publicMethod Add_appDelegate].xmppStream setMyJID:[XMPPJID jidWithUser:[NSString stringWithFormat:@"0_%@",[publicMethod Add_appDelegate].loginengineer.engineerid] domain:OFHOST resource:@"XMPPIOS"]];
        }
        //        [[self appDelegate]setIsRegistration:YES];
        if (![[publicMethod Add_appDelegate].xmppStream registerWithPassword:@"123456" error:&error]) {
            [[publicMethod Add_appDelegate] showAlertView:[NSString stringWithFormat:@"%@",error.description]];
        }
    }
}

+ (void)connectOpenfire{
    if ( ![self allInformationReady]) {
        return ;
    }
    //    [[publicMethod Add_appDelegate] setIsRegistration:NO];
    [[publicMethod Add_appDelegate] myConnect];
}

+ (BOOL)allInformationReady{
    [[[publicMethod Add_appDelegate] xmppStream] setHostName:OFHOST];
    [[[publicMethod Add_appDelegate] xmppStream] setHostPort:PORT.integerValue];
    [[NSUserDefaults standardUserDefaults]setObject:OFHOST forKey:kHost];
    if ([publicMethod Add_appDelegate].loginuser) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@@%@/IOS",[NSString stringWithFormat:@"1_%@",[publicMethod Add_appDelegate].loginuser.userid],OFHOST] forKey:kMyJID];
        //        [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]stringForKey:@"password"] forKey:kPS];
    }
    if ([publicMethod Add_appDelegate].loginengineer) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@@%@/IOS",[NSString stringWithFormat:@"0_%@",[publicMethod Add_appDelegate].loginengineer.engineerid],OFHOST] forKey:kMyJID];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"123456" forKey:kPS];
    return YES;
}
//判断email格式
+(BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//判断用户名长度为2到14，可以输中文
+(BOOL)validateUser:(NSString *)user{
    NSString *userRegex=@"^[A-Za-z0-9\u4E00-\u9FA5_-]+${2,14}";
    NSPredicate *userTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",userRegex];
    return [userTest evaluateWithObject:user];
}

+ (BOOL)isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            NSLog(@"当前无网络。");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            NSLog(@"当前使用的网络为WIFI。");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            NSLog(@"当前使用的网络为3G。");
            break;
    }
    return isExistenceNetwork;
}

+ (void)addActivityIndicatorView:(UIViewController *)viewcontroller{
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(110, 190, 100, 100)];
    //    [
    //
    //    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //    view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //    view.frame = CGRectMake(25.0f,  - 38.0f, 20.0f, 20.0f);
    //    [self addSubview:view];
}

@end
