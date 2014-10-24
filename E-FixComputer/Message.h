//
//  Message.h
//  易修电脑
//
//  Created by administrator on 13-12-25.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject<NSCoding>

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;  //对方的用户名
@property (copy, nonatomic) NSString *portrait;  //对方的头像
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *date;    //发送时间
@property int amount;

@end
