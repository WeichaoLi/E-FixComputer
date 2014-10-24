//
//  orderDetailViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "orderDetailViewController.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "Order.h"
#import "engineerDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "orderViewController.h"
#import "commentViewController.h"

@interface orderDetailViewController (){
    engineerDetailViewController *engineerdetail;
    orderViewController *orderview;
    commentViewController *commentview;
    
    UIButton *ButtonReceive;
    UIButton *ButtonRefuse;
    UIButton *ButtonEnsure;
    UIButton *ButtonComment;
    UIButton *ButtonCancel;
    
    UIAlertView *alert;
    NSTimer *timer;
    NSString *sign;
}

@end

@implementation orderDetailViewController

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
    // Do any additional setup after loading the view from its nib.
    //添加导航栏
    [publicMethod addNavigationBar:self];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"预约详情"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4444.jpeg"]];
    //左边的返回按钮
    [publicMethod addBackButton:self action:@selector(BacktoFormater)];
//    [publicMethod addRightButton:self backGroundimage:[UIImage imageNamed:@"checkinfo.png"] action:@selector(checkTheInfo)];
    
    self.textSendor.editable = NO;
    self.textAddress.editable = NO;
    self.textContent.editable = NO;
    self.textappointdate.editable = NO;
    self.textAddress.bounces = NO;
    self.textappointdate.bounces = NO;
    self.textContent.bounces = NO;
    self.textSendor.bounces = NO;
    
    if ([self.passOrder.sendstatus isEqualToString:@"0"]) {
        // 未接受的预约
        if (!self.passOrder.receiveid) {
            ButtonReceive = [UIButton buttonWithType:UIButtonTypeCustom];
            [ButtonReceive setFrame:CGRectMake(0, 440, 160, 40)];
            ButtonReceive.backgroundColor = [UIColor grayColor];
            [ButtonReceive setTitle:@"接受" forState:UIControlStateNormal];
            [ButtonReceive addTarget:self action:@selector(AcceptOrder) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:ButtonReceive];
            
            ButtonRefuse = [UIButton buttonWithType:UIButtonTypeCustom];
            [ButtonRefuse setFrame:CGRectMake(161, 440, 160, 40)];
            ButtonRefuse.backgroundColor = [UIColor grayColor];
            [ButtonRefuse setTitle:@"拒绝" forState:UIControlStateNormal];
            [ButtonRefuse addTarget:self action:@selector(RefuseOrder) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:ButtonRefuse];
        }else{
            ButtonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
            [ButtonCancel setFrame:CGRectMake(0, 440, 320, 40)];
            ButtonCancel.backgroundColor = [UIColor grayColor];
            [ButtonCancel setTitle:@"取消" forState:UIControlStateNormal];
//            if ([self.passOrder.receivestatus isEqualToString:@"0"]) {
//                [ButtonCancel setTitle:@"取消" forState:UIControlStateNormal];
//            }else{
//                [ButtonCancel setTitle:@"重新发送" forState:UIControlStateNormal];
//            }
            [ButtonCancel addTarget:self action:@selector(CancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:ButtonCancel];
        }
    }else if ([self.passOrder.sendstatus isEqualToString:@"1"]){
        //已处理的预约
        if (self.passOrder.receivestatus == nil) {
            ButtonEnsure = [UIButton buttonWithType:UIButtonTypeCustom];
            [ButtonEnsure setFrame:CGRectMake(0, 440, 320, 40)];
            ButtonEnsure.backgroundColor = [UIColor grayColor];
            [ButtonEnsure setTitle:@"确认完成" forState:UIControlStateNormal];
            [ButtonEnsure addTarget:self action:@selector(ensurecomplete) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:ButtonEnsure];
        }
    }else{
        //已完成的预约
        ButtonComment = [UIButton buttonWithType:UIButtonTypeCustom];
        [ButtonComment setFrame:CGRectMake(65, 400, 220, 40)];
        ButtonComment.backgroundColor = [UIColor grayColor];
        if (self.passOrder.receiveid) {
            [ButtonComment setTitle:@"评论他" forState:UIControlStateNormal];
            ButtonComment.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
            ButtonComment.layer.cornerRadius = 5;
            
        }else{
            [ButtonComment setTitle:@"查看评论" forState:UIControlStateNormal];
        }
        [ButtonComment addTarget:self action:@selector(startComment) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ButtonComment];
    }
}

