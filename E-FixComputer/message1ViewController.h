//
//  message1ViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolKit.h"
#import "AppDelegate.h"

@interface message1ViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>
{
    AppDelegate *messageApp;
}

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextView *address;


//定义一个头像视图、一个头像、和一个选中的头像
@property (retain,nonatomic)UIView *headView;
@property (retain,nonatomic)UIImage *headImage;
@property (retain,nonatomic)UIImage *chooseImage;
@property (retain,nonatomic)User *givenUser;
@property (weak, nonatomic) IBOutlet UITextField *notaddress;

- (IBAction)TextField_DidEndOnExit:(id)sender;


@end
