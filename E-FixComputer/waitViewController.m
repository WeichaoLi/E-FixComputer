//
//  waitViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "waitViewController.h"
#import "ASIHTTPRequest.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "WaitOrderCell.h"
#import "Order.h"
#import "User.h"
#import "Engineer.h"
#import "orderDetailViewController.h"

@interface waitViewController (){
    orderDetailViewController *orderdetail;
    NSTimer *timer;
    UIAlertView *alert;
}

@end

@implementation waitViewController

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
    
    self.SendOrderList = [NSMutableArray array];
    self.ReceiveOrderList = [NSMutableArray array];
    
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        [publicMethod AsynchronousGainData:self.request Target:self Path:[NSString stringWithFormat:@"order/UserWaitOrder?user_id=%@&sendstatus=0",[publicMethod Add_appDelegate].loginuser.userid]];
    }
    if ([publicMethod Add_appDelegate].loginengineer != nil){
        [publicMethod AsynchronousGainData:self.request Target:self Path:[NSString stringWithFormat:@"order/engineerWaitAcceptorder?receiver_id=%@&receivestatus=0&sendstatus=0",[publicMethod Add_appDelegate].loginengineer.engineerid]];
    }

    //下拉刷新
    _PullDownRefreshView = [[EGORefreshTableHeaderView alloc] initWithScrollView:self.mytableview orientation:EGOPullOrientationDown];
    _PullDownRefreshView.delegate = self;

    CGSize size = self.mytableview.frame.size;
    size.height +=3;
    self.mytableview.contentSize = size;
    [_PullDownRefreshView adjustPosition];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    self.SendOrderList = [NSMutableArray array];
    self.ReceiveOrderList = [NSMutableArray array];
    NSData *data = [request responseData];
    NSDictionary *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        for (NSDictionary *dic in list) {
            Order *order = [[Order alloc] init];
            
            order.id = [dic objectForKey:@"order_id"];
            order.receiveid = [dic objectForKey:@"receiveid"];
            order.portrait = [dic objectForKey:@"portrait"];
            order.name = [dic objectForKey:@"name"];
            order.content = [dic objectForKey:@"content"];
            order.address = [dic objectForKey:@"address"];
            order.appointdate = [dic objectForKey:@"appointdate"];
            order.senddate = [dic objectForKey:@"date"];
            order.sendstatus = [dic objectForKey:@"sendstatus"];
            order.receivestatus = [dic objectForKey:@"receivestatus"];
            
            [self.SendOrderList addObject:order];
        }
    }else{
        for (NSDictionary *dic in [list objectForKey:@"tome"]) {
            
            Order *order = [[Order alloc] init];
            
            order.id = [dic objectForKey:@"order_id"];
            order.userid = [dic objectForKey:@"userid"];
            order.engineerid = [dic objectForKey:@"engineerid"];
            order.name = [dic objectForKey:@"name"];
            order.portrait = [dic objectForKey:@"portrait"];
            order.content = [dic objectForKey:@"content"];
            order.address = [dic objectForKey:@"address"];
            order.appointdate = [dic objectForKey:@"appointdate"];
            order.senddate = [dic objectForKey:@"date"];
            order.sendstatus = [dic objectForKey:@"sendstatus"];
            
            [self.ReceiveOrderList addObject:order];
        }
        for (NSDictionary *dic in [list objectForKey:@"fromme"]) {
            Order *order = [[Order alloc] init];
            
            order.id = [dic objectForKey:@"order_id"];
            order.receiveid = [dic objectForKey:@"receiveid"];
            order.name = [dic objectForKey:@"name"];
            order.portrait = [dic objectForKey:@"portrait"];
            order.receivestatus = [dic objectForKey:@"receivestatus"];
            order.content = [dic objectForKey:@"content"];
            order.address = [dic objectForKey:@"address"];
            order.appointdate = [dic objectForKey:@"appointdate"];
            order.senddate = [dic objectForKey:@"date"];
            order.sendstatus = [dic objectForKey:@"sendstatus"];
            
            [self.SendOrderList addObject:order];
        }
    }
    [self.mytableview reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [[publicMethod Add_appDelegate] showAlertView:@"网络连接失败"];
}

