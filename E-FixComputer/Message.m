//
//  Message.m
//  易修电脑
//
//  Created by administrator on 13-12-25.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.portrait forKey:@"portrait"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.amount] forKey:@"amount"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.portrait = [aDecoder decodeObjectForKey:@"portrait"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.amount = [[aDecoder decodeObjectForKey:@"amount"] intValue];
    }
    return self;
}

@end
