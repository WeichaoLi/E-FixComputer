//
//  personCenter1ViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "personCenter1ViewController.h"
#import "loginViewController.h"
#import "message1ViewController.h"
#import "message2ViewController.h"
#import "User.h"
#import "Engineer.h"
#import "ToolKit.h"
#import "AppintroduceViewController.h"
#import "alterPasswordViewController.h"
#import "publicMethod.h"
#import "voucherViewController.h"
#import "engineerDetailViewController.h"
#import "dailPhonevViewController.h"
#import "chatViewController.h"

@interface personCenter1ViewController ()

@end

@implementation personCenter1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人中心";
        //定义tabBarItem的标题
        self.tabBarItem.title = NSLocalizedString(@"个人中心", @"个人中心");
        
        //定义tabBarItem的图标
        self.tabBarItem.image = [UIImage imageNamed:@"Icon_Profile1"];
        _tuichu = [UIButton buttonWithType:UIButtonTypeCustom];
        _tuichu.layer.cornerRadius = 5;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.bounces = NO;
    //添加导航栏
    [publicMethod addNavigationBar:self];
    //标题
    [publicMethod addTitleOnNavigationBar:self titleContent:@"个人中心"];
    //初始化appDele
    personapp = [publicMethod Add_appDelegate];
    

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"渐变2.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    //每次视图出现重新加载tableView,工程师跟用户显示的内如不同
    [self.tableView reloadData];
    if (personapp.loginuser  || personapp.loginengineer) {
//        [NSString stringWithFormat:@"%@AM.plist",[[publicMethod Add_appDelegate].myJID substringToIndex:[[publicMethod Add_appDelegate].myJID rangeOfString:@"@"].location]];
//        NSString *badgeValue = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@AM.plist",[[publicMethod Add_appDelegate].myJID substringToIndex:[[publicMethod Add_appDelegate].myJID rangeOfString:@"@"].location]] encoding:NSStringEncodingConversionAllowLossy error:nil];
        chatViewController *view = [[[publicMethod Add_appDelegate].tabBarController viewControllers]objectAtIndex:1];
        view.tabBarItem.badgeValue = nil;
//        NSString *badgeValue = [NSString stringWithContentsOfFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@AM.plist",[publicMethod Add_appDelegate].myJID]] encoding:NSStringEncodingConversionAllowLossy error:nil];
//        if ([badgeValue isEqualToString:@"0"]) {
//            view.tabBarItem.badgeValue = nil;
//        }else if(![badgeValue rangeOfString:@"-"].length){
//            view.tabBarItem.badgeValue = badgeValue;
//        }else{
//            view.tabBarItem.badgeValue = nil;
//        }
        
        self.buttonExit.hidden = NO;
    }else{
        self.buttonExit.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view data source

//2个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"                                                      关于软件";
    }
    return Nil;
}

//设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
        return 40;
}

