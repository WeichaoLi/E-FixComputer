//
//  Comment.h
//  易修电脑
//
//  Created by administrator on 13-12-9.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *engineerid;
@property (copy, nonatomic) NSString *grade;    //评分
@property (copy, nonatomic) NSString *content;  //评语
@property (copy, nonatomic) NSString *date;

@end
