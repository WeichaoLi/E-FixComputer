//
//  Engineer.m
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "Engineer.h"

@implementation Engineer

-(Engineer *)initWithengineerid:(int)engineerid andname:(NSString *)engineername andidcard:(NSString *)idcard andpassword:(NSString *)password anddeviceToken:(NSString *)deviceToken andportrait:(NSString *)portrait andgrade:(NSString *)grade andstatus:(NSString *)status andpersonDescription:(NSString *)personDescription andrepairnumber:(NSString *)repairnumber andphone:(NSString *)phone andaddress:(NSString *)address andmoney:(NSString *)money andlongitude:(NSString *)longitude andlatitude:(NSString *)latitude andregisterdate:(NSString *)registerdate andgoodat:(NSString *)goodat{
    
    self = [super init];
    
    if (self !=nil) {
        self.engineerid = [NSString stringWithFormat:@"%d",engineerid];
        self.engineername = engineername;
        self.idcard = idcard;
        self.password = password;
        self.deviceToken = deviceToken;
        self.portrait = portrait;
        self.grade = grade;
        self.status = status;
        self.personDescription = personDescription;
        self.repairnumber = repairnumber;
        self.phone = phone;
        self.address = address;
        self.money = money;
        self.longitude = longitude;
        self.latitude = latitude;
        self.registerdate = registerdate;
        self.goodat = goodat;
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.engineerid forKey:@"engineerid"];
    [aCoder encodeObject:self.engineername forKey:@"engineername"];
    [aCoder encodeObject:self.idcard forKey:@"idcard"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [aCoder encodeObject:self.portrait forKey:@"portrait"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.personDescription forKey:@"personDescription"];
    [aCoder encodeObject:self.repairnumber forKey:@"repairnumber"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.money forKey:@"money"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.registerdate forKey:@"registerdate"];
    [aCoder encodeObject:self.goodat forKey:@"goodat"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.engineerid = [aDecoder decodeObjectForKey:@"engineerid"];
        self.engineername = [aDecoder decodeObjectForKey:@"engineername"];
        self.idcard = [aDecoder decodeObjectForKey:@"idcard"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.deviceToken = [aDecoder decodeObjectForKey:@"deviceToken"];
        self.portrait = [aDecoder decodeObjectForKey:@"portrait"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.personDescription = [aDecoder decodeObjectForKey:@"personDescription"];
        self.repairnumber = [aDecoder decodeObjectForKey:@"repairnumber"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.money = [aDecoder decodeObjectForKey:@"money"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.registerdate = [aDecoder decodeObjectForKey:@"registerdate"];
       
 
    }
    
    return self;
}

@end
