//
//  engListViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "engListViewController.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "EngineerCell.h"
#import "Engineer.h"
#import "engineerDetailviewController.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "mapViewController.h"

@interface engListViewController (){
    mapViewController *mapview;
    UIView *downlist;
    UIButton *orderBydefault;
    UIButton *orderBygrade;
    UIButton *orderBydistance;
    UIButton *orderbyrepairnumber;
    BOOL isRefresh;
}

@end

@implementation engListViewController
NSString *userLatitude;
NSString *userLongitude;
NSString *engLat;
NSString *englng;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //定义tabBarItem的标题
        self.tabBarItem.title = NSLocalizedString(@"主页面", @"主页面");
        
        //定义tabBarItem的图标
        self.tabBarItem.image = [UIImage imageNamed:@"Icon_Home.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self.mytableView setSectionIndexMinimumDisplayRowCount:50];
    
    [publicMethod addNavigationBar:self];
    
    [publicMethod addBtn1:self backGroundimage:[UIImage imageNamed:@"checkInfo1.png"] action:@selector(showDownList)];
    [publicMethod addBtn2:self backGroundimage:[UIImage imageNamed:@"Icon_Explore1.png"] action:@selector(tomaplist)];
    if ([publicMethod isConnectionAvailable]) {
        [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/allengineer"];
    }
    
    _PullDownRefreshView = [[EGORefreshTableHeaderView alloc] initWithScrollView:self.mytableView orientation:EGOPullOrientationDown];
    
    _PullDownRefreshView.delegate = self;
    
    NSLog(@"%f",self.mytableView.contentSize.height);
    CGSize size = self.mytableView.frame.size;
    size.height +=1;
    self.mytableView.contentSize = size;
    [_PullDownRefreshView adjustPosition];
    
    _currentLoaction = [[CLLocationManager alloc] init];
    
    _currentLoaction.delegate = self;
    //精度
    self.currentLoaction.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    //设置距离筛选器
    self.currentLoaction.distanceFilter = 1000.0f;
    
    [_currentLoaction startUpdatingLocation];
    
    downlist = [[UIView alloc] initWithFrame:CGRectMake(50, 34, 0, 0)];
    downlist.layer.cornerRadius = 10;
    downlist.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:downlist];
    isRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
    //检测网络
    if (![publicMethod isConnectionAvailable]) {
        [[publicMethod Add_appDelegate] showAlertView:@"请检查网络"];
        self.EngList = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:@"engineerList.plist"]];
        [self.mytableView reloadData];
        isRefresh = YES;
    }else{
        if (isRefresh){
            [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/allengineer"];
            isRefresh = NO;
        }
    }
}

- (void)addButton{
    
    orderBydefault = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBygrade = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBydistance = [UIButton buttonWithType:UIButtonTypeCustom];
    orderbyrepairnumber = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [orderBydefault setTitle:@"默认" forState:UIControlStateNormal];
    [orderBygrade setTitle:@"按评分" forState:UIControlStateNormal];
    [orderBydistance setTitle:@"按距离" forState:UIControlStateNormal];
    [orderbyrepairnumber setTitle:@"按修理次数" forState:UIControlStateNormal];
    
    orderBydefault.frame = CGRectMake(0, 0, 100, 40);
    orderBygrade.frame = CGRectMake(0, 41, 100, 40);
    orderBydistance.frame = CGRectMake(0, 82, 100, 40);
    orderbyrepairnumber.frame = CGRectMake(0, 123, 100, 40);
    
    orderBydefault.tag = 1;
    orderBygrade.tag = 2;
    orderBydistance.tag = 3;
    orderbyrepairnumber.tag = 4;
    
    
    orderBydefault.backgroundColor = [UIColor blackColor];
    orderBygrade.backgroundColor = [UIColor blackColor];
    orderBydistance.backgroundColor = [UIColor blackColor];
    orderbyrepairnumber.backgroundColor = [UIColor blackColor];
    
    orderBydefault.titleLabel.font = [UIFont systemFontOfSize:16];
    orderBygrade.titleLabel.font = [UIFont systemFontOfSize:16];
    orderBydistance.titleLabel.font = [UIFont systemFontOfSize:16];
    orderbyrepairnumber.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [orderBydefault addTarget:self action:@selector(orderBy:) forControlEvents:UIControlEventTouchUpInside];
    [orderBygrade addTarget:self action:@selector(orderBy:) forControlEvents:UIControlEventTouchUpInside];
    [orderBydistance addTarget:self action:@selector(orderBy:) forControlEvents:UIControlEventTouchUpInside];
    [orderbyrepairnumber addTarget:self action:@selector(orderBy:) forControlEvents:UIControlEventTouchUpInside];
    
    [downlist addSubview:orderBydefault];
    [downlist addSubview:orderBygrade];
    [downlist addSubview:orderBydistance];
    [downlist addSubview:orderbyrepairnumber];
}

- (void)showDownList{
    if (downlist.frame.size.height == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5f];
        downlist.frame = CGRectMake(0, 54, 100, 160);
        [self addButton];
        [UIView commitAnimations];
    }else{
        [self hiddenDownList];
    }
}

