//
//  loginViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "loginViewController.h"
#import "getBackPasswordViewController.h"
#import "registerViewController.h"
#import "User.h"
#import "ToolKit.h"
#import "Engineer.h"
#import "publicMethod.h"
#import "commentViewController.h"

@interface loginViewController ()

@end

@implementation loginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
  
    //导航条，返回按钮，标题
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backToPersentCenter)];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"欢迎登录"];

    //设置登录按钮
    UIButton *loginbutton = [[UIButton alloc]init];
    loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbutton.frame = CGRectMake(50, 320, 220, 30);
    loginbutton.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
    loginbutton.titleLabel.textColor = [UIColor whiteColor];
    loginbutton.layer.cornerRadius = 5;
    [loginbutton setTitle:@"登录" forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbutton];
 
    //设置2个外textfield不能点
    self.notedit.enabled = NO;
    self.notedit2.enabled = NO;
    
    //视图加载时加载用户名跟密码
    

    //初始化一个del
    loginapp = [publicMethod Add_appDelegate];
    
    

    
}
-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"password"]);
    self.TFusername.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
//    self.TFuserpassword.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
    self.remember = [[NSUserDefaults standardUserDefaults] boolForKey:@"status"];
    
    //根据有无密码与否加载不同的图片
    if (self.remember == NO) {
        self.TFuserpassword.text = @"";
        [self.rememberpassword setBackgroundImage:[UIImage imageNamed:@"forget.png"] forState:UIControlStateNormal];
        
    }
    if (self.remember == YES){
    
        [self.rememberpassword setBackgroundImage:[UIImage imageNamed:@"remember.png"] forState:UIControlStateNormal];
        self.TFuserpassword.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"password"]);
    }
    
    //加载本地图片
    NSMutableString *saveName=[NSMutableString stringWithString:@"head.png"];
    NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",saveName,nil];
    NSString *fullPath =[NSString pathWithComponents:segments];
    NSFileManager *file=[NSFileManager defaultManager];
    
    if([file fileExistsAtPath:fullPath isDirectory:NO]){
        NSData *sandData=[NSData dataWithContentsOfFile:fullPath];
        self.headview.image=[UIImage imageWithData:sandData];
    }
    else{
        self.headview.image =  [UIImage imageNamed:@"2432.png"];
    }
    
    [self.headview.layer setCornerRadius:50];
    self.headview.layer.masksToBounds=YES;
    self.headview.layer.borderWidth=2;
    self.headview.layer.borderColor=[[UIColor whiteColor]CGColor];

}

//返回按钮执行的事件
- (void)backToPersentCenter{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//点击之后记住状态来回切换
- (IBAction)Rememberpassword:(id)sender {
    
    if (self.remember == NO) {
        [self.rememberpassword setBackgroundImage:[UIImage imageNamed:@"remember.png"] forState:UIControlStateNormal];
        self.remember=YES;
       
    }
    else if(self.remember==YES){
        
        [self.rememberpassword setBackgroundImage:[UIImage imageNamed:@"forget.png"] forState:UIControlStateNormal];
         self.remember=NO;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:self.remember] forKey:@"status"];
        NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"status"]);
    }
}

//2textfield允许输入长度只能为18
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *textString = textField.text ;
    NSUInteger length = [textString length]+1;
//    NSLog(@"length is %lu",(unsigned long)length);
    BOOL bChange =YES;
    if (length >= 18)
        bChange = NO;
    if (range.length == 1) {
        bChange = YES;
    }
    return bChange;
}

//此区间实现textfield往上跳
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 67- (self.view.frame.size.height - 216.0);//键盘高度216
    
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

