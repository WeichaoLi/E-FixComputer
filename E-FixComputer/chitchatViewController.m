//
//  chitchatViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-12-6.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "chitchatViewController.h"
#import "engineerDetailViewController.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "Engineer.h"
#import "User.h"
#import "talk.h"
#import "ImageView.h"
#import "chatBubbleCell.h"

@interface chitchatViewController (){
    engineerDetailViewController *engineerDetail;
    UITextView *textview;
    UIButton *sendButton;
    
    User *user;
    Engineer *engineer;
    
    NSString *myjid;
    UITextView *contentView;
    ImageView *portrait;
    UIImageView *inputBackgroundimage;
    UIImageView *sendBackgroundimage;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *toJIDString;
@property (nonatomic, strong) XMPPJID *toJID;
@property (copy, nonatomic) NSString *originWav;

@end

@implementation chitchatViewController

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
    //加入导航栏，按钮,标题
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backtoChatList)];
    [publicMethod addTitleOnNavigationBar:self titleContent:self.passmessage.name];
}

//返回按钮
- (void)backtoChatList{
    [publicMethod Add_appDelegate].isRefreshMessage = YES;
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
    [publicMethod Add_appDelegate].tabBarController.selectedIndex = 1;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//查看聊天对象的资料
- (void)BrowseInformation{
    NSArray *array = [self.passmessage.id componentsSeparatedByString:@"_"];
    if ([array[0] isEqualToString:@"0"]) {
        NSString *strurl = [NSString stringWithFormat:@"%@engineer/showoneinfo?id=%@",HOST,array[1]];
        NSURL *url = [NSURL URLWithString:strurl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.delegate = self;
        [request startSynchronous];
        NSData *data = [request responseData];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *dic = list[0];
        Engineer *eng = [[Engineer alloc]init];
        
        eng.engineername = [dic objectForKey:@"engineer_name"];
        eng.status = [dic objectForKey:@"engineer_status"];
        eng.portrait = [dic objectForKey:@"engineer_portrait"];
        eng.repairnumber = [dic objectForKey:@"engineer_repairnumber"];
        eng.grade = [dic objectForKey:@"engineer_grade"];
        eng.longitude = [dic objectForKey:@"engineer_longitude"];
        eng.latitude = [dic objectForKey:@"engineer_latitude"];
        
        if (engineerDetail == nil) {
            engineerDetail = [[engineerDetailViewController alloc] initWithNibName:@"engineerDetailViewController" bundle:nil];
        }
        engineerDetail.PassEng = eng;
        [self.navigationController pushViewController:engineerDetail animated:YES];
    }
}

-(void)newMsgCome:(NSNotification *)notifacation{
    NSLog(@"聊天界面的消息－－－－－－－新消息－－－－－");
    self.userdataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@|%@data.plist",self.passmessage.id,[myjid substringToIndex:[myjid rangeOfString:@"@"].location]]]];
    if (self.userdataArray == nil) {
        self.userdataArray = [NSMutableArray array];
    }
    [self.mytableview reloadData];
    talk *atalk = self.userdataArray.lastObject;
    NSLog(@"聊天界面的消息：%@",atalk);
    if ([self.userdataArray count]) {
        [_mytableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.userdataArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.mytableview.sectionIndexMinimumDisplayRowCount = 50;
    myjid = [publicMethod Add_appDelegate].myJID;
    self.userdataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@|%@data.plist",self.passmessage.id,[myjid substringToIndex:[myjid rangeOfString:@"@"].location]]]];
    if (self.userdataArray == nil) {
        self.userdataArray = [NSMutableArray array];
    }
    
    if ( [self.userdataArray count] > 4) {
        [self.mytableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.userdataArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    _toJIDString = [NSString stringWithFormat:@"%@@%@",self.passmessage.id,OFHOST];
    
    NSLog(@"发给-->> :%@",_toJIDString);
    
    [_mytableview scrollToRowAtIndexPath:nil atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    //监听新消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:@"newMessage" object:nil];
    
    self.toJID = [XMPPJID jidWithUser:[_toJIDString substringToIndex:[_toJIDString rangeOfString:@"@"].location] domain:OFHOST resource:nil];
    
    self.mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 54, 320, 386) style:UITableViewStyleGrouped];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mytableview];
    
    _PullDownRefreshView = [[EGORefreshTableHeaderView alloc] initWithScrollView:self.mytableview orientation:EGOPullOrientationDown];
    _PullDownRefreshView.delegate = self;
    
    CGSize size = self.mytableview.frame.size;
    size.height +=1;
    self.mytableview.contentSize = size;
    [_PullDownRefreshView adjustPosition];
    
    if (inputBackgroundimage == nil) {
        inputBackgroundimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 440, 260, 40)];
        inputBackgroundimage.backgroundColor = [UIColor grayColor];
        [self.view addSubview:inputBackgroundimage];
    }
    if (textview == nil) {
        textview = [[UITextView alloc]initWithFrame:CGRectMake(8, 444, 245, 32)];
        textview.delegate = self;
        textview.font = [UIFont systemFontOfSize:16];
        textview.bounces = NO;
        textview.layer.cornerRadius = 5;
        textview.backgroundColor = [UIColor whiteColor];
        textview.textColor = [UIColor blackColor];
    }
    if (sendBackgroundimage == nil) {
        sendBackgroundimage = [[UIImageView alloc]initWithFrame:CGRectMake(260, 440, 60, 40)];
        sendBackgroundimage.image = [[UIImage imageNamed:@"sendbtn.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        [self.view addSubview:sendBackgroundimage];
    }
    
    if (sendButton == nil) {
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.backgroundColor = [UIColor clearColor];
        sendButton.frame = CGRectMake(260, 440, 60, 40);
        sendButton.titleLabel.textColor = [UIColor whiteColor];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    }
    textview.text = nil;
    [self.view addSubview:sendButton];
    [self.view addSubview:textview];
}

- (void)sendMessage{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.toJID];
    [message addBody:textview.text];
    [[[publicMethod Add_appDelegate] xmppStream] sendElement:message];
}

- (void)send{
    if (![[textview.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [publicMethod Add_appDelegate].isRefreshMessage = YES;
        talk *atalk = [[talk alloc] init];
        atalk.content = textview.text;
        atalk.toName = _toJIDString;
        atalk.fromName = myjid;
        NSDate * senddate =[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *  morelocationString=[dateformatter stringFromDate:senddate];
        atalk.date = morelocationString ;
        
        [[publicMethod Add_appDelegate].chatArray addObject:atalk] ;
        [self sendMessage];
        [textview resignFirstResponder];
        [textview setText:nil];
        
        [self.userdataArray addObject:atalk];
        [NSKeyedArchiver archiveRootObject:self.userdataArray toFile:[publicMethod getDocumentPath:[NSString stringWithFormat:@"%@|%@data.plist",self.passmessage.id,[myjid substringToIndex:[myjid rangeOfString:@"@"].location]]]];
        
        [_mytableview reloadData];
        if ( [self.userdataArray count] > 4) {
            [_mytableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.userdataArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userdataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    talk *atalk = [[talk alloc] init];
    atalk = [self.userdataArray objectAtIndex:indexPath.row];
    CGRect labelsize = [atalk.content boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:Nil];
    return 70+labelsize.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    talk *atalk = [[talk alloc] init];
    atalk = [self.userdataArray objectAtIndex:indexPath.row];
    CGRect labelsize = [atalk.content boundingRectWithSize:CGSizeMake(150, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:Nil];
    //    if(cell == nil){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    ImageView *Imageopposite = [[ImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    Imageopposite.tag = 1;
    [[cell contentView]addSubview:Imageopposite];
    
    ImageView *Imageself = [[ImageView alloc] initWithFrame:CGRectMake(260, 10, 50, 50)];
    Imageself.tag = 2;
    [[cell contentView]addSubview:Imageself];
    
    UIImageView *backgroundimage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 25, 200, 20+labelsize.size.height)];
    backgroundimage.tag = 3;
    [[cell contentView]addSubview:backgroundimage];
    
    UILabel *lablecon = [[UILabel alloc]initWithFrame:CGRectMake(85, 30, 150, labelsize.size.height)];
    lablecon.tag = 4;
    lablecon.numberOfLines = 0;
    lablecon.lineBreakMode = NSLineBreakByWordWrapping;
    lablecon.font = [UIFont systemFontOfSize: 15.0];
    [[cell contentView]addSubview:lablecon];
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *content = (UILabel*)[cell viewWithTag:4];
    
    
    if ([atalk.fromName isEqualToString:myjid]) {
        if ([publicMethod Add_appDelegate].loginuser) {
            Imageself.image = [publicMethod GetImage:[publicMethod Add_appDelegate].loginuser.portrait];
            Imageopposite.image = [[UIImage imageNamed:@"white.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:23];
        }else{
            Imageself.image = [publicMethod GetImage:[publicMethod Add_appDelegate].loginengineer.portrait];
            Imageopposite.image = [[UIImage imageNamed:@"white.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:23];
        }
        content.textAlignment = NSTextAlignmentRight;
        backgroundimage.image = [[UIImage imageNamed:@"self.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:23];
    }else if([atalk.fromName isEqualToString:_toJIDString]){
        Imageself.image = [[UIImage imageNamed:@"white.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:23];
        Imageopposite.image = [publicMethod GetImage:self.passmessage.portrait];
        backgroundimage.image = [[UIImage imageNamed:@"chat02.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:23];
        content.textAlignment = NSTextAlignmentLeft;
    }
    
    content.text = atalk.content;
    
    return cell;
}

//界面调整
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.mytableview.frame = CGRectMake(0, 54, 320, 140);
    textview.frame = CGRectMake(8, 196, 245, 32);
    inputBackgroundimage.frame = CGRectMake(0, 192, 260, 40);
    sendButton.frame = CGRectMake(260, 192, 60, 40);
    sendBackgroundimage.frame = CGRectMake(260, 192, 60, 40);
    
    CGRect labelsize = [textView.text boundingRectWithSize:CGSizeMake(245, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:Nil];
    if (labelsize.size.height>20) {
        self.mytableview.frame = CGRectMake(0, 54, 320, 120);
        textview.frame = CGRectMake(8, 176, 245, 52);
        inputBackgroundimage.frame = CGRectMake(0, 172, 260, 60);
        sendButton.frame = CGRectMake(260, 172, 60, 60);
        sendBackgroundimage.frame = CGRectMake(260, 172, 60, 60);
    }
    
    if ( [self.userdataArray count]) {
        [_mytableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.userdataArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    CGRect labelsize = [textView.text boundingRectWithSize:CGSizeMake(245, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] context:Nil];
//    NSLog(@"%f",labelsize.size.height);
    if (labelsize.size.height>20) {
        self.mytableview.frame = CGRectMake(0, 54, 320, 120);
        textview.frame = CGRectMake(8, 176, 245, 52);
        inputBackgroundimage.frame = CGRectMake(0, 172, 260, 60);
        sendButton.frame = CGRectMake(260, 172, 60, 60);
        sendBackgroundimage.frame = CGRectMake(260, 172, 60, 60);
    }else{
        [self textViewShouldBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.mytableview.frame = CGRectMake(0, 54, 320, 386);
    textview.frame = CGRectMake(8, 444, 245, 32);
    inputBackgroundimage.frame = CGRectMake(0, 440, 260, 40);
    sendButton.frame = CGRectMake(260, 440, 60, 40);
    sendBackgroundimage.frame = CGRectMake(260, 440, 60, 40);
    if ( [self.userdataArray count]) {
        [_mytableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.userdataArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
///------------------------------------------------------------------------------------------////
#pragma table view delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [textview resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////
///------------------------------------------------------------------------------------------////

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
    [self.mytableview reloadData];
    [_PullDownRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_mytableview];
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
