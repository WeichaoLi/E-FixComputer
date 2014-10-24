//
//  AppintroduceViewController.m
//  易修电脑
//
//  Created by administrator on 13-12-12.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "AppintroduceViewController.h"
#import "publicMethod.h"

@interface AppintroduceViewController ()

@end

@implementation AppintroduceViewController

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
    // Do any additional setup after loading the view from its nib.//导航条，返回按钮，标题
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backToPersentCenter)];
}
//返回按钮执行事件
- (void)backToPersentCenter{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
