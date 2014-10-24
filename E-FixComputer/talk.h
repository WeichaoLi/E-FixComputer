//
//  talk.h
//  TestXmppIOS
//
//  Created by administrator on 13-12-26.
//  Copyright (c) 2013年 Gui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface talk : NSObject

@property (copy, nonatomic) NSString *fromName ;
@property (copy, nonatomic) NSString *toName ;
@property (copy, nonatomic) NSString *content ;
@property (copy, nonatomic) NSString *date ;

@end
