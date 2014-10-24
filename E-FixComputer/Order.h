//
//  Order.h
//  易修电脑
//
//  Created by administrator on 13-12-12.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *commentid;
@property (copy, nonatomic) NSString *engineerid;
@property (copy, nonatomic) NSString *receiveid;
@property (copy, nonatomic) NSString *sendstatus;
@property (copy, nonatomic) NSString *receivestatus;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *appointdate;  //预约时间
@property (copy, nonatomic) NSString *senddate;    //发送时间

@property (copy, nonatomic) NSString *name;  //对方的用户名
@property (copy, nonatomic) NSString *portrait;  //对方的头像

@end
