//
//  AppDelegate.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "ASIHTTPRequest.h"
@protocol ChatDelegate;

//引出2个类
@class User;
@class Engineer;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,XMPPStreamDelegate>
{
    XMPPStream *xmppStream ;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
}
@property BOOL IsConnenting;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property BOOL isRefreshMessage;
@property BOOL isRefreshOrder;
//定义2个全局变量loginUser和loginEngineer
@property (retain, nonatomic) User *loginuser;
@property(strong, nonatomic) Engineer *loginengineer;

@property (retain, nonatomic) NSString *deviceToken;

//======================
@property (nonatomic, strong) XMPPStream *xmppStream ;
@property (nonatomic, assign) BOOL isRegistration ;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;
@property (retain, nonatomic) NSMutableArray *chatArray ;
@property (copy, nonatomic) NSString *myJID;

- (BOOL)myConnect;
- (BOOL)disconnect;
- (void)showAlertView:(NSString *)message;

@property (nonatomic,strong) id<ChatDelegate> chatDelegate;

@end

@protocol ChatDelegate <NSObject>

-(void)friendStatusChange:(AppDelegate *)appD Presence:(XMPPPresence *)presence;
-(void)getNewMessage:(AppDelegate *)appD Message:(XMPPMessage *)message;

@end
