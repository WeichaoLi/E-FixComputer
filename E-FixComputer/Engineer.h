//
//  Engineer.h
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Engineer : NSObject<NSCoding>

@property (nonatomic, copy) NSString * engineerid;
@property (copy, nonatomic) NSString *engineername;
@property (copy, nonatomic) NSString *idcard;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *deviceToken;//令牌
@property (copy, nonatomic) NSString *portrait; //头像
@property (copy, nonatomic) NSString *grade;//评分
@property (copy, nonatomic) NSString *status;//状态
@property (copy, nonatomic) NSString *personDescription;//描述
@property (copy, nonatomic) NSString *repairnumber;//修理次数
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *longitude;//经度
@property (copy, nonatomic) NSString *latitude;//纬度
@property (copy, nonatomic) NSString *distance;//距离
@property (copy, nonatomic) NSString *registerdate;//注册时间
@property (copy, nonatomic) NSString *goodat;//擅长

-(Engineer *)initWithengineerid:(int)engineerid andname:(NSString *)engineername andidcard:(NSString *)idcard andpassword:(NSString *)password anddeviceToken:(NSString *)deviceToken andportrait:(NSString *)portrait andgrade:(NSString *)grade andstatus:(NSString *)status andpersonDescription:(NSString *)personDescription andrepairnumber:(NSString *)repairnumber andphone:(NSString *)phone andaddress:(NSString *)address andmoney:(NSString *)money andlongitude:(NSString *)longitude andlatitude:(NSString *)latitude andregisterdate:(NSString *)registerdate andgoodat:(NSString *)goodat;
@end