#pragma table view datasource

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([publicMethod Add_appDelegate].loginuser != nil || [publicMethod Add_appDelegate].loginengineer != nil) {
        if ([publicMethod Add_appDelegate].loginuser != nil) {
            return 1;
        }else{
            return 2;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        return [self.SendOrderList count];
    }else{
        if (section == 0) {
            if (![self.ReceiveOrderList count]) {
                return 1;
            }else{
                return [self.ReceiveOrderList count];
            }
        }else{
            if (![self.SendOrderList count]) {
                return 1;
            }else{
                return [self.SendOrderList count];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        return 0.01;
    }else{
        return 40;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        return @"";
    }else{
        if (section == 1) {
            return @"                          我发送的预约";
        }else{
            return @"                          我收到的预约";
        }
    }
}

//加入发送预约的列表
- (UITableViewCell*)getSendList:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.SendOrderList count]) {
        static NSString *CellIdentifier = @"Cell";
        WaitOrderCell *cell;
        
        if (cell == nil) {
            UINib *nib = [UINib nibWithNibName:@"WaitOrderCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        }
        cell = (WaitOrderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        Order *order = [self.SendOrderList objectAtIndex:indexPath.row];
        
        cell.imagePortrait.image = [publicMethod GetImage:order.portrait];
        //            cell.imagePortrait.placeholderImage = [UIImage imageNamed:@"userhead.png"];
        //            cell.imagePortrait.imageURL = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,order.portrait];
        cell.lableName.text = order.name;
        cell.LableContent.text = order.content;
        cell.LableDate.text = [order.senddate substringToIndex:16];
        if ([order.receivestatus isEqualToString:@"0"]) {
            cell.lablestatus.text = @"等待对方接受";
        }else{
            cell.lablestatus.text = @"已取消";
            cell.backgroundColor = [UIColor lightTextColor];
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        static BOOL sign = YES;
        if (sign) {
            cell.textLabel.text = @"";
            sign = NO;
        }else{
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.text = @"您还没有发送过预约";
            sign = YES;
        }
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        return [self getSendList:tableView cellForRowAtIndexPath:indexPath];
    }
    else{
        if (indexPath.section == 0) {
            if ([self.ReceiveOrderList count]) {
                static NSString *CellIdentifier = @"Cell";
                WaitOrderCell *cell;
                
                if (cell == nil) {
                    UINib *nib = [UINib nibWithNibName:@"WaitOrderCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
                }
                cell = (WaitOrderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                Order *order = [self.ReceiveOrderList objectAtIndex:indexPath.row];
                
                cell.imagePortrait.image = [publicMethod GetImage:order.portrait];
//                cell.imagePortrait.placeholderImage = [UIImage imageNamed:@"userhead.png"];
//                cell.imagePortrait.imageURL = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,order.portrait];
                cell.lableName.text = order.name;
                cell.LableContent.text = order.content;
                cell.LableDate.text = [order.senddate substringToIndex:16];
                cell.lablestatus.text = @"等待接受";
                
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                static BOOL sign = YES;
                if (sign) {
                    cell.textLabel.text = @"";
                    sign = NO;
                }else{
                    cell.textLabel.font = [UIFont systemFontOfSize:15];
                    cell.textLabel.textColor = [UIColor grayColor];
                    cell.textLabel.text = @"没有您预约";
                    sign = YES;
                }
                return cell;
            }
        }else{
            return [self getSendList:tableView cellForRowAtIndexPath:indexPath];
        }
    }
}

#pragma-
#pragma- table view delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    orderdetail = [[orderDetailViewController alloc] initWithNibName:@"orderDetailViewController" bundle:nil];
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        if ([self.SendOrderList count]) {
            orderdetail.passOrder = [self.SendOrderList objectAtIndex:indexPath.row];
        }
    }else{
        if (indexPath.section == 0) {
            if ([self.ReceiveOrderList count]) {
                orderdetail.passOrder = [self.ReceiveOrderList objectAtIndex:indexPath.row];
            }
        }else{
            if ([self.SendOrderList count]) {
                orderdetail.passOrder = [self.SendOrderList objectAtIndex:indexPath.row];
            }
        }
    }
    orderdetail.rootviewcontroller = self.rootviewcontroller;
    if (orderdetail.passOrder) {
        [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = YES;
        [[[publicMethod Add_appDelegate].tabBarController.viewControllers objectAtIndex:2] pushViewController:orderdetail animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }else{
        if (![self.SendOrderList count]) {
            return NO;
        }
        if (![self.ReceiveOrderList count]) {
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle) {
        if ([publicMethod Add_appDelegate].loginuser != nil) {
            Order *order = [self.SendOrderList objectAtIndex:indexPath.row];
            [self.SendOrderList removeObjectAtIndex:indexPath.row];
            //删除
            NSString *stringURL = [NSString stringWithFormat:@"%@order/deleteorder?orderid=%@",HOST,order.id];
            NSURL *url = [NSURL URLWithString:stringURL];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request startSynchronous];
            NSString *result = [request responseString];
            if ([result rangeOfString:@"1"].length) {
                [self showAlertview:@"删除成功"];
                [self viewDidLoad];
            }else{
                [self showAlertview:@"删除失败"];
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
        }else{
            if (indexPath.section) {
                Order *order = [self.SendOrderList objectAtIndex:indexPath.row];
                [self.SendOrderList removeObjectAtIndex:indexPath.row];
                //删除
                NSString *stringURL = [NSString stringWithFormat:@"%@order/deleteorder?orderid=%@",HOST,order.id];
                NSURL *url = [NSURL URLWithString:stringURL];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request startSynchronous];
                NSString *result = [request responseString];
                if ([result rangeOfString:@"1"].length) {
                    [self showAlertview:@"删除成功"];
                    [self viewDidLoad];
                }else{
                    [self showAlertview:@"删除失败"];
                }
                timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
            }else{
                
            }
        }
    }
}

- (void)showAlertview:(NSString*)message{
    alert = [[UIAlertView alloc] initWithTitle:Nil message:message delegate:self cancelButtonTitle:Nil otherButtonTitles: nil];
    [alert show];
}

- (void)hiddenAlert{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_PullDownRefreshView egoRefreshScrollViewDidScroll:self.mytableview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_PullDownRefreshView egoRefreshScrollViewDidEndDragging:self.mytableview];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [self performSelector:@selector(refreshDone) withObject:nil afterDelay:2.0f];
}

- (void)refreshDone {
    _reloading = NO;
    [_PullDownRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mytableview];
    
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        [publicMethod AsynchronousGainData:self.request Target:self Path:[NSString stringWithFormat:@"order/UserWaitOrder?user_id=%@&sendstatus=0",[publicMethod Add_appDelegate].loginuser.userid]];
    }
    if ([publicMethod Add_appDelegate].loginengineer != nil){
        [publicMethod AsynchronousGainData:self.request Target:self Path:[NSString stringWithFormat:@"order/engineerWaitAcceptorder?receiver_id=%@&receivestatus=0&sendstatus=0",[publicMethod Add_appDelegate].loginengineer.engineerid]];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
