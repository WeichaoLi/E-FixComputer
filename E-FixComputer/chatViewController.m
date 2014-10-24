//
//  chatViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "chatViewController.h"
#import "publicMethod.h"
#import "WaitOrderCell.h"
#import "ASIHTTPRequest.h"
#import "User.h"
#import "talk.h"
#import "ToolKit.h"
#import "Engineer.h"
#import "Message.h"
#import "CustomBadge.h"
#import "WaitOrderCell.h"
#import "chitchatViewController.h"

@interface chatViewController (){
    NSString *myjid;
}

@end

@implementation chatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //定义tabBarItem的标题
        self.tabBarItem.title = NSLocalizedString(@"消息", @"消息");
        
        //定义tabBarItem的图标
        self.tabBarItem.image = [UIImage imageNamed:@"Icon_Activity"];
    }
    return self;
}

- (void)loadData{
    
    myjid = [[publicMethod Add_appDelegate].myJID substringToIndex:[[publicMethod Add_appDelegate].myJID rangeOfString:@"@"].location];
    NSLog(@"联系人界面－－－我的ID：%@",myjid);
    
//    if ([publicMethod Add_appDelegate].loginuser != nil){
//        self.messageList = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
//    }else{
//        self.messageList = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
//    }
    self.messageList = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@messList.plist",myjid]]];
    if (self.messageList == nil) {
        self.messageList = [NSMutableArray array];
    }
    [self.mytableview reloadData];
    if ([[publicMethod Add_appDelegate].chatArray count]){
        for (talk *atalk in [publicMethod Add_appDelegate].chatArray) {
            [self refreshList:atalk];
        }
        if ([publicMethod Add_appDelegate].loginuser != nil){
            [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@unread.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
        }else{
            [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@unread.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加导航栏，返回按钮，标题
    [publicMethod addNavigationBar:self];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"消息"];
    
    [self loadData];
    
    self.mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 54, 320, 376) style:UITableViewStyleGrouped];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    [self.view addSubview:self.mytableview];
    
    _PullDownRefreshView = [[EGORefreshTableHeaderView alloc] initWithScrollView:self.mytableview orientation:EGOPullOrientationDown];
    _PullDownRefreshView.delegate = self;
    
    CGSize size = self.mytableview.frame.size;
    size.height +=1;
    self.mytableview.contentSize = size;
    [_PullDownRefreshView adjustPosition];
    
    [publicMethod Add_appDelegate].isRefreshMessage = NO;
}

-(void)newMsgCome:(NSNotification *)notifacation{
    NSLog(@"联系人界面----------新消息----------------------");
    talk *atalk = [publicMethod Add_appDelegate].chatArray.lastObject;
    [self refreshList:atalk];
    [publicMethod Add_appDelegate].chatArray = [NSMutableArray array];
    if ([publicMethod Add_appDelegate].loginuser != nil){
        [NSKeyedArchiver archiveRootObject:[publicMethod Add_appDelegate].chatArray toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@unread.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
    }else{
        [NSKeyedArchiver archiveRootObject:[publicMethod Add_appDelegate].chatArray toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@unread.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
    }
}

- (void)saveChatDataFrom:(NSString*)fromname To:(NSString*)toname with:(talk*)atalk{
    NSLog(@"已保存聊天纪录");
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@|%@data.plist",fromname,toname]]];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    [array addObject:atalk];
    
    [NSKeyedArchiver archiveRootObject:array toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@|%@data.plist",fromname,toname]]];
}

- (BOOL)refreshList:(talk*)atalk{
    if ([atalk.fromName isEqualToString:[publicMethod Add_appDelegate].myJID]) {
        int i = 0;
        for (Message *mess in self.messageList) {
            if ([mess.id isEqualToString:[atalk.toName substringToIndex:[atalk.toName rangeOfString:@"@"].location]]) {
                mess.content = atalk.content;
                mess.amount = 0;
                mess.date = atalk.date;
                [self.messageList replaceObjectAtIndex:i withObject:mess];
                if ([publicMethod Add_appDelegate].loginuser != nil){
                    [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
                }else{
                    [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
                }
                [self.mytableview reloadData];
                return YES;
            }
            i++;
        }
        NSArray *arr = [[atalk.toName substringToIndex:[atalk.toName rangeOfString:@"@"].location] componentsSeparatedByString:@"_"];
        
        if ([arr[0] isEqualToString:@"0"]) {
            NSString *strUTL = [NSString stringWithFormat:@"%@engineer/messEngineer?id=%@",HOST,arr[1]];
            NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request startSynchronous];
            NSData *data = [request responseData];
            NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            for (NSDictionary *dic in list) {
                Message *mess = [[Message alloc] init];
                
                mess.id = [atalk.toName substringToIndex:[atalk.toName rangeOfString:@"@"].location];
                mess.name = [dic objectForKey:@"engineer_name"];
                mess.portrait = [dic objectForKey:@"engineer_portrait"];
                mess.amount = 0;
                mess.content = atalk.content;
                mess.date = atalk.date;
                
                [self.messageList addObject:mess];
            }
            if ([publicMethod Add_appDelegate].loginuser != nil){
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
            }else{
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
            }
            
        }else{
            NSString *strUTL = [NSString stringWithFormat:@"%@user/messuser?id=%@",HOST,arr[1]];
            NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request startSynchronous];
            NSData *data = [request responseData];
            NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            for (NSDictionary *dic in list) {
                Message *mess = [[Message alloc] init];
                
                mess.id = [atalk.toName substringToIndex:[atalk.toName rangeOfString:@"@"].location];
                mess.name = [dic objectForKey:@"user_name"];
                mess.portrait = [dic objectForKey:@"user_portrait"];
                mess.amount = 0;
                mess.content = atalk.content;
                mess.date = atalk.date;
                
                [self.messageList addObject:mess];
            }
            if ([publicMethod Add_appDelegate].loginuser != nil){
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
            }else{
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
            }
        }
        [self.mytableview reloadData];
        if ([publicMethod Add_appDelegate].loginuser != nil){
            [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@unread.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
        }else{
            [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@unread.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
        }
        return YES;
        
    }else if(atalk.fromName){
        [self saveChatDataFrom:[atalk.fromName substringToIndex:[atalk.fromName rangeOfString:@"@"].location] To:[atalk.toName substringToIndex:[atalk.toName rangeOfString:@"@"].location] with:atalk];
    }else{
        return YES;
    }
//    return [self commonMethod:atalk.fromName :atalk distinction:1];
    /////
    ////
    int i = 0;
    for (Message *mess in self.messageList) {
        if ([mess.id isEqualToString:[atalk.fromName substringToIndex:[atalk.fromName rangeOfString:@"@"].location]]) {
            mess.content = atalk.content;
            mess.amount +=1;
            mess.date = atalk.date;
            [self.messageList replaceObjectAtIndex:i withObject:mess];
            if ([publicMethod Add_appDelegate].loginuser != nil){
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
            }else{
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
            }
            [self.mytableview reloadData];
            
            return YES;
        }
        i++;
    }
    NSArray *arr = [[atalk.fromName substringToIndex:[atalk.fromName rangeOfString:@"@"].location] componentsSeparatedByString:@"_"];
    
    if ([arr[0] isEqualToString:@"0"]) {
        NSString *strUTL = [NSString stringWithFormat:@"%@engineer/messEngineer?id=%@",HOST,arr[1]];
        NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in list) {
            Message *mess = [[Message alloc] init];
            
            mess.id = [atalk.fromName substringToIndex:[atalk.fromName rangeOfString:@"@"].location];
            mess.name = [dic objectForKey:@"engineer_name"];
            mess.portrait = [dic objectForKey:@"engineer_portrait"];
            mess.amount = 1;
            mess.content = atalk.content;
            mess.date = atalk.date;
            
            [self.messageList addObject:mess];
        }
        if ([publicMethod Add_appDelegate].loginuser != nil){
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
        }else{
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
        }
        
    }else{
        NSString *strUTL = [NSString stringWithFormat:@"%@user/messuser?id=%@",HOST,arr[1]];
        NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in list) {
            Message *mess = [[Message alloc] init];
            
            mess.id = [atalk.fromName substringToIndex:[atalk.fromName rangeOfString:@"@"].location];
            mess.name = [dic objectForKey:@"user_name"];
            mess.portrait = [dic objectForKey:@"user_portrait"];
            mess.amount = 1;
            mess.content = atalk.content;
            mess.date = atalk.date;
            
            [self.messageList addObject:mess];
        }
        if ([publicMethod Add_appDelegate].loginuser != nil){
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
        }else{
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
        }
    }
    [self.mytableview reloadData];
    if ([publicMethod Add_appDelegate].loginuser != nil){
        [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@unread.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
    }else{
        [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@unread.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
    }
    return YES;
}

- (BOOL)commonMethod:(NSString*)name :(talk*)atalk distinction:(int)k{
    int i = 0;
    for (Message *mess in self.messageList) {
        if ([mess.id isEqualToString:[name substringToIndex:[name rangeOfString:@"@"].location]]) {
            mess.content = atalk.content;
            mess.amount +=k;
            mess.date = atalk.date;
            [self.messageList replaceObjectAtIndex:i withObject:mess];
            if ([publicMethod Add_appDelegate].loginuser != nil){
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
            }else{
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
            }
            [self.mytableview reloadData];
            
            return YES;
        }
        i++;
    }
    NSArray *arr = [[name substringToIndex:[name rangeOfString:@"@"].location] componentsSeparatedByString:@"_"];
    
    if ([arr[0] isEqualToString:@"0"]) {
        NSString *strUTL = [NSString stringWithFormat:@"%@engineer/messEngineer?id=%@",HOST,arr[1]];
        NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in list) {
            Message *mess = [[Message alloc] init];
            
            mess.id = [name substringToIndex:[name rangeOfString:@"@"].location];
            mess.name = [dic objectForKey:@"engineer_name"];
            mess.portrait = [dic objectForKey:@"engineer_portrait"];
            mess.amount = k;
            mess.content = atalk.content;
            mess.date = atalk.date;
            
            [self.messageList addObject:mess];
        }
        if ([publicMethod Add_appDelegate].loginuser != nil){
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
        }else{
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
        }
        
    }else{
        NSString *strUTL = [NSString stringWithFormat:@"%@user/messuser?id=%@",HOST,arr[1]];
        NSURL *url = [NSURL URLWithString:[strUTL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in list) {
            Message *mess = [[Message alloc] init];
            
            mess.id = [name substringToIndex:[name rangeOfString:@"@"].location];
            mess.name = [dic objectForKey:@"user_name"];
            mess.portrait = [dic objectForKey:@"user_portrait"];
            mess.amount = k;
            mess.content = atalk.content;
            mess.date = atalk.date;
            
            [self.messageList addObject:mess];
        }
        if ([publicMethod Add_appDelegate].loginuser != nil){
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
        }else{
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
        }
    }
    [self.mytableview reloadData];
    if ([publicMethod Add_appDelegate].loginuser != nil){
        [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@unread.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
    }else{
        [NSKeyedArchiver archiveRootObject:nil toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@unread.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
    }
    return YES;
}

- (void)refresh:(ASIHTTPRequest*)request{
    talk *atalk = [publicMethod Add_appDelegate].chatArray.lastObject;
    NSData *data = [request responseData];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dic in list) {
        Message *mess = [[Message alloc] init];
        
        mess.id = [atalk.fromName substringToIndex:[atalk.fromName rangeOfString:@"@"].location];
        mess.name = [dic objectForKey:@"engineer_name"];
        mess.portrait = [dic objectForKey:@"engineer_portrait"];
        mess.amount = 1;
        mess.content = atalk.content;
        mess.date = atalk.date;
        
        [self.messageList addObject:mess];
    }
    if ([publicMethod Add_appDelegate].loginuser != nil){
        [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
    }else{
        [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
    }
    [self.mytableview reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"数据请求失败");
}

- (void)viewWillAppear:(BOOL)animated{
    if (![publicMethod isConnectionAvailable]) {
        [[publicMethod Add_appDelegate] showAlertView:@"请检查网络"];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:@"newMessage" object:nil];
    if([publicMethod Add_appDelegate].loginuser != nil || [publicMethod Add_appDelegate].loginengineer != nil){
        [publicMethod connectOpenfire];
        
        self.tabBarItem.badgeValue = nil;
        [self.tabBarItem.badgeValue writeToFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@AM.plist",[[publicMethod Add_appDelegate].myJID substringToIndex:[[publicMethod Add_appDelegate].myJID rangeOfString:@"@"].location]]] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
//    //刷新联系人列表
//    if ([publicMethod Add_appDelegate].isRefreshMessage) {
        [self loadData];
//        [publicMethod Add_appDelegate].isRefreshMessage = NO;
//    }
}

#pragma table view datasource

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([publicMethod Add_appDelegate].loginuser != nil || [publicMethod Add_appDelegate].loginengineer != nil) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.messageList count]) {
        return [self.messageList count];
    }else{
        self.tabBarItem.badgeValue = nil;
        [self.tabBarItem.badgeValue writeToFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@AM.plist",[[publicMethod Add_appDelegate].myJID substringToIndex:[[publicMethod Add_appDelegate].myJID rangeOfString:@"@"].location]]] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.messageList == nil) {
        static NSString *simpleTable = @"simpleCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTable];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTable];
        }
        cell.textLabel.text = @"";
        return cell;
    }else{
        if ([self.messageList count]) {
            static NSString *CellIdentifier = @"Cell";
            WaitOrderCell *cell;
            if (cell == nil) {
                UINib *nib = [UINib nibWithNibName:@"WaitOrderCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            }
            cell = (WaitOrderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            Message *mess = [self.messageList objectAtIndex:[self.messageList count]-indexPath.row-1];
            
            cell.lableName.text = mess.name;
            cell.imagePortrait.image = [publicMethod GetImage:mess.portrait];
            cell.LableContent.text = mess.content;
            
            if (mess.amount != 0) {
                cell.badgeview.hidden = NO;
                [cell.badgeview addSubview:[CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d",mess.amount]]];
            }else{
                cell.badgeview.hidden = YES;
            }
            cell.LableDate.text = [mess.date substringToIndex:16];
            
            return cell;
        }
        else{
            static NSString *simpleTable = @"simpleCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTable];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTable];
            }
            cell.textLabel.text = @"没有消息";
            return cell;
        }
    }
}

#pragma table view delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.messageList count]) {
        chitchat = [[chitchatViewController alloc] initWithNibName:@"chitchatViewController" bundle:nil];
        Message *mess = [self.messageList objectAtIndex:[self.messageList count]-indexPath.row-1];
        chitchat.passmessage = mess;
        if (mess.amount != 0) {
//            NSString *badgeValue  = [NSString stringWithFormat:@"%d",self.tabBarItem.badgeValue.intValue - mess.amount];
//            if (![badgeValue isEqualToString:@"0"]) {
//                if ([badgeValue rangeOfString:@"-"].length) {
//                    self.tabBarItem.badgeValue = nil;
//                }else{
//                    self.tabBarItem.badgeValue = badgeValue;
//                }
//            }else{
//                self.tabBarItem.badgeValue = nil;
//            }
//            [self.tabBarItem.badgeValue writeToFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@AM.plist",[[publicMethod Add_appDelegate].myJID substringToIndex:[[publicMethod Add_appDelegate].myJID rangeOfString:@"@"].location]]] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
            
            mess.amount = 0;
            [self.messageList removeObjectAtIndex:[self.messageList count]-indexPath.row-1];
            [self.messageList addObject:mess];
//            [self.messageList replaceObjectAtIndex:[self.messageList count]-indexPath.row-1 withObject:mess];
            if ([publicMethod Add_appDelegate].loginuser != nil){
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
            }else{
                [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
            }
            [self.mytableview reloadData];
        }
        if (chitchat.passmessage) {
            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:chitchat animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle) {
        [self.messageList removeObjectAtIndex:indexPath.row];
        if ([publicMethod Add_appDelegate].loginuser != nil){
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"1_%@messList.plist",[publicMethod Add_appDelegate].loginuser.userid]]];
        }else{
            [NSKeyedArchiver archiveRootObject:self.messageList toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"0_%@messList.plist",[publicMethod Add_appDelegate].loginengineer.engineerid]]];
        }
        [self.mytableview reloadData];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_PullDownRefreshView egoRefreshScrollViewDidScroll:self.mytableview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_PullDownRefreshView egoRefreshScrollViewDidEndDragging:self.mytableview];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)refreshDone {
    _reloading = NO;
    [publicMethod Add_appDelegate].isRefreshMessage = YES;
    [self viewWillAppear:YES];
    [_PullDownRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mytableview];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self performSelector:@selector(refreshDone) withObject:nil afterDelay:1.0f];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return [NSDate date];
}

@end
