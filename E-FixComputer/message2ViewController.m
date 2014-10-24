//
//  message2ViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "message2ViewController.h"
#import "publicMethod.h"
#import "Comment.h"
#import "CommentCell.h"
#import "ToolKit.h"


@implementation message2ViewController
{
    UITableView *comentView;
    UIButton *button_HiddenComments;
}

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
    
    //导航条，返回按钮，标题
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backToPersentCenter)];
    appmessage2 = [publicMethod Add_appDelegate];
    
    //影藏tabbar
    self.tabBarController.tabBar.hidden = YES;
    self.commentList = [NSMutableArray array];
    self.PassEng = appmessage2.loginengineer;
    
    self.engineername.text = self.PassEng.engineername;
    self.engineergrade.text = self.PassEng.grade;
    self.engineerphone.text = self.PassEng.phone;
    self.engineeraddress.text = self.PassEng.address;
    self.description.text = self.PassEng.personDescription;
    self.repairnumber.text = self.PassEng.repairnumber;
    
    NSString *str3 = [NSString stringWithFormat:@"%@%@",HOST_PORTRAIT,self.PassEng.portrait];
    NSURL *url = [NSURL URLWithString:str3];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.engineerportrait.image = image;

}

//返回按钮执行的操作
- (void)backToPersentCenter{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *strUTL = [NSString stringWithFormat:@"%@comment/checkComment?engineer_id=%@",HOST,self.PassEng.engineerid];
    NSURL *url=[NSURL URLWithString:strUTL];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
    
    if (myScrollerview == nil) {
        
        //添加UIScrollView控件
        myScrollerview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, 320, 426)];
        myScrollerview.contentSize = CGSizeMake(320, 240);
        myScrollerview.bounces = NO;
        myScrollerview.delegate = self;
        
        // 查看评论
        button_HiddenComments = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_HiddenComments setTitle:@"评论列表" forState:UIControlStateNormal];
        button_HiddenComments.backgroundColor = [UIColor grayColor];
        button_HiddenComments.titleLabel.textColor = [UIColor greenColor];
        [button_HiddenComments setFrame:CGRectMake(0, 345, 320, 20)];
        [button_HiddenComments addTarget:self action:@selector(changePosition:) forControlEvents:UIControlEventTouchUpInside];
        button_HiddenComments.tag = 0;
        
        // 添加评论列表
        comentView = [[UITableView alloc]initWithFrame:CGRectMake(0, 365, 320, 325) style:UITableViewStylePlain];
        [comentView setDelegate:self];
        comentView.backgroundColor = [UIColor whiteColor];
        comentView.bounces = NO;
        [comentView setDataSource:self];
        
        [myScrollerview addSubview:comentView];
        [myScrollerview addSubview:button_HiddenComments];
        
        //把滚动视图添加到主视图
        [self.view addSubview:myScrollerview];
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *data = [request responseData];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dic in list) {
        
        Comment *com = [[Comment alloc] init];
        com.name = [dic objectForKey:@"name"];
        com.content = [dic objectForKey:@"content"];
        com.date = [dic objectForKey:@"date"];
        
        [self.commentList addObject:com];
    }
    [comentView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求失败");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 65+[com.content length]/23*20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CommentCell *cell;
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    }
    cell = (CommentCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Comment *com = [self.commentList objectAtIndex:indexPath.row];
    cell.LableName.text = com.name;
    UILabel *lablecon = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 290, 20+20*[com.content length]/23)];
    lablecon.numberOfLines = 0;
    lablecon.font = [UIFont systemFontOfSize: 13.0];
    lablecon.textColor = [UIColor darkGrayColor];
    [cell addSubview:lablecon];
    lablecon.text = com.content;
    cell.labledate.text = com.date;
    
    return cell;
}

//自适应键盘高度
-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = textView.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0-38);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)changePosition:(id)sender{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    UIButton *bt = (UIButton *)sender;
    if (bt.tag == 0) {
        myScrollerview.contentOffset = CGPointMake(0, 240);
        bt.tag = 1;
    }
    else{
        myScrollerview.contentOffset = CGPointMake(0, 0);
        bt.tag = 0;
    }
    
    [UIView commitAnimations];
}

@end
