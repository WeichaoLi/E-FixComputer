//
//  textViewController.m
//  易修电脑
//
//  Created by administrator on 13-12-12.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "textViewController.h"
#import "publicMethod.h"
@interface textViewController ()

@end

@implementation textViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加导航栏
    [publicMethod addNavigationBar:self];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"他的资料"];
    //左边的返回按钮
    [publicMethod addBackButton:self action:@selector(BacktoFormater)];

    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"login_bg.jpg"] ];
}
//返回按钮的方法
- (void)BacktoFormater{
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
