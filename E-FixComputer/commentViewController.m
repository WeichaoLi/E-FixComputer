//
//  commentViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "commentViewController.h"
#import "textViewController.h"
#import "publicMethod.h"
#import "ToolKit.h"
#import "User.h"
#import "Engineer.h"
#import "Order.h"
#import "completedViewController.h"
@interface commentViewController ()

@end

@implementation commentViewController
@synthesize starView;
@synthesize ratingLabel;
@synthesize starView2;
@synthesize ratingLabel2;

-(void)ratingChanged:(float)newRating {
    
	ratingLabel.text = [NSString stringWithFormat:@"%1.f", starView.rating];
    ratingLabel2.text = [NSString stringWithFormat:@"%1.f", starView2.rating];
    
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
    //添加导航栏
    [publicMethod addNavigationBar:self];
    [publicMethod addTitleOnNavigationBar:self titleContent:@"评论"];
    self.comment.enabled = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2411.png"]];
    //设置提交评论按钮
    UIButton *loginbutton = [[UIButton alloc]init];
    loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbutton.frame = CGRectMake(20, 320, 280, 40);
    loginbutton.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
    loginbutton.titleLabel.textColor = [UIColor whiteColor];
    loginbutton.layer.cornerRadius = 5;
    [loginbutton setTitle:@"提交评论" forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbutton];
    //左边的返回按钮
    [publicMethod addBackButton:self action:@selector(BacktoFormater)];
    
    [starView setImagesDeselected:@"star2.png" partlySelected:@"star1.png" fullSelected:@"star1.png" andDelegate:self];
    [starView2 setImagesDeselected:@"star2.png" partlySelected:@"star1.png" fullSelected:@"star1.png" andDelegate:self];
	[starView displayRating:0];
    [starView2 displayRating:0];
    appcomment = [publicMethod Add_appDelegate];

}
//返回按钮的方法
- (void)BacktoFormater{
    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 50) {
        textView.text = [textView.text substringToIndex:30];
        number = 50;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

//提交评论
- (void)logIn{
    //判空
    if ([self.commenttext.text isEqualToString:@""]) {
        UIAlertView *elert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"以上选项为必填" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert show];
    }
    else{
        
       
   NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/addComment",HOST]];
    ASIFormDataRequest *asiFormData=[ASIFormDataRequest requestWithURL:url];
    NSDate *date=[NSDate date];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    if (appcomment.loginuser != nil) {
        [asiFormData setPostValue:appcomment.loginuser.userid forKey:@"user_id"];
        }
    if (appcomment.loginengineer !=nil) {
        [asiFormData setPostValue:appcomment.loginengineer.engineerid forKey:@"engineer_id"];
      }
    int rate = [self.ratingLabel.text intValue]+[self.ratingLabel2.text intValue];
    NSLog(@"%@",[NSString stringWithFormat:@"%d",rate]);
    [asiFormData setPostValue:self.order.receiveid forKey:@"receiver_id"];
    [asiFormData setPostValue:[NSString stringWithFormat:@"%d",rate] forKey:@"comment_grade"];
    [asiFormData setPostValue:self.commenttext.text forKey:@"comment_content"];
    [asiFormData setPostValue:[df stringFromDate:date] forKey:@"comment_date"];
    [asiFormData startSynchronous];
    NSString *result = [asiFormData responseString];
    
     NSLog(@"%@",result);
        UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"评论成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert1 show];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
