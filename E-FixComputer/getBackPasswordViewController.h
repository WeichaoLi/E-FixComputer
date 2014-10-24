//
//  getBackPasswordViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface getBackPasswordViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *getbackusername;
@property (weak, nonatomic) IBOutlet UITextField *newpassword1;
@property (weak, nonatomic) IBOutlet UITextField *newpassword2;
@property (weak, nonatomic) IBOutlet UITextField *getbackemail;
- (IBAction)TextField_DidEndOnExit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *noedit;
@property (weak, nonatomic) IBOutlet UITextField *noedit2;
@property (weak, nonatomic) IBOutlet UITextField *noedit3;
@property (weak, nonatomic) IBOutlet UITextField *noedit4;

@end
