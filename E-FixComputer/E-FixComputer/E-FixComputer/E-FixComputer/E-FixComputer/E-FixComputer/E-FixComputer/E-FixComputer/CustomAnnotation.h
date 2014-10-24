//
//  CustomAnnotation.h
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject
<MKAnnotation>{
   
    NSString *headImage;
    CLLocationCoordinate2D _coordinate;
    
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *longitude;//经度
@property (copy, nonatomic) NSString *latitude;//纬度
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *subtitle;
@property (nonatomic) MKPinAnnotationColor pinColor;

@end
