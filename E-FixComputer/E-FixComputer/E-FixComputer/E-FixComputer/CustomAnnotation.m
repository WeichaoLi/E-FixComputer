//
//  CustomAnnotation.m
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "CustomAnnotation.h"
#import "mapViewController.h"
@implementation CustomAnnotation
@synthesize coordinate=_coordinate;

//简单地保存了经纬度信息
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        _coordinate =coordinate;
    }
    return self;
}
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate=newCoordinate;
}





@end