//返回按钮执行事件
- (void)BacktoFormater{
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
    orderview = (orderViewController*)self.rootviewcontroller;
    if ([sign isEqualToString:@"1"]) {
        orderview.isreload = YES;
        orderview.segentedControl.selectedSegmentIndex = 1;
        [orderview segmentAction];
    }else if([sign isEqualToString:@"2"]){
        orderview.isreload = YES;
        orderview.segentedControl.selectedSegmentIndex = 2;
        [orderview segmentAction];
    }
    if ([sign isEqualToString:@"-1"]) {
        orderview.IsWait = YES;
        [orderview segmentAction];
    }
    [self.navigationController popToViewController:orderview animated:YES];
}

//获取工程师信息
- (Engineer*)gainEngineerInfo:(NSString*)id{
    NSString *strurl = [NSString stringWithFormat:@"%@engineer/showoneinfo?id=%@",HOST,id];
    NSURL *url = [NSURL URLWithString:strurl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startSynchronous];
    NSData *data = [request responseData];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSDictionary *dic = list[0];
    Engineer *eng = [[Engineer alloc]init];
    
    if(self.passOrder.receiveid){
        eng.engineerid = self.passOrder.receiveid;
    }else{
        eng.engineerid = self.passOrder.engineerid;
    }
    eng.engineername = [dic objectForKey:@"engineer_name"];
    eng.status = [dic objectForKey:@"engineer_status"];
    eng.portrait = [dic objectForKey:@"engineer_portrait"];
    eng.repairnumber = [dic objectForKey:@"engineer_repairnumber"];
    eng.grade = [dic objectForKey:@"engineer_grade"];
    eng.longitude = [dic objectForKey:@"engineer_longitude"];
    eng.latitude = [dic objectForKey:@"engineer_latitude"];
    
    return eng;
}

