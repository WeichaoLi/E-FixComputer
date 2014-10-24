//
//  orderViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "orderViewController.h"
#import "waitViewController.h"
#import "fixingViewController.h"
#import "completedViewController.h"
#import "publicMethod.h"

@interface orderViewController ()

@end

@implementation orderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //定义tabBarItem的标题
        self.tabBarItem.title = NSLocalizedString(@"预约", @"预约");
        
        //定义tabBarItem的图标
        self.tabBarItem.image = [UIImage imageNamed:@"515969"];
    }
    return self;
}
//订单页面的切换
- (void)viewDidLoad
{
    [super viewDidLoad];

    //添加导航栏
    [publicMethod addNavigationBar:self];
    //添加分段控件
    if (self.segentedControl == nil) {
        self.segentedControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(-3, 20, 326, 34)];
    }
    self.segentedControl.tintColor = [UIColor groupTableViewBackgroundColor];
    
    [self.segentedControl addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    [self.segentedControl insertSegmentWithTitle:@"1" atIndex:0 animated:YES];
    [self.segentedControl insertSegmentWithTitle:@"2" atIndex:1 animated:YES];
    [self.segentedControl insertSegmentWithTitle:@"3" atIndex:2 animated:YES];
    self.segentedControl.selectedSegmentIndex = 0;
    [self.segentedControl setTitle:@"未接受" forSegmentAtIndex:0];//设置指定索引的题目
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        [self.segentedControl setTitle:@"已处理" forSegmentAtIndex:1];
    }else{
        [self.segentedControl setTitle:@"已接受" forSegmentAtIndex:1];
    }
    [self.segentedControl setTitle:@"已完成" forSegmentAtIndex:2];
    
    [self.view addSubview:self.segentedControl];
    [self segmentAction];
    [publicMethod Add_appDelegate].isRefreshOrder = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarItem.badgeValue = nil;
    if (![publicMethod isConnectionAvailable]) {
        [[publicMethod Add_appDelegate] showAlertView:@"请检查网络"];
        [publicMethod Add_appDelegate].isRefreshOrder = YES;
    }else{
        NSLog(@"=========%hhd",[publicMethod Add_appDelegate].isRefreshOrder);
        if([publicMethod Add_appDelegate].isRefreshOrder){
            self.viewController3 = nil;
            self.viewController4 = nil;
            self.viewController5 = nil;
            
            self.segentedControl.selectedSegmentIndex = 0;
            [self segmentAction];
            [publicMethod Add_appDelegate].isRefreshOrder = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentAction{
    if (self.IsWait) {
        self.viewController3 = nil;
        self.IsWait = NO;
    }
    if (self.isreload) {
        self.viewController3 = nil;
        self.viewController4 = nil;
        self.isreload = NO;
    }
    if (self.segentedControl.selectedSegmentIndex == 0) {
        //跳到等待接受视图
//        if (self.viewController3 == nil) {
            self.viewController3 = [[waitViewController alloc]initWithNibName:@"waitViewController" bundle:nil];
            self.viewController3.view.frame = CGRectMake(0, 54, 320, 370);
            [self.view addSubview:self.viewController3.view];
            self.viewController3.rootviewcontroller = self;
//        }
        self.viewController3.view.hidden = NO;
        self.viewController4.view.hidden = YES;
        self.viewController5.view.hidden = YES;
    }
    if (self.segentedControl.selectedSegmentIndex == 1)
    {
        //跳到等待完成视图
//        if (self.viewController4 == nil) {
            self.viewController4 = [[fixingViewController alloc]initWithNibName:@"fixingViewController" bundle:nil];
            self.viewController4.view.frame = CGRectMake(0, 54, 320, 370);
            [self.view addSubview:self.viewController4.view];
            self.viewController4.rootviewcontroller = self;
//        }
        self.viewController3.view.hidden = YES;
        self.viewController4.view.hidden = NO;
        self.viewController5.view.hidden = YES;
    }
    
    if (self.segentedControl.selectedSegmentIndex == 2) {
        //跳到已完成视图
//        if (self.viewController5 == nil) {
            self.viewController5 = [[completedViewController alloc]initWithNibName:@"completedViewController" bundle:nil];
            self.viewController5.view.frame = CGRectMake(0, 54, 320, 370);
            [self.view addSubview:self.viewController5.view];
            self.viewController5.rootviewcontroller = self;
//        }
        self.viewController3.view.hidden = YES;
        self.viewController4.view.hidden = YES;
        self.viewController5.view.hidden = NO;
    }
}

@end
