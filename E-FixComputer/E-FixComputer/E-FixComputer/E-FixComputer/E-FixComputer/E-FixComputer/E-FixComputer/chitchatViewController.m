//
//  chitchatViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "chitchatViewController.h"
#import "engineerDetailViewController.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "Engineer.h"
#import "User.h"

@interface chitchatViewController (){
    engineerDetailViewController *engineerDetail;
    User *user;
    Engineer *engineer;
}

@end

@implementation chitchatViewController

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
    
    //加入导航栏，按钮,标题
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backtoChatList)];
    
    if ([self.PassObject isKindOfClass:[User class]]) {
        user = self.PassObject;
        [publicMethod addTitleOnNavigationBar:self titleContent:user.username];
    }else{
        engineer = self.PassObject;
        [publicMethod addTitleOnNavigationBar:self titleContent:engineer.name];
    }

    [publicMethod addRightButton:self backGroundimage:[UIImage imageNamed:@"Icon_Profile@2x.png"] action:@selector(BrowseInformation)];
}

//返回按钮
- (void)backtoChatList{
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
    [publicMethod Add_appDelegate].tabBarController.selectedIndex = 1;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//查看聊天对象的资料
- (void)BrowseInformation{
    if ([self.PassObject isKindOfClass:[User class]]) {
        NSLog(@"user");
    }else{
        if (engineerDetail == nil) {
            engineerDetail = [[engineerDetailViewController alloc] initWithNibName:@"engineerDetailViewController" bundle:nil];
            engineerDetail.PassEng = self.PassObject;
        }
        [self.navigationController pushViewController:engineerDetail animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
