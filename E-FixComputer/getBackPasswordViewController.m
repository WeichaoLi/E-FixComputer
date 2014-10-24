//
//  getBackPasswordViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "getBackPasswordViewController.h"
#import "publicMethod.h"
#define SHOST @"http://localhost:8888/ERC/index.php/"

@interface getBackPasswordViewController ()

@end

@implementation getBackPasswordViewController

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
    [publicMethod addTitleOnNavigationBar:self titleContent:@"找回密码"];
    //设置确定按钮
    UIButton *sure = [[UIButton alloc]init];
    sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(50, 360, 220, 30);
    sure.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
    sure.titleLabel.textColor = [UIColor whiteColor];
    sure.layer.cornerRadius = 5;
    [sure setTitle:@"登录" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    //设置4个外textfield不能点
    self.noedit.enabled = NO;
    self.noedit2.enabled = NO;
    self.noedit3.enabled = NO;
    self.noedit4.enabled = NO;
    
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

//点击完成找回密码
- (void)logIn{
    //判断4个textfield为空
    if ([self.getbackusername.text isEqualToString:@""]||[self.newpassword1.text isEqualToString:@""]||[self.newpassword2.text isEqualToString:@""]||[self.getbackemail.text isEqualToString:@""]) {
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"以上选项为必填" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
    }
    //判断密码长度不小于6
    else if (self.newpassword1.text.length<6){
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码长度不符合" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
    }
    //判断2次密码正不正确
    else if (![self.newpassword1.text isEqualToString:self.newpassword2.text]){
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"2次输入的密码不同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
    }
    //判断用户名跟邮箱正不正确
    else{
        NSString *urlStr = [NSString stringWithFormat:@"%@user/forgetPW",SHOST];
        NSURL *url=[NSURL URLWithString:urlStr];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:self.getbackusername.text forKey:@"username"];
        [request setPostValue:self.getbackemail.text forKey:@"email"];
        [request setPostValue:self.newpassword1.text forKey:@"password"];
        [request startSynchronous];
       
        if (request.error!=nil) {
            UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"目前网络环境不佳" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
            [elert1 show];
        }
        else{
        NSString *result = [request responseString];
        NSLog(@"%@",result);
        if([result isEqualToString:@"fail"]){
            UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户未注册或邮箱不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [elert1 show];
        }
        else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
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
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//4个textfield允许输入长度只能为18
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *textString = textField.text ;
    NSUInteger length = [textString length]+1;
    BOOL bChange =YES;
    if (length >= 18)
        bChange = NO;
    if (range.length == 1) {
        bChange = YES;
    }
    return bChange;
}
@end
