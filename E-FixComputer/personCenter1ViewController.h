//
//  personCenter1ViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface personCenter1ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    //定义一个AppDelegate实例变量
    AppDelegate *personapp;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonExit;


- (IBAction)exitlogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tuichu;

@end
