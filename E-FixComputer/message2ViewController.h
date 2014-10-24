//
//  message2ViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Engineer.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"

@interface message2ViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UIScrollView *myScrollerview;
    AppDelegate *appmessage2;
    
}

@property (retain, nonatomic) Engineer *PassEng;
@property (retain, nonatomic) NSMutableArray *commentList;

@property (weak, nonatomic) IBOutlet UILabel *engineername;
@property (weak, nonatomic) IBOutlet UILabel *engineergrade;
@property (weak, nonatomic) IBOutlet UITextField *engineerphone;
@property (weak, nonatomic) IBOutlet UIImageView *engineerportrait;
@property (weak, nonatomic) IBOutlet UILabel *repairnumber;
@property (weak, nonatomic) IBOutlet UITextView *engineeraddress;
@property (weak, nonatomic) IBOutlet UITextView *description;

@property int tag;

@end
