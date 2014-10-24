//
//  SendOrderViewController.m
//  易修电脑
//
//  Created by administrator on 13-12-9.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "SendOrderViewController.h"
#import "engineerDetailViewController.h"
#import "SendOrderSubviewViewController.h"
#import "User.h"
#import "Engineer.h"
#import "Order.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "ASIFormDataRequest.h"
//#import "UserDetailViewController.h"

@interface SendOrderViewController (){
    engineerDetailViewController *engineerDetail;
    SendOrderSubviewViewController *sendOrderSubview;
//    UserDetailViewController *userDetail;
    UIViewController *datepickerView;
    UIDatePicker *datepicker;
    UIButton *sendButton;
    NSTimer *timer;
    UILabel *Lablereminder;//提示
    UIActivityIndicatorView *around;
}

@end

@implementation SendOrderViewController

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
    [publicMethod addTitleOnNavigationBar:self titleContent:@"预约详情"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"4444.jpeg"]];
    //左边的返回按钮
    [publicMethod addBackButton:self action:@selector(BacktoFormater)];
//    [publicMethod addRightButton:self backGroundimage:[UIImage imageNamed:@"checkInfo.png"] action:@selector(BrowseInformation)];
    
    if ([publicMethod Add_appDelegate].loginuser != nil) {
        sendOrderSubview.textviewAddress.text = [publicMethod Add_appDelegate].loginuser.address;
    }else{
        sendOrderSubview.textviewAddress.text = [publicMethod Add_appDelegate].loginengineer.address;
    }
    
    if (Lablereminder == nil) {
        Lablereminder = [[UILabel alloc]initWithFrame:CGRectMake(80, 389, 160, 45)];
        Lablereminder.backgroundColor = [UIColor lightGrayColor];
        Lablereminder.textColor = [UIColor whiteColor];
        Lablereminder.textAlignment = NSTextAlignmentCenter;
        Lablereminder.layer.cornerRadius = 5;
        [self.view addSubview:Lablereminder];
    }
        Lablereminder.hidden = YES;
    
    if (around == nil) {
        around = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(80, 389, 160, 45)];
        around.color = [UIColor blackColor];
        around.backgroundColor = [UIColor blackColor];
        [self.view addSubview:around];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    if (self.myscrollview == nil) {
        //添加UIScrollView控件
        self.myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, 320, 426)];
        self.myscrollview.delegate = self;
        
        if (sendOrderSubview == nil) {
            sendOrderSubview = [[SendOrderSubviewViewController alloc] initWithNibName:@"SendOrderSubviewViewController" bundle:nil];
            sendOrderSubview.view.frame = CGRectMake(0, 0, 320, 330);
            sendOrderSubview.textviewContent.delegate = self;
            sendOrderSubview.textviewAddress.delegate = self;
            sendOrderSubview.textviewdate.delegate = self;
        }
        //设置发送按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(50, 380, 220, 40);
         sendButton.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
        sendButton.layer.cornerRadius = 5;
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        sendButton.titleLabel.textColor = [UIColor whiteColor];
      
        [sendButton addTarget:self action:@selector(sendOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.myscrollview addSubview:sendOrderSubview.view];
        [self.myscrollview addSubview:sendButton];
        
        [self.view addSubview:self.myscrollview];
    }
}

//返回按钮
- (void)BacktoFormater{
    [datepickerView.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];

}

//查看详情
- (void)BrowseInformation{
    if ([self.PassObject isKindOfClass:[User class]]) {
//        if (userDetail == nil) {
//            userDetail = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
//        }
//        [self.navigationController pushViewController:userDetail animated:YES];
    }else{
        if (engineerDetail == nil) {
            engineerDetail = [[engineerDetailViewController alloc] initWithNibName:@"engineerDetailViewController" bundle:nil];
        }
        engineerDetail.PassEng = self.PassObject;
        [self.navigationController pushViewController:engineerDetail animated:YES];
    }
}

