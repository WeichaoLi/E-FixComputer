//
//  registerViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "user.h"
#import "AppDelegate.h"

@interface registerViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>
{
    AppDelegate *registerapp;
}
//4个textfield
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) NSString *responsemessage;
//2个按钮

- (IBAction)TextField_DidEndOnExit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *noedit;
@property (weak, nonatomic) IBOutlet UITextField *noedit2;
@property (weak, nonatomic) IBOutlet UITextField *noedit3;
@property (weak, nonatomic) IBOutlet UITextField *noedit4;


@end