//设置每个部分的头标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0){
        return 40;}
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    //没登入没有右箭头
    cell.accessoryType =  UITableViewCellSelectionStyleBlue;

    //設字體、顏色、背景色什麼的
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    //设置每行cell的textLabel字体和detailTextLabel的字体顏色
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];

    if (indexPath.section == 0) {
        switch (indexPath.row){
            case 0:{
                
                    NSString *str = [[NSString alloc]init];
                
                    if (personapp.loginuser!=nil) {
                        str = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,personapp.loginuser.portrait];
                        cell.detailTextLabel.text = personapp.loginuser.username;
                        [publicMethod connectOpenfire];
                    }
                    else if (personapp.loginengineer !=nil){
                        str = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,personapp.loginengineer.portrait];
                        cell.detailTextLabel.text = personapp.loginengineer.engineername;
                        [publicMethod connectOpenfire];
                    }
                    else{
                        cell.textLabel.text = @"";
                        cell.detailTextLabel.text = @"点击登录";
                        cell.accessoryType =  UITableViewCellSelectionStyleBlue;
                        cell.imageView.image =  [UIImage imageNamed:@"2432.png"];
                    }
                    NSMutableString *saveName=[NSMutableString stringWithString:@"head.png"];
                    NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",saveName,nil];
                    NSString *fullPath =[NSString pathWithComponents:segments];
                    NSFileManager *file=[NSFileManager defaultManager];
                    if([file fileExistsAtPath:fullPath isDirectory:NO]){
                        NSData *sandData=[NSData dataWithContentsOfFile:fullPath];
                        cell.imageView.image=[UIImage imageWithData:sandData];
                        
                    }
                    else{
                    NSString *str3 = [NSString stringWithFormat:@"%@",str];
                    NSURL *url = [NSURL URLWithString:str3];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    if (data!=nil) {
                            UIImage *image = [UIImage imageWithData:data];
                            cell.imageView.image = image;

                    }
                    else{
                            cell.imageView.image =  [UIImage imageNamed:@"2432.png"];
                    }
                    

                }
               [cell.imageView.layer setCornerRadius:48];
                cell.imageView.layer.masksToBounds=YES;
                cell.imageView.layer.borderWidth=2;
                cell.imageView.layer.borderColor=[[UIColor whiteColor]CGColor];
            }
            break;
         }
    }
    else if(indexPath.section == 1){
        switch (indexPath.row)
        {
            case 0:
                if (personapp.loginengineer!=nil) {
                    cell.textLabel.text = @"充值";
                    cell.detailTextLabel.text = personapp.loginengineer.money;
                }
                else{
                cell.textLabel.text = @"安全中心";
                cell.detailTextLabel.text = @"";
               
                }
                break;
            case 1:
                cell.textLabel.text = @"一键清理";
                break;
            case 2:
                cell.textLabel.text = @"软件介绍";
                break;
            case 3:
                cell.textLabel.text = @"联系我们";
                cell.detailTextLabel.text = @"0974-7272792";
                break;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一部分执行的操作
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                //普通用户跳到个人中心
                if (personapp.loginuser !=nil)
                {
                    message1ViewController *message1View = [[message1ViewController alloc]initWithNibName:@"message1ViewController" bundle:Nil];
                    [self.navigationController pushViewController:message1View animated:YES];
                    message1View.givenUser = personapp.loginuser;
                }
                //普通用户跳到个人中心
                else if (personapp.loginengineer !=nil)
                {
                    message2ViewController *message2View = [[message2ViewController alloc]initWithNibName:@"message2ViewController" bundle:Nil];
                    [self.navigationController pushViewController:message2View animated:YES];
                }
                //没有登入的时候才实现登入视图的跳转
                else
                {
                    loginViewController *loginView = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:Nil];
                    [self.navigationController pushViewController:loginView animated:YES];
                }

                break;

        }
    }
    else
    {
        switch (indexPath.row)
        {
                //清除缓存
            case 0:
            {
                if (personapp.loginuser !=nil)
                {
                    alterPasswordViewController *alterPasswordView = [[alterPasswordViewController alloc]initWithNibName:@"alterPasswordViewController" bundle:Nil];
                    [self.navigationController pushViewController:alterPasswordView animated:YES];
                }
                if (personapp.loginengineer !=nil) {
                    voucherViewController *voucherView = [[voucherViewController alloc]initWithNibName:@"voucherViewController" bundle:Nil];
                    [self.navigationController pushViewController:voucherView animated:YES];
                    
                }

            }
                break;
                //清除缓存
            case 1:
            {
                if (personapp.loginengineer!=nil||personapp.loginuser!=nil) {
                    UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已删除所有纪录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [elert1 show];

                }
            }
                break;
                //软件介绍
            case 2:
            {
                AppintroduceViewController *AppintroduceView = [[AppintroduceViewController alloc]initWithNibName:@"AppintroduceViewController" bundle:Nil];
                [self.navigationController pushViewController:AppintroduceView animated:YES];
            }
                break;
                //联系我们
            case 3:
            {
                UIWebView *callWebView=[[UIWebView alloc]init];
                if(!callWebView){
                    callWebView=[[UIWebView alloc]initWithFrame:CGRectZero];
                }
                NSString *str=[NSString stringWithFormat:@"tel:0797-7272792"];
                NSURL *url=[NSURL URLWithString:str];
                [callWebView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.view addSubview:callWebView];
            }
                break;
        }
    }
}

- (IBAction)exitlogin:(id)sender {
    UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要退出吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [elert1 show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
            NSFileManager* fileManager=[NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"login.plist"];
            [fileManager removeItemAtPath:uniquePath error:nil];
        if (personapp.loginengineer!=nil) {
            [[NSUserDefaults standardUserDefaults]setObject:personapp.loginengineer.password forKey:@"password"];
        }
        if (personapp.loginuser!=nil) {
            [[NSUserDefaults standardUserDefaults]setObject:personapp.loginuser.password forKey:@"password"];
        }
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"password"]);
        
            [[publicMethod Add_appDelegate] disconnect];
        
            personapp.loginengineer = nil;
            personapp.loginuser = nil;
            [self.tableView reloadData];
            [self viewWillAppear:YES];
        
            loginViewController *loginView = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:Nil];
        
            [self.navigationController pushViewController:loginView animated:YES];

            //刷新消息和预约
            [publicMethod Add_appDelegate].isRefreshOrder = YES;
            [publicMethod Add_appDelegate].isRefreshMessage = YES;
    }
}

@end
