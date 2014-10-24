//
//  User.m
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "User.h"

@implementation User

-(User *)initWithuserid:(int)userid andname:(NSString *)username andpassword:(NSString *)password anddeviceToken:(NSString *)deviceToken andphone:(NSString *)phone andaddress:(NSString *)address andportrait:(NSString *)portrait andemail:(NSString *)email{
    self = [super init];
    if (self!=nil){
        self.userid = [NSString stringWithFormat:@"%d",userid];
        self.username = username;
        self.password = password;
        self.deviceToken = deviceToken;
        self.phone = phone;
        self.address = address;
        self.portrait = portrait;
        self.email = email;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.userid forKey:@"userid"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.portrait forKey:@"portrait"];
    [aCoder encodeObject:self.email forKey:@"email"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.userid = [aDecoder decodeObjectForKey:@"userid"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.deviceToken = [aDecoder decodeObjectForKey:@"deviceToken"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.portrait = [aDecoder decodeObjectForKey:@"portrait"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
    }
    return self;
}

@end
