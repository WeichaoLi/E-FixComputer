//
//  engineerDetailViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "engineerDetailViewController.h"
#import "engListViewController.h"
#import "ASIHTTPRequest.h"
#import "Engineer.h"
#import "Comment.h"
#import "CommentCell.h"
#import "Message.h"
#import "chitchatViewController.h"
#import "orderDetailViewController.h"
#import "SendOrderViewController.h"
#import "dailPhonevViewController.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "loginViewController.h"

@interface engineerDetailViewController (){
    UITableView *comentView;
    chitchatViewController *chitchat;
    SendOrderViewController *sendOrder;
    
    UILabel *lable_phone;
    UILabel *lable_address;
    UILabel *lable_distances;
    UITextView *textview;
    UIButton *button_HiddenComments;
    NSString *userLatitude;
    NSString *userLongitude;
}

#define IMAGE_WIDTH 100     //图宽
#define IMAGE_HEIGHT 100    //图高
#define LABLE_HEIGHT 30     //lable高
#define BUTTON_WIDTH 40     //按钮宽
#define BUTTON_HEIGHT 40    //按钮高
#define BUTTON_Y_POSITION 320       //按钮Y轴位置

@end

@implementation engineerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //添加导航栏
    [publicMethod addNavigationBar:self];
    [publicMethod addTitleOnNavigationBar:self titleContent:@""];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"工程师详情"];
    
    //左边的返回按钮
    [publicMethod addBackButton:self action:@selector(BacktoFormater)];
    NSString *strUTL = [NSString stringWithFormat:@"%@engineer/showEngineerInfo?id=%@",HOST,self.PassEng.engineerid];
    NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.requestList = [ASIHTTPRequest requestWithURL:url];
    self.requestList.delegate = self;
    [self.requestList startAsynchronous];
    self.requestList.tag = 1;
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *strUTL = [NSString stringWithFormat:@"%@comment/checkComment?engineer_id=%@",HOST,self.PassEng.engineerid];
    NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.requestList1 = [ASIHTTPRequest requestWithURL:url];
    self.requestList1.delegate = self;
    [self.requestList1 startAsynchronous];
    self.requestList1.tag = 2;
    self.commentList = [NSMutableArray array];
}

//请求成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    if (request.tag == 1) {
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary *dic in list) {
            self.PassEng.phone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"engineer_phone"]];
            self.PassEng.personDescription = [dic objectForKey:@"engineer_personDescription"];
            self.PassEng.address = [dic objectForKey:@"engineer_address"];
            self.PassEng.personDescription = [dic objectForKey:@"engineer_personDescription"];
            self.PassEng.longitude = [dic objectForKey:@"engineer_longitude"];
            self.PassEng.latitude = [dic objectForKey:@"engineer_latitude"];
   
            lable_phone.text = self.PassEng.phone;
            lable_address.text = self.PassEng.address;
        
            if ([self.PassEng.personDescription isEqualToString:@""]) {
                textview.text = @"他没有说什么";
            }else{
                textview.text = self.PassEng.personDescription;
            }
        }
    }
    if (request.tag == 2) {
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary *dic in list) {
            Comment *com = [[Comment alloc] init];
            
            com.name = [dic objectForKey:@"name"];
            com.content = [dic objectForKey:@"content"];
            com.date = [dic objectForKey:@"date"];
            
            [self.commentList addObject:com];
        }
        if ([self.commentList count]) {
            [myScrollerview addSubview:comentView];
            [myScrollerview setContentSize:CGSizeMake(0, 690)];
        }else{
            [myScrollerview setContentSize:CGSizeMake(0, 400)];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 370, 320, 40)];
            lable.textColor = [UIColor grayColor];
            lable.text = @"还没有被用户评论过";
            [myScrollerview addSubview:lable];
        }
        [comentView reloadData];
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    userLatitude = [NSString stringWithFormat:@"%.4f", coor.latitude];
    userLongitude = [NSString stringWithFormat:@"%.4f", coor.longitude];
}
    
    //计算工程师与用户距离
- (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1  longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    return [curLocation distanceFromLocation:otherLocation];
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[publicMethod Add_appDelegate] showAlertView:@"网络连接失败"];
}

