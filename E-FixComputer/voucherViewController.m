//
//  voucherViewController.m
//  易修电脑
//
//  Created by administrator on 13-12-12.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "voucherViewController.h"
#import "publicMethod.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "AppDelegate.h"
#import "Engineer.h"

@interface voucherViewController ()

@end

@implementation voucherViewController

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
    appvoucher = [publicMethod Add_appDelegate];
}
//返回按钮执行事件
- (void)backToPersentCenter{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)paymoney:(id)sender {
    
    
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    //partner和seller获取失败,提示
	if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		return;
	}
    /*
	 *生成订单信息及签名
	 */
	//将商品信息赋予AlixPayOrder的成员变量
    
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
    //	order.tradeNO = self.orderrnumber.text; //支付宝交易号
	order.productName = [NSString stringWithFormat:@"工程师：%@",appvoucher.loginengineer.engineername]; //商品标题
	order.productDescription = @"womenshishenme"; //商品描述
	order.amount = self.money.text; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"yixiudiannao";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
	NSLog(@"signedString:%@",signedString);
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSLog(@"888888%@",orderString);
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:@"取消",nil];
            [alertView setTag:123];
            [alertView show];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
	}
    
}
@end
