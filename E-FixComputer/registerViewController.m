//
//  registerViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "registerViewController.h"
#import "message1ViewController.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "personCenter1ViewController.h"

@interface registerViewController ()

@end

@implementation registerViewController

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
//    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"渐变2"] ];
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backToLoginView)];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"注册"];
    registerapp = [publicMethod Add_appDelegate];
    //设置确定按钮
    UIButton *sure = [[UIButton alloc]init];
    sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame = CGRectMake(60, 360, 220, 30);
    sure.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
    sure.titleLabel.textColor = [UIColor whiteColor];
    sure.layer.cornerRadius = 5;
    [sure setTitle:@"注册" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    //设置4个外textfield不能点
    self.noedit.enabled = NO;
    self.noedit2.enabled = NO;
    self.noedit3.enabled = NO;
    self.noedit4.enabled = NO;
    
    self.username.placeholder = @"请输入2到14位用户名";
    self.password.placeholder = @"请输入6到16位密码";
    self.email.placeholder = @"请输入有效的邮箱";
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

//判断用户名长度为2到14，可以输中文
-(BOOL)validateUser:(NSString *)user{
    NSString *userRegex=@"^[A-Za-z0-9\u4E00-\u9FA5_-]+${2,14}";
    NSPredicate *userTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",userRegex];
    return [userTest evaluateWithObject:user];
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

//以下方法用来去键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)TextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}


//如果为空,执行插入php注册圆满成功
- (void)logIn{
    //判空
    if([self.username.text isEqualToString:@""]||[self.password.text isEqualToString:@""]||[self.password1.text isEqualToString:@""]||[self.email.text isEqualToString:@""]){
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"以上选项为必填" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
    }
    //用户名符不符合格式
    else if(![publicMethod validateUser:self.username.text]){
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，用户名长度不正确或存在特殊字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
        self.username.text=@"";
    }
    //判断密码长度
    else if (self.password1.text.length<6){
        UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码长度不符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert1 show];
    }
    //判断密码是否相等
    else if (![self.password1.text isEqualToString:self.password.text]){
        UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码输入不同！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert1 show];
    }
    //判断邮箱符不符合格式
    else if (![publicMethod validateEmail:self.email.text]){
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"邮件格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
        self.email.text=@"";
    }
    else{
        
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/register",HOST]];
        ASIFormDataRequest *asiFormData=[ASIFormDataRequest requestWithURL:url];
        [asiFormData setPostValue:self.username.text forKey:@"username"];
        [asiFormData setPostValue:self.password.text forKey:@"password"];
        [asiFormData setPostValue:self.email.text forKey:@"email"];
//        [asiFormData setPostValue:registerapp.deviceToken forKey:@"deviceToken"];
        [asiFormData startSynchronous];
        if (asiFormData.error !=nil) {
            UIAlertView *tip2 = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"目前网络环境不佳" delegate:nil cancelButtonTitle:@"重试" otherButtonTitles:nil];
            [tip2 show];
        }
        else{
        NSString *result = [asiFormData responseString];
        //如果查询结果不为空
        if([result isEqualToString:@"exist"]){
            UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，该用户名已经被注册！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [elert1 show];
        }
        else if(![result isEqualToString:@"fail"]){
            NSLog(@"%@",[asiFormData responseString]);
            UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功注册！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [elert1 show];
            
            NSData *data = [asiFormData responseData];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            //自助登入
            User *generaluser = [[User alloc]init];
            generaluser.username = [dic objectForKey:@"user_name"];
            generaluser.email = [dic objectForKey:@"user_email"];
            generaluser.userid = [dic objectForKey:@"user_id"];
            generaluser.deviceToken = registerapp.deviceToken;
            registerapp.loginuser = generaluser;
            
            //存入本地记住用户名,默认登入状态为NO，删除本地图片
            [NSKeyedArchiver archiveRootObject:registerapp.loginuser toFile:[self FilePath:@"login.plist"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"user" forKey:@"logintype"];
            [[NSUserDefaults standardUserDefaults]setObject:generaluser.username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"status"];
            
            NSString *saveName=@"head.png";
            NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",saveName,nil];
            NSString *fullPath =[NSString pathWithComponents:segments];
            NSFileManager *file=[NSFileManager defaultManager];
            
            if([file fileExistsAtPath:fullPath isDirectory:NO]){
                [file removeItemAtPath:fullPath error:nil];
            }

            
            personCenter1ViewController *personCenter1View = [[personCenter1ViewController alloc]initWithNibName:@"personCenter1ViewController" bundle:Nil];
            
            [publicMethod Add_appDelegate].isRefreshOrder = YES;
            [publicMethod Add_appDelegate].isRefreshMessage = YES;
            //连接openfire
            [publicMethod connectOpenfire];
            [publicMethod registerOpenfire];
            [self.navigationController pushViewController:personCenter1View animated:YES];
            }
        }
    }
}

//普通用户存本地
-(NSString *)FilePath:(NSString*)filename{
    NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",filename,nil];
    return [NSString pathWithComponents:segments];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0-38);//键盘高度216
    
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

@end

