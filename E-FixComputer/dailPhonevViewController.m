//
//  dailPhonevViewController.m
//  易修电脑
//
//  Created by administrator on 13-12-20.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "dailPhonevViewController.h"
#import "publicMethod.h"

@interface dailPhonevViewController ()

@end

@implementation dailPhonevViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    UIWebView *callWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 54, 320, 426)];
    if(!callWebView){
        callWebView=[[UIWebView alloc]initWithFrame:CGRectZero];
    }
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phonenumber]]]];
    [self.view addSubview:callWebView];
    NSLog(@"%@",self.phonenumber);
    NSLog(@"打电话");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加导航栏
    [publicMethod addNavigationBar:self];
    [publicMethod addTitleOnNavigationBar:self titleContent:@""];
    //左边的返回按钮
    [publicMethod addBackButton:self action:@selector(BacktoFormater)];
    
    
}

//返回按钮的方法
- (void)BacktoFormater{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