- (void)viewWillAppear:(BOOL)animated{
    if (myScrollerview == nil) {
        //添加UIScrollView控件
        myScrollerview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, 320, 426)];
        myScrollerview.contentSize = CGSizeMake(320, 466);
        myScrollerview.bounces = NO;
        myScrollerview.delegate = self;
        
        //在滚动视图中加入image视图
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, IMAGE_WIDTH, IMAGE_HEIGHT)];
        imageView.image = [publicMethod GetImage:self.PassEng.portrait];
        [myScrollerview addSubview:imageView];
        
        //添加UILable控件：---------------------------------------------------------------
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(26, 301, 80, 40)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(142, 301, 80, 40)];
        UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(248, 301, 80, 40)];
        label1.text = @"发消息";
        label2.text = @"打电话";
        label3.text = @"下预约";
        label1.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        label1.font = [UIFont systemFontOfSize: 19.0];
        label2.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        label2.font = [UIFont systemFontOfSize: 19.0];
        label3.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        label3.font = [UIFont systemFontOfSize: 19.0];
        [myScrollerview addSubview:label1];
        [myScrollerview addSubview:label2];
        [myScrollerview addSubview:label3];
        
        UILabel *lable_name = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 90, LABLE_HEIGHT)];
        UILabel *lable_grade = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 50, LABLE_HEIGHT)];
        UILabel *lable_status = [[UILabel alloc]initWithFrame:CGRectMake(130, 40, 90, LABLE_HEIGHT)];
        UILabel *lable_distance = [[UILabel alloc]initWithFrame:CGRectMake(250, 40, 65, LABLE_HEIGHT)];
        UILabel *lable_some = [[UILabel alloc]initWithFrame:CGRectMake(210, 260, 65, LABLE_HEIGHT)];
        UILabel *lable_repairnumber = [[UILabel alloc]initWithFrame:CGRectMake(110  , 70, 170, LABLE_HEIGHT)];
        lable_phone = [[UILabel alloc]initWithFrame:CGRectMake(40, 230, 200, LABLE_HEIGHT)];
        UILabel *lable_lable2= [[UILabel alloc]initWithFrame:CGRectMake(4, 230, 40, LABLE_HEIGHT)];
        
        UILabel *lable_lable1= [[UILabel alloc]initWithFrame:CGRectMake(4, 210, 40, LABLE_HEIGHT)];
        lable_address = [[UILabel alloc]initWithFrame:CGRectMake(42, 195, 312, LABLE_HEIGHT*2)];
        
        UILabel *lable_person = [[UILabel alloc]initWithFrame:CGRectMake(4, 75, 100, 90)];
        textview = [[UITextView alloc]initWithFrame:CGRectMake(4,130, 312, 80)];
        
        //属性-----------------------------------------------------
        textview.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];
        textview.font = [UIFont systemFontOfSize:16];
        textview.bounces = NO;
        textview.editable = NO;
        textview.textColor = [UIColor grayColor];
        
        lable_address.numberOfLines = 2;
        
        //lable,textview内容
        lable_name.text = self.PassEng.engineername;
        lable_name.textColor = [UIColor blackColor];
        lable_name.font = [UIFont systemFontOfSize: 17.0];
        
        lable_grade.text = [NSString stringWithFormat:@"%@分",self.PassEng.grade];
        lable_grade.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        lable_grade.font = [UIFont systemFontOfSize: 19.0];
        
        if ([self.PassEng.status isEqualToString:@"1"]) {
            lable_status.text = @"";
            lable_status.textColor = [UIColor redColor];
        }else{
            lable_status.text = @"";
            lable_status.textColor = [UIColor grayColor];
        }
        
        lable_distance.text = self.PassEng.distance;
        lable_distance.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        lable_distance.font = [UIFont systemFontOfSize: 14.0];
        
        lable_repairnumber.text = [NSString stringWithFormat:@"修理次数：%@",self.PassEng.repairnumber];
        lable_repairnumber.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        lable_repairnumber.font = [UIFont systemFontOfSize: 15.0];

        lable_some.text = @"一个电话,上门服务";
        lable_some.textColor = [[UIColor alloc]initWithRed:217/255.0 green:104/255.0 blue:49/255.0 alpha:1.0];
        lable_some.font = [UIFont systemFontOfSize: 16.0];
        lable_lable2.text = @"手机:";
        lable_lable2.textColor = [[UIColor alloc]initWithRed:217/255.0 green:104/255.0 blue:49/255.0 alpha:1.0];
        lable_lable2.font = [UIFont systemFontOfSize: 16.0];
        lable_phone.text = @"加载中...";
        lable_phone.textColor = [[UIColor alloc]initWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        
        lable_phone.font = [UIFont systemFontOfSize: 14.0];
        lable_lable1.text = @"地址:";
        lable_lable1.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        lable_lable1.font = [UIFont systemFontOfSize: 16.0];
        lable_address.text = @"加载中...";
        lable_address.textColor = [[UIColor alloc]initWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        lable_address.font = [UIFont systemFontOfSize: 14.0];
        lable_person.text = @"个人说明:";
        lable_person.textColor = [[UIColor alloc]initWithRed:217.0/255.0 green:104/255.0 blue:49.0/255.0 alpha:1.0];
        lable_person.font = [UIFont systemFontOfSize: 16.0];
        textview.text = @"加载中...";
        textview.textColor = [[UIColor alloc]initWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        textview.font = [UIFont systemFontOfSize: 14.0];
        //-------------------添加按钮-------------------//
        //打电话
        UIButton *button_Call = [UIButton buttonWithType:UIButtonTypeCustom];
        button_Call.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"call.png"]];
        [button_Call setFrame:CGRectMake(145, 260, BUTTON_WIDTH+8, BUTTON_HEIGHT+8)];
        [button_Call addTarget:self action:@selector(CallEngineer) forControlEvents:UIControlEventTouchDown];
        
        //开始聊天
        UIButton *button_StartChat = [UIButton buttonWithType:UIButtonTypeCustom];
        button_StartChat.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat2.png"]];
        [button_StartChat setFrame:CGRectMake(30, BUTTON_Y_POSITION-60, BUTTON_WIDTH+8, BUTTON_HEIGHT+8)];
        [button_StartChat addTarget:self action:@selector(StartChat) forControlEvents:UIControlEventTouchDown];
        
        UIButton *button_SendOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        button_SendOrder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"conversation.png"]];
        [button_SendOrder setFrame:CGRectMake(250, BUTTON_Y_POSITION-60, BUTTON_WIDTH+8, BUTTON_HEIGHT+8)];
        [button_SendOrder addTarget:self action:@selector(SendOrder) forControlEvents:UIControlEventTouchDown];
        
        // 查看评论
        button_HiddenComments = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_HiddenComments setTitle:@"评论列表" forState:UIControlStateNormal];
        button_HiddenComments.backgroundColor = [UIColor grayColor];
        button_HiddenComments.titleLabel.textColor = [UIColor greenColor];
        [button_HiddenComments setFrame:CGRectMake(0, BUTTON_Y_POSITION+16, 320, BUTTON_HEIGHT-20)];
        
        // 添加评论列表
        comentView = [[UITableView alloc]initWithFrame:CGRectMake(0, 365, 320, 325) style:UITableViewStylePlain];
        [comentView setDelegate:self];
        comentView.backgroundColor = [UIColor whiteColor];
        comentView.bounces = NO;
        [comentView setDataSource:self];
        
        //把所有控件加入到滚动视图
        [myScrollerview addSubview:lable_name];
        [myScrollerview addSubview:lable_grade];
        [myScrollerview addSubview:lable_status];
        [myScrollerview addSubview:lable_distance];
        [myScrollerview addSubview:lable_repairnumber];
        [myScrollerview addSubview:lable_lable2];
        [myScrollerview addSubview:lable_phone];
        [myScrollerview addSubview:lable_lable1];
        [myScrollerview addSubview:lable_address];
        [myScrollerview addSubview:lable_person];
        [myScrollerview addSubview:textview];
        
        [myScrollerview addSubview:button_Call];
        [myScrollerview addSubview:button_StartChat];
        [myScrollerview addSubview:button_SendOrder];
        [myScrollerview addSubview:button_HiddenComments];
        
        //把滚动视图添加到主视图
        [self.view addSubview:myScrollerview];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.commentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *com = [self.commentList objectAtIndex:indexPath.row];
    CGRect labelsize = [com.content boundingRectWithSize:CGSizeMake(290, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:Nil];
    
    return labelsize.size.height+60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Comment *com = [self.commentList objectAtIndex:indexPath.row];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        UILabel *lablename = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 100, 32)];
        lablename.font = [UIFont systemFontOfSize: 14.0];
        lablename.tag = 2;
        [[cell contentView]addSubview:lablename];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(187, 7, 128, 28)];
        date.font = [UIFont systemFontOfSize: 12.0];
        date.textColor = [UIColor grayColor];
        date.tag = 3;
        [[cell contentView]addSubview:date];
        
        CGRect labelsize = [com.content boundingRectWithSize:CGSizeMake(290, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:Nil];
        UILabel *lablecon = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 290, labelsize.size.height+20)];
        lablecon.textColor = [UIColor grayColor];
        lablecon.tag = 1;
        lablecon.numberOfLines = 0;
        lablecon.lineBreakMode = NSLineBreakByWordWrapping;
        lablecon.font = [UIFont systemFontOfSize: 13.0];
        [[cell contentView]addSubview:lablecon];
        
        UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        portrait.image = [UIImage imageNamed:@"head.png"];
        [[cell contentView] addSubview:portrait];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *content = (UILabel*)[cell viewWithTag:1];
    //    content.numberOfLines = 1+[com.content length]/23;
    content.text = com.content;
    
    UILabel *name = (UILabel*)[cell viewWithTag:2];
    name.text = com.name;
    
    UILabel *date = (UILabel*)[cell viewWithTag:3];
    date.text = com.date;
    
    return cell;
}

