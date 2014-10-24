//
//  User.h
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, copy) NSString *email;

-(User *)initWithuserid:(int)userid andname:(NSString *)username andpassword:(NSString *)password anddeviceToken:(NSString *)deviceToken andphone:(NSString *)phone andaddress:(NSString *)address andportrait:(NSString *)portrait andemail:(NSString *)email;

@end
