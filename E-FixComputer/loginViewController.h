//
//  loginViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@interface loginViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>
{
    AppDelegate *loginapp;
}


//忘记密码按钮
- (IBAction)getBackPassword:(id)sender;
//注册按钮
- (IBAction)registerView:(id)sender;
//2个textfield
@property (weak, nonatomic) IBOutlet UITextField *TFusername;
@property (weak, nonatomic) IBOutlet UITextField *TFuserpassword;
//2个textfield，编辑完成时执行的操作
- (IBAction)TextField_DidEndOnExit:(id)sender;
//2个大textfield属性
@property (weak, nonatomic) IBOutlet UITextField *notedit2;
@property (weak, nonatomic) IBOutlet UITextField *notedit;
//按钮实现图片的显示跟记住密码
@property (weak, nonatomic) IBOutlet UIButton *rememberpassword;

- (IBAction)Rememberpassword:(id)sender;
//属性，定义记住的状态
@property BOOL remember;
//结束编辑时执行的操作

@property (weak, nonatomic) IBOutlet UIImageView *headview;

@end