//返回按钮的方法
- (void)BacktoFormater{
    if ([self.rootViewController isKindOfClass:[engListViewController class]]||[self.rootViewController isKindOfClass:[engListViewController class]]) {
        [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//开始聊天
- (void)StartChat{
    if (![[publicMethod Add_appDelegate].loginengineer.engineerid isEqualToString:self.PassEng.engineerid]) {
        if([publicMethod Add_appDelegate].loginuser != nil || [publicMethod Add_appDelegate].loginengineer != nil){
            //        if (chitchat == nil) {
            chitchat = [[chitchatViewController alloc]initWithNibName:@"chitchatViewController" bundle:nil];
            //        }
            chitchat.passmessage = [[Message alloc]init];
            chitchat.passmessage.id = [NSString stringWithFormat:@"0_%@",self.PassEng.engineerid];
            chitchat.passmessage.name = self.PassEng.engineername;
            chitchat.passmessage.portrait = self.PassEng.portrait;
            
            [self.navigationController pushViewController:chitchat animated:NO];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView setTag:2];
            [alertView show];
        }
    }
}

//打电话的按钮
- (void)CallEngineer{
//    dailPhonevViewController *dailview = [[dailPhonevViewController alloc] initWithNibName:@"dailPhonevViewController" bundle:nil];
//    dailview.phonenumber = self.PassEng.phone;
//    [self.navigationController pushViewController:dailview animated:NO];
    UIWebView *callWebView=[[UIWebView alloc]init];
    if(!callWebView){
        callWebView=[[UIWebView alloc]initWithFrame:CGRectZero];
    }
    NSString *str=[NSString stringWithFormat:@"tel:%@",self.PassEng.phone];
    NSURL *url=[NSURL URLWithString:str];
    [callWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:callWebView];

}

//发送预约
- (void)SendOrder{
    if (![[publicMethod Add_appDelegate].loginengineer.engineerid isEqualToString:self.PassEng.engineerid]) {
        if ([publicMethod Add_appDelegate].loginuser || [publicMethod Add_appDelegate].loginengineer) {
            if (sendOrder == nil) {
                sendOrder = [[SendOrderViewController alloc] initWithNibName:@"SendOrderViewController" bundle:nil];
            }
            sendOrder.PassObject = self.PassEng;
            [self.navigationController pushViewController:sendOrder animated:YES];
        }else{
//            [[publicMethod Add_appDelegate] showAlertView:@"请先登陆"];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView setTag:1];
            [alertView show];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==1||alertView.tag == 2) {
        if (buttonIndex == 0) {
            loginViewController *loginView = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:Nil];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
