//
//  chatViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "chatViewController.h"
#import "publicMethod.h"

@interface chatViewController ()

@end

@implementation chatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //定义tabBarItem的标题
        self.tabBarItem.title = NSLocalizedString(@"消息", @"消息");
        
        //定义tabBarItem的图标
        self.tabBarItem.image = [UIImage imageNamed:@"Icon_Activity"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加导航栏，返回按钮，标题
    [publicMethod addNavigationBar:self];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"消息"];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
