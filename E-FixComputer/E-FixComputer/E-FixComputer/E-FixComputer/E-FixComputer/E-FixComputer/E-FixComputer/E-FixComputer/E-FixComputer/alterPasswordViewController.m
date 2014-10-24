//
//  alterPasswordViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "alterPasswordViewController.h"

#import "publicMethod.h"
#define SHOST @"http://localhost:8888/ERC/index.php/"
//引进2个类识别登入信息
#import "User.h"
#import "Engineer.h"
@interface alterPasswordViewController ()

@end

@implementation alterPasswordViewController

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
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backToLoginView)];
    
    //定义一个app实例类获取登入信息
    alterapp = [publicMethod Add_appDelegate];
}
//返回按钮执行事件
- (void)backToLoginView{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)comepeletealter:(id)sender {
    //判断3个textfield为空
    if ([self.passwordold.text isEqualToString:@""]||[self.passwordnew.text isEqualToString:@""]||[self.passwordnew2.text isEqualToString:@""]) {
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"以上选项为必填" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
    }
    //判断2次密码正不正确
    else if (![self.passwordnew.text isEqualToString:self.passwordnew2.text]){
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"2次输入的密码不同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
    }
    
    //判断密码正不正确
    else{
        NSLog(@"%@",alterapp.loginuser.username);
        NSLog(@"%@",alterapp.loginuser.password);
        if(![self.passwordold.text isEqualToString:alterapp.loginuser.password]){
            UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码输入不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [elert1 show];
        }
        else{
            NSString *urlStr = [NSString stringWithFormat:@"%@user/alterPW",SHOST];
            NSURL *url=[NSURL URLWithString:urlStr];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            [request setPostValue:alterapp.loginuser.username forKey:@"username"];
            [request setPostValue:self.passwordold.text forKey:@"password"];
            [request setPostValue:self.passwordnew.text forKey:@"newpassword"];
            [request startSynchronous];
            NSString *result = [request responseString];
            NSLog(@"%@",result);
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    
}
//以下方法用来去键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)TextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0-40);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