//点击登入执行的操作
-(void)logIn{
    if (self.TFusername.text.length==0||self.TFuserpassword.text.length==0){
        UIAlertView *tip2 = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"用户名或密码为空！" delegate:nil cancelButtonTitle:@"重试" otherButtonTitles:nil];
        [tip2 show];
    }
    else{
        NSString *urlStr = [NSString stringWithFormat:@"%@user/login",HOST];
        NSURL *url=[NSURL URLWithString:urlStr];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:self.TFusername.text forKey:@"username"];
        [request setPostValue: self.TFuserpassword.text forKey:@"password"];
        [request startSynchronous];
        
        if(request.error!=nil){
            UIAlertView *tip2 = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"目前网络环境不佳" delegate:nil cancelButtonTitle:@"重试" otherButtonTitles:nil];
            [tip2 show];
        }
        else
        {
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dic =list[0];
        
        //为0说明登入失败
        if ([dic count] == 0){
            UIAlertView *tip2 = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"用户名或密码错误！" delegate:nil cancelButtonTitle:@"重试" otherButtonTitles:nil];
            [tip2 show];
        }
        else{
            
            //为8说明登入的是普通的用户
            if ([dic count] == 8) {
                User *generaluser = [[User alloc]init];
                generaluser.username = [dic objectForKey:@"user_name"];
                generaluser.deviceToken = loginapp.deviceToken;
                generaluser.password = [dic objectForKey:@"user_password"];
                generaluser.email = [dic objectForKey:@"user_email"];
                generaluser.phone = [dic objectForKey:@"user_phone"];
                generaluser.portrait = [dic objectForKey:@"user_portrait"];
                generaluser.userid = [dic objectForKey:@"user_id"];
                generaluser.address = [dic objectForKey:@"user_address"];
                loginapp.loginuser = generaluser;
            }
            else if ([dic count] == 17){
                
                Engineer *engineeruser = [[Engineer alloc]init];
                engineeruser.engineerid = [dic objectForKey:@"engineer_id"];
                engineeruser.engineername = [dic objectForKey:@"engineer_name"];
                engineeruser.idcard = [dic objectForKey:@"engineer_idcard"];
                engineeruser.password = [dic objectForKey:@"engineer_password"];
                engineeruser.deviceToken = loginapp.deviceToken;
                engineeruser.portrait = [dic objectForKey:@"engineer_portrait"];
                engineeruser.grade = [dic objectForKey:@"engineer_grade"];
                engineeruser.status = [dic objectForKey:@"engineer_status"];
                engineeruser.personDescription = [dic objectForKey:@"engineer_personDescription"];
                engineeruser.repairnumber = [dic objectForKey:@"engineer_repairnumber"];
                engineeruser.phone = [dic objectForKey:@"engineer_phone"];
                engineeruser.address = [dic objectForKey:@"engineer_address"];
                engineeruser.money = [dic objectForKey:@"engineer_money"];
                engineeruser.longitude = [dic objectForKey:@"engineer_money"];
                engineeruser.latitude = [dic objectForKey:@"engineer_latitude"];
                engineeruser.registerdate = [dic objectForKey:@"engineer_registerdate"];
                loginapp.loginengineer = engineeruser;
            }
            
            //登入成功记住登入状态
            [[NSUserDefaults standardUserDefaults]setObject:self.TFusername.text forKey:@"username"];
            if (self.remember == YES)
            {
                NSString *str = [[NSString alloc]init];
                
                //如果登入状态为记住，记住密码
                [[NSUserDefaults standardUserDefaults]setObject:self.TFuserpassword.text forKey:@"password"];
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"password"]);
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:self.remember] forKey:@"status"];
                NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"status"]);
                
                //同时把登入的用户类存本地
                if ([dic count] == 8) {
                    [NSKeyedArchiver archiveRootObject:loginapp.loginuser toFile:[self FilePath:@"login.plist"]];
                    [[NSUserDefaults standardUserDefaults]setObject:@"user" forKey:@"logintype"];
                    str = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,loginapp.loginuser.portrait];
                    [publicMethod Add_appDelegate].myJID = [NSString stringWithFormat:@"1_%@",loginapp.loginuser.userid];
                    
                }
                if ([dic count] == 17) {
                    [NSKeyedArchiver archiveRootObject:loginapp.loginengineer toFile:[self FilePath:@"login.plist"]];
                    [[NSUserDefaults standardUserDefaults]setObject:@"engineer" forKey:@"logintype"];
                    str = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,loginapp.loginengineer.portrait];
                    [publicMethod Add_appDelegate].myJID = [NSString stringWithFormat:@"0_%@",loginapp.loginengineer.engineerid];
                }
                
                //登入的时候把头像存入本地
                NSURL *url = [NSURL URLWithString:str];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                
                NSString *saveName=@"head.png";
                NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",saveName,nil];
                NSString *fullPath =[NSString pathWithComponents:segments];
                NSData *imageData = UIImagePNGRepresentation(image);
                NSFileManager *file=[NSFileManager defaultManager];
                
                if([file fileExistsAtPath:fullPath isDirectory:NO]){
                    [file removeItemAtPath:fullPath error:nil];
                    [file createFileAtPath:fullPath contents:imageData attributes:nil];
                }
                else{
                    [file createFileAtPath:fullPath contents:imageData attributes:nil];
                }
            }
            else{
       
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
            }
            if ([[NSUserDefaults standardUserDefaults]synchronize]) {
                NSLog(@"save NSUserDefault succeed!");
            }
            else{
                NSLog(@"save NSUserDefault failed!");
            }
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"password"]);

            [publicMethod Add_appDelegate].isRefreshOrder = YES;
            [publicMethod Add_appDelegate].isRefreshMessage = YES;
            [self.navigationController popViewControllerAnimated:YES];
    }
    }
    }
    
}
//点击忘记密码执行的操作
- (IBAction)getBackPassword:(id)sender {
    getBackPasswordViewController *getBack = [[getBackPasswordViewController alloc]initWithNibName:@"getBackPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:getBack animated:YES];
}

//点击注册账号执行的操作
- (IBAction)registerView:(id)sender {
    registerViewController *registerView = [[registerViewController alloc]initWithNibName:@"registerViewController" bundle:nil];
    [self.navigationController pushViewController:registerView animated:YES];
}

//此区间法实现键盘的隐藏
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)TextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

//普通用户存本地
-(NSString *)FilePath:(NSString*)filename{
    NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",filename,nil];
    return [NSString pathWithComponents:segments];
}

@end