- (void)hiddenDownList{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    downlist.frame = CGRectMake(50, 34, 0, 0);
    orderbyrepairnumber.frame = CGRectMake(0, 0, 0, 0);
    orderBydistance.frame = CGRectMake(0, 0, 0, 0);
    orderBygrade.frame = CGRectMake(0, 0, 0, 0);
    orderBydefault.frame = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self hiddenDownList];
}

- (void)orderBy:(UIButton*)sender{
    if (sender.tag ==1){
        [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/allengineer"];
        [self showDownList];
    }else if(sender.tag == 2){
        [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/OrderByGrade"];
        [self showDownList];
    }else if(sender.tag == 3){
        self.EngList = [[self.EngList sortedArrayUsingComparator:^(Engineer *obj1,Engineer *obj2){
            if ([obj1.distance intValue]> [obj2.distance intValue]){
                return (NSComparisonResult)NSOrderedDescending;
                }
            return (NSComparisonResult)NSOrderedSame;
        }] mutableCopy];
        [self.mytableView reloadData];
        [self showDownList];
    }
    else{
        [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/OrderByrepairnumber"];
        [self showDownList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"数据请求失败");
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    self.EngList = [NSMutableArray array];
    
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
        eng.goodat = [dic objectForKey:@"engineer_goodat"];
        double engLat = [eng.latitude doubleValue];
        double englng = [eng.longitude doubleValue];
        
        if (![userLongitude isEqualToString:@""]) {
            eng.distance = [NSString stringWithFormat:@"%.0f 米",[self distanceBetweenOrderBy:[userLatitude doubleValue] :engLat :[userLongitude doubleValue] :englng]];
        }
        [self.EngList addObject:eng];
    
    }
    [NSKeyedArchiver archiveRootObject:self.EngList toFile:[publicMethod getDocumentPath:@"engineerList.plist"]];
    [self.mytableView reloadData];
    [self.requestList cancelAuthentication];
    [self.requestList cancel];
}
//- (NSComparisonResult)compare: (NSArray *)array
//{
//    for (Engineer *obj1,*obj2 in array) {
//         NSComparisonResult result = [obj1.distance compare:obj2.distance];
//    }
//    
//    NSComparisonResult result = [number1 compare:number2];
//    
//    return result == NSOrderedDescending; // 升序
//    //    return result == NSOrderedAscending;  // 降序
//}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    userLatitude = [NSString stringWithFormat:@"%.4f", coor.latitude];
    userLongitude = [NSString stringWithFormat:@"%.4f", coor.longitude];
   
    [publicMethod AsynchronousGainData:self.requestList Target:self Path:@"engineer/allengineer"];
}

//计算工程师与用户距离
- (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:[userLatitude doubleValue]  longitude:[userLongitude doubleValue]];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    return [curLocation distanceFromLocation:otherLocation];
}

- (void)tomaplist{
    NSLog(@"地图");
    if (mapview == nil) {
        mapview = [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
    }
    [[[publicMethod Add_appDelegate].tabBarController.viewControllers objectAtIndex:0] pushViewController:mapview animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.EngList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    EngineerCell *cell;
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"EngineerCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    }
    cell = (EngineerCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor =[UIColor colorWithRed:251.0/255.0 green:178.0/255.0 blue:23.0/255.0 alpha:0.1];
    
    Engineer *eng = [self.EngList objectAtIndex:indexPath.row];
    //头像
    cell.imagePortrait.image = [publicMethod GetImage:eng.portrait];
    //名字
    cell.lablename.text = eng.engineername;
    
    //擅长
    cell.begoodat.text = eng.goodat;

    //距离
        cell.distance.text = eng.distance;
        cell.distance.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
    
    //评分
    cell.lablegrade.text = [NSString stringWithFormat:@"%@分",eng.grade];
    cell.lablegrade.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
    //状态
    if ([eng.status isEqualToString:@"1"]) {
    }else{
        UIGraphicsBeginImageContextWithOptions(cell.imagePortrait.image.size, NO, [UIScreen mainScreen].scale);
        [cell.imagePortrait.image drawInRect:CGRectMake(0, 0, cell.imagePortrait.image.size.width, cell.imagePortrait.image.size.height)
                                   blendMode:kCGBlendModeDarken
                                       alpha:0.4];
        cell.imagePortrait.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    //修理次数
    cell.lablerepairNumber.text = eng.repairnumber;
    cell.lablerepairNumber.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenDownList];
    engineerDetailViewController *detailViewController = [[engineerDetailViewController alloc]initWithNibName:@"engineerDetailViewController" bundle:Nil];
    
    Engineer *eng = [self.EngList objectAtIndex:indexPath.row];
    detailViewController.PassEng = eng;
    detailViewController.rootViewController = self;
    
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = YES;
    [[[publicMethod Add_appDelegate].tabBarController.viewControllers objectAtIndex:0] pushViewController:detailViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_PullDownRefreshView egoRefreshScrollViewDidScroll:self.mytableView];
    [_PullUpRefreshView egoRefreshScrollViewDidScroll:self.mytableView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_PullDownRefreshView egoRefreshScrollViewDidEndDragging:self.mytableView];
    [_PullUpRefreshView egoRefreshScrollViewDidEndDragging:self.mytableView];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)refreshDone {
    _reloading = NO;
    [_PullDownRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mytableView];
    [_PullUpRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mytableView];
    
    [self viewWillAppear:YES];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self performSelector:@selector(refreshDone) withObject:nil afterDelay:1.0f];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return [NSDate date];
}

@end
