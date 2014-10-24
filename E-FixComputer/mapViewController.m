//
//  mapViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "mapViewController.h"
#import "engListViewController.h"
#import "CustomAnnotation.h"
#import "ASIHTTPRequest.h"
#import "CustomAnnotation.h"
#import "Engineer.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "publicMethod.h"
#import "engineerDetailViewController.h"
#import "User.h"
@interface mapViewController (){
    NSMutableArray *_annotationList;
    CustomAnnotation *_CustomAnnotation;
    engListViewController *view2;
}

@end

@implementation mapViewController

@synthesize detailViewController;

NSString *userLatitude;
NSString *userLongitude;
NSString *engLat;
NSString *englng;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //添加导航栏
  [publicMethod addNavigationBar:self];
  [publicMethod addBtn1:self backGroundimage:[UIImage imageNamed:@"checkInfo1.png"] action:@selector(showDownList)];
    
    self.myMap.delegate=self;
    _annotationList = [[NSMutableArray alloc]init];
    
    //显示用户位置
    self.myMap.showsUserLocation = YES;
    //地图类型
    self.myMap.mapType = MKMapTypeStandard;
    _locationManager= [[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    
    //设置位置管理器的委托对象
    _locationManager.delegate = self;
    //精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    //设置距离筛选器
    self.locationManager.distanceFilter = 1000.0f;
    
    //开始更新位置（检测到位移1000m以上进行位置更新）
    [self.locationManager startUpdatingLocation];
    
}

- (void)showDownList{
//    if (view2 == nil) {
//        view2 = [[engListViewController alloc]initWithNibName:@"engListViewController" bundle:nil];
//    }
    [[[publicMethod Add_appDelegate].tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
//   [[[publicMethod Add_appDelegate].tabBarController.viewControllers objectAtIndex:0] pushViewController:view2 animated:YES];
  }

- (void)viewWillAppear:(BOOL)animated{
    //异步取所有工程师位置信息
    self.tabBarController.tabBar.hidden = NO;
    [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/allengineer"];
    [self.myMap reloadInputViews];
    self.myMap.delegate=self;
     _annotationList = [[NSMutableArray alloc]init];
    
     //显示用户位置
     self.myMap.showsUserLocation = YES;
     //地图类型
     self.myMap.mapType = MKMapTypeStandard;
     _locationManager= [[CLLocationManager alloc]init];
     self.locationManager.delegate=self;
    
     //设置位置管理器的委托对象
     _locationManager.delegate = self;
     //精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    //设置距离筛选器
    self.locationManager.distanceFilter = 1000.0f;
  
   //开始更新位置（检测到位移1000m以上进行位置更新）
   [self.locationManager startUpdatingLocation];
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"error!%@",request.error);
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    self.position = [NSMutableArray array];
    
    NSData *data = [request responseData];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    for (NSDictionary *dic in list) {
        Engineer *eng = [[Engineer alloc]init];
        
        eng.engineerid = [dic objectForKey:@"engineer_id"];
        eng.engineername = [dic objectForKey:@"engineer_name"];
        eng.status = [dic objectForKey:@"engineer_status"];
        eng.portrait = [dic objectForKey:@"engineer_portrait"];
        eng.repairnumber = [dic objectForKey:@"engineer_repairnumber"];
        eng.grade = [dic objectForKey:@"engineer_grade"];
        eng.longitude = [dic objectForKey:@"engineer_longitude"];
        eng.latitude = [dic objectForKey:@"engineer_latitude"];
        double engLat = [eng.latitude doubleValue];
        double englng = [eng.longitude doubleValue];
        if (![userLatitude isEqualToString:@""]) {
       
        eng.distance = [NSString stringWithFormat:@"%.0f 米",[self distanceBetweenOrderBy:[userLatitude doubleValue] :engLat :[userLongitude doubleValue] :englng]];
        }else{
        eng.distance =nil;
        }
        NSLog(@"%@",userLatitude);
       
        [_position addObject:eng];
    }
    [self.myMap reloadInputViews];
}

//打印当前坐标
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //设置地图显示精度
    //设置地图显示精度
    CLLocationCoordinate2D coor = userLocation.coordinate;
    userLatitude = [NSString stringWithFormat:@"%.4f", coor.latitude];
    userLongitude = [NSString stringWithFormat:@"%.4f", coor.longitude];
    NSLog(@"haha %@",userLatitude);
    [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/allengineer"];
    MKCoordinateSpan span;
    
    userLocation.title = @"我的位置";
    userLocation.subtitle = @"用户";

    MKCoordinateRegion region;
    span.latitudeDelta=0.060;
    
    span.longitudeDelta=0.060;
    
    region.span=span;
    
    region.center=[userLocation coordinate];
 
    [self.myMap setRegion:region animated:YES];
    //[self.locationManager stopUpdatingLocation];
}

//注解视图 ,设置大头针颜色、添加附属按钮等，
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MKPinAnnotationView *av;
    
    for(av in views){
        //用户位置没有右边的附属按钮
        
        if ([av.annotation.title isEqualToString:@"我的位置"]){
            av.rightCalloutAccessoryView = nil;
            continue;
        }else{
            
            //从天上落下的动画
            av.animatesDrop = YES;
            av.pinColor = MKPinAnnotationColorGreen;
            UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            av.canShowCallout =YES;
            av.rightCalloutAccessoryView = button;
            
            //左边显示工程师头像
            CGRect resizeRect;
            resizeRect.origin = (CGPointMake(0.0f, 0.0f));
            
            UIGraphicsBeginImageContext(resizeRect.size);
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            av.image = resizedImage;
            av.opaque = NO;
            CustomAnnotation  *annotations= av.annotation;
        
            UIImageView *sfIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            [sfIconView setImage:[publicMethod GetImage:annotations.ENGannotation.portrait ]];
            
            av.leftCalloutAccessoryView = sfIconView;
            av.canShowCallout = YES;
        }
    }
}

//点击大头针的视图
-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view  calloutAccessoryControlTapped:(UIControl *) control{
    CustomAnnotation  *annotations= view.annotation;
    detailViewController.PassEng = annotations.ENGannotation;
}

//委托方法，自动调用,获取用户和工程师位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //传值
    for (Engineer *eng in _position) {
        NSString *engName = eng.engineername;
        double engLat = [eng.latitude doubleValue];
        double engLng = [eng.longitude doubleValue];
        //创建一个2D坐标位置
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(engLat,engLng);
        
        //设置图钉
        CustomAnnotation *location = [[CustomAnnotation alloc]initWithCoordinate:coords];
        location.ENGannotation = eng;
        //添加大头针
        [self.myMap addAnnotation:location];
        
        location.title = engName;
        location.subtitle=eng.distance;
        }
    }

//计算工程师与用户距离
- (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:[userLatitude doubleValue]  longitude:[userLongitude doubleValue]];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    return [curLocation distanceFromLocation:otherLocation];
   
}

- (void)showDetails:(id)sender{
    [self.navigationController setToolbarHidden:YES animated:NO];
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = YES;
    detailViewController.rootViewController = self;
    [[[publicMethod Add_appDelegate].tabBarController.viewControllers objectAtIndex:0] pushViewController:detailViewController animated:YES];
}

//获取经纬度失败时候调用的代理方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error = %@",error);
}

//mapView加载完地图时调用的方法
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    NSLog(@"mapView Did Finish Loading Map");
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end

