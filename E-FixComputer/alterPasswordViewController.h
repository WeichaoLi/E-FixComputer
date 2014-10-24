//
//  alterPasswordViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@interface alterPasswordViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>
{
    AppDelegate *alterapp;
}

@property (weak, nonatomic) IBOutlet UITextField *passwordold;
@property (weak, nonatomic) IBOutlet UITextField *passwordnew;
@property (weak, nonatomic) IBOutlet UITextField *passwordnew2;

- (IBAction)TextField_DidEndOnExit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *noedit1;
@property (weak, nonatomic) IBOutlet UITextField *noedit2;
@property (weak, nonatomic) IBOutlet UITextField *noedit3;

@end
