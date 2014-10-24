//
//  talk.m
//  TestXmppIOS
//
//  Created by administrator on 13-12-26.
//  Copyright (c) 2013年 Gui. All rights reserved.
//

#import "talk.h"

@implementation talk

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.fromName forKey:@"fromName"];
    [aCoder encodeObject:self.toName forKey:@"toName"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.fromName = [aDecoder decodeObjectForKey:@"fromName"];
        self.toName = [aDecoder decodeObjectForKey:@"toName"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