- (void)checkTheInfo{
    if (self.passOrder.receiveid) {
        if (engineerdetail == nil) {
            engineerdetail = [[engineerDetailViewController alloc] initWithNibName:@"engineerDetailViewController" bundle:nil];
        }
        engineerdetail.PassEng = [self gainEngineerInfo:self.passOrder.receiveid];
        
        [self.navigationController pushViewController:engineerdetail animated:YES];
    }else{
        if (engineerdetail == nil) {
        engineerdetail = [[engineerDetailViewController alloc] initWithNibName:@"engineerDetailViewController" bundle:nil];
        }
        engineerdetail.PassEng = [self gainEngineerInfo:self.passOrder.engineerid];
        
        [self.navigationController pushViewController:engineerdetail animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        self.objectName.text = @"收件人";
        self.textSendor.text = self.passOrder.name;
    }else{
        if (self.passOrder.receiveid == nil) {
            self.objectName.text = @"发件人";
            self.textSendor.text = self.passOrder.name;
        }else{
            self.objectName.text = @"收件人";
            self.textSendor.text = self.passOrder.name;
        }
    }
    self.textContent.text = self.passOrder.content;
    self.textAddress.text = self.passOrder.address;
    self.textappointdate.text = [self.passOrder.appointdate substringToIndex:16];
}

#pragma -----------------------button method-------------------------

//接受预约
- (void)AcceptOrder{
    NSString *stringURL = [NSString stringWithFormat:@"%@order/changeOrderStatus?order_id=%@",HOST,self.passOrder.id];
    NSURL *url = [NSURL URLWithString:stringURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:self.passOrder.userid forKey:@"userid"];
    [request setPostValue:self.passOrder.engineerid forKey:@"engineerid"];
    [request setPostValue:@"1" forKey:@"sendstatus"];
    [request setPostValue:@"1" forKey:@"receivestatus"];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    
    NSString *result = [request responseString];
    if ([result rangeOfString:@"notExist"].length) {
        [self showAlertview:@"预约不存在"];
        timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
        sign = @"-1";
        [self BacktoFormater];
    }else{
        if ([result rangeOfString:@"success"].length) {
            [ButtonReceive removeFromSuperview];
            [ButtonRefuse removeFromSuperview];
            [self showAlertview:@"接受成功"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
            self.passOrder.sendstatus = @"1";
            self.passOrder.receivestatus = @"1";
            sign = @"1";
            [self BacktoFormater];
//            [self viewDidLoad];
        }else{
            [self showAlertview:@"接受失败"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
        }
    }
}

//拒绝预约
- (void)RefuseOrder{
    NSString *stringURL = [NSString stringWithFormat:@"%@order/changeOrderStatus?order_id=%@",HOST,self.passOrder.id];
    NSURL *url = [NSURL URLWithString:stringURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:self.passOrder.userid forKey:@"userid"];
    [request setPostValue:self.passOrder.engineerid forKey:@"engineerid"];
    [request setPostValue:@"1" forKey:@"sendstatus"];
    [request setPostValue:@"-1" forKey:@"receivestatus"];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    
    NSString *result = [request responseString];
    if ([result rangeOfString:@"notExist"].length) {
        alert = [[UIAlertView alloc] initWithTitle:Nil message:@"预约不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        sign = @"-1";
        [self BacktoFormater];
    }else{
        if ([result rangeOfString:@"success"].length) {
            [self showAlertview:@"拒绝成功"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
            self.passOrder.sendstatus = @"1";
            self.passOrder.receivestatus = @"-1";
            sign = @"-1";
            [self BacktoFormater];
//            [self viewDidLoad];
        }else{
            [self showAlertview:@"拒绝失败"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
        }
    }
}

//取消预约
- (void)CancelOrder:(id)sender{
//    NSString *stringURL = [NSString stringWithFormat:@"%@order/cancelOrder?orderid=%@",HOST,self.passOrder.id];
//    NSURL *url = [NSURL URLWithString:stringURL];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    if ([self.passOrder.receivestatus isEqualToString:@"0"]) {
//        [request setPostValue:@"" forKey:@"receivestatus"];
//    }else{
//        [request setPostValue:@"0" forKey:@"receivestatus"];
//    }
//     [request setRequestMethod:@"POST"];
//    [request startSynchronous];
    
//    NSString *result = [request responseString];
//    if ([result rangeOfString:@"success"].length) {
//        [ButtonCancel removeFromSuperview];
//        if ([self.passOrder.receivestatus isEqualToString:@"0"]) {
//            [self showAlertview:@"取消成功"];
//            self.passOrder.receivestatus = @"";
//        }else{
//            [self showAlertview:@"发送成功"];
//            self.passOrder.receivestatus = @"0";
//        }
//        timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
//        sign = @"-1";
//        [self viewDidLoad];
//    }else{
//        if ([self.passOrder.receivestatus isEqualToString:@"0"]) {
//            [self showAlertview:@"取消失败"];
//        }else{
//            [self showAlertview:@"发送失败"];
//        }
//        timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
//    }
    NSString *stringURL = [NSString stringWithFormat:@"%@order/deleteorder?orderid=%@",HOST,self.passOrder.id];
    NSURL *url = [NSURL URLWithString:stringURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSString *result = [request responseString];
    if ([result rangeOfString:@"1"].length) {
        sign = @"-1";
        [self BacktoFormater];
    }else{
        [self showAlertview:@"取消失败"];
        timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
    }
}

- (void)ensurecomplete{
    NSString *stringURL = [NSString stringWithFormat:@"%@order/changeOrderStatus?order_id=%@",HOST,self.passOrder.id];
    NSURL *url = [NSURL URLWithString:stringURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:self.passOrder.userid forKey:@"userid"];
    [request setPostValue:self.passOrder.engineerid forKey:@"engineerid"];
    [request setPostValue:[publicMethod Add_appDelegate].loginengineer.engineerid forKey:@"id"];
    NSLog(@"%d",[publicMethod Add_appDelegate].loginengineer.repairnumber.intValue);
    [request setPostValue:[NSString stringWithFormat:@"%d",[publicMethod Add_appDelegate].loginengineer.repairnumber.intValue+1] forKey:@"repairnumber"];
    [request setPostValue:@"2" forKey:@"sendstatus"];
    [request setPostValue:@"2" forKey:@"receivestatus"];
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    
    NSString *result = [request responseString];
    if ([result rangeOfString:@"notExist"].length) {
        alert = [[UIAlertView alloc] initWithTitle:Nil message:@"预约不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        if ([result rangeOfString:@"success"].length) {
            [self showAlertview:@"确认成功"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
            self.passOrder.sendstatus = @"2";
            self.passOrder.receivestatus = @"2";
            sign = @"2";
            [self BacktoFormater];
//            [self viewDidLoad];
        }else{
            [self showAlertview:@"确认失败"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
        }
    }
}

- (void)startComment{
    commentview = [[commentViewController alloc]initWithNibName:@"commentViewController" bundle:nil];
    commentview.order = self.passOrder;
    [self.navigationController pushViewController:commentview animated:YES];
}

- (void)showAlertview:(NSString*)message{
    alert = [[UIAlertView alloc] initWithTitle:Nil message:message delegate:self cancelButtonTitle:Nil otherButtonTitles: nil];
    [alert show];
}

- (void)hiddenAlert{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