//发送预约按钮
- (void)sendOrder:(id)sender{
    Lablereminder.hidden = NO;
    if (![sendOrderSubview.textviewContent.text isEqualToString:@""]) {
        if (![sendOrderSubview.textviewAddress.text isEqualToString:@""]) {
            if (![sendOrderSubview.textviewdate.text isEqualToString:@""]) {
                
                [around startAnimating];
                
                NSString *strURL = [NSString stringWithFormat:@"%@order/Pushorder",HOST];
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
                if ([publicMethod Add_appDelegate].loginuser != nil) {
                    [request setPostValue:[publicMethod Add_appDelegate].loginuser.userid forKey:@"send_userid"];
                }else{
                    [request setPostValue:[publicMethod Add_appDelegate].loginengineer.engineerid forKey:@"send_engineerid"];
                }
                
                Engineer *eng = self.PassObject;
                [request setPostValue:eng.engineerid forKey:@"receive_engineerid"];
                [request setPostValue:sendOrderSubview.textviewContent.text forKey:@"order_content"];
                [request setPostValue:sendOrderSubview.textviewAddress.text forKey:@"order_address"];
                [request setPostValue:sendOrderSubview.textviewdate.text forKey:@"order_appointdate"];
                NSDateFormatter *dataformatter = [[NSDateFormatter alloc] init];
                [dataformatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSString *dataString = [dataformatter stringFromDate:[NSDate date]];
                [request setPostValue:dataString forKey:@"order_date"];
                
                [request setRequestMethod:@"POST"];
                [request startSynchronous];
                NSString *result = [[request responseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                [around stopAnimating];
                if ([result rangeOfString:@"success"].length) {
                    NSLog(@"发送成功");
                    [publicMethod Add_appDelegate].isRefreshOrder = YES;
                    NSLog(@"------%hhd",[publicMethod Add_appDelegate].isRefreshOrder);
                    Lablereminder.text = @"发送成功";
                    [publicMethod Add_appDelegate].tabBarController.tabBar.hidden = NO;
                    [publicMethod Add_appDelegate].tabBarController.selectedIndex = 2;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    Lablereminder.text = @"发送失败";
                    NSLog(@"发送失败");
                }

                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HiddenLablereminder) userInfo:nil repeats:NO];
            }else{
                Lablereminder.text = @"请填写预约时间";
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HiddenLablereminder) userInfo:nil repeats:NO];
            }
        }else{
            Lablereminder.text = @"请填写地址";
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HiddenLablereminder) userInfo:nil repeats:NO];
        }
    }else{
        Lablereminder.text = @"请填写内容";
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HiddenLablereminder) userInfo:nil repeats:NO];
    }
}

//计时器执行的事件
- (void)HiddenLablereminder{
    Lablereminder.hidden = YES;
}

//点击textview，首先执行的事件
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.tag == 3) {
        if (datepickerView == nil) {
            datepickerView = [[UIViewController alloc] init];
            datepickerView.view.frame = CGRectMake(0, 270, 320, 300);
            datepickerView.view.backgroundColor = [UIColor whiteColor];
            
            UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
            
            left.frame = CGRectMake(0, 0, 160, 40);
            right.frame = CGRectMake(161, 0, 160, 40);
            left.tag = 1;
            right.tag = 2;
            [left setTitle:@"取消" forState:UIControlStateNormal];
            left.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
        
            [right setTitle:@"设置" forState:UIControlStateNormal];
            right.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
            
            left.titleLabel.textColor = [UIColor whiteColor];
            right.titleLabel.textColor = [UIColor whiteColor];
          

            [left addTarget:self action:@selector(datepickerAction:) forControlEvents:UIControlEventTouchUpInside];
            [right addTarget:self action:@selector(datepickerAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [datepickerView.view addSubview:left];
            [datepickerView.view addSubview:right];
            
            datepicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, 320, 240)];
            datepicker.minimumDate = [NSDate date];
            datepicker.datePickerMode = UIDatePickerModeDateAndTime;
            [datepickerView.view addSubview:datepicker];
        }else{
            datepickerView.view.hidden = NO;
        }
        sendOrderSubview.textviewContent.editable = NO;
        sendOrderSubview.textviewAddress.editable = NO;
        [self.myscrollview setContentOffset:CGPointMake(0, 114) animated:YES];
        [self.view addSubview:datepickerView.view];

        return NO;
    }else if (textView.tag == 2){
        [self.myscrollview setContentOffset:CGPointMake(0, 50) animated:YES];
        [sendOrderSubview.textviewContent endEditing:YES];
    }
    return YES;
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self textViewShouldBeginEditing:textView];
    [self.myscrollview setContentOffset:CGPointMake(0, 0) animated:YES];
}

//选择时间
- (void)datepickerAction:(id)sender{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 1) {
        [datepickerView.view setHidden:YES];
    }else{
        NSDate *date = [datepicker date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *datestring = [dateformatter stringFromDate:date];
        sendOrderSubview.textviewdate.text = datestring;
        [datepickerView.view setHidden:YES];
    }
    [self.myscrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    sendOrderSubview.textviewContent.editable = YES;
    sendOrderSubview.textviewAddress.editable = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [datepickerView.view setHidden:YES];
    [self.myscrollview setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
