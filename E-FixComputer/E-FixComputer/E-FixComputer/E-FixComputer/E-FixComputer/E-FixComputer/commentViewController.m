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
    [publicMethod addTitleOnNavigationBar:self titleContent:@"他的资料"];
    //左边的返回按钮
    [publicMethod addBackButton:self action:@selector(BacktoFormater)];
    
    [starView setImagesDeselected:@"star1.png" partlySelected:@"star2.png" fullSelected:@"star2.png" andDelegate:self];
    [starView2 setImagesDeselected:@"star1.png" partlySelected:@"star2.png" fullSelected:@"star2.png" andDelegate:self];
	[starView displayRating:0];
    [starView2 displayRating:0];
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

//控制评论字数为50字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *textString = textField.text ;
    NSUInteger length = [textString length]+1;
    NSLog(@"length is %lu",(unsigned long)length);
    BOOL bChange =YES;
    if (length >= 50)
        bChange = NO;
    if (range.length == 1) {
        bChange = YES;
    }
    return bChange;
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 50 - (self.view.frame.size.height - 216.0-50);//键盘高度216
    
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
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (IBAction)TextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

//textfield编辑完成时执行的操作
- (IBAction)do:(id)sender {
    
}
//提交评论
- (IBAction)sure:(id)sender {
    textViewController *q = [[textViewController alloc]initWithNibName:@"textViewController" bundle:nil];
    [self.navigationController pushViewController:q animated:YES];
}



@end
