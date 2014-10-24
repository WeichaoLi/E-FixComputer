//
//  orderDetailViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Engineer;
@class Order;

@interface orderDetailViewController : UIViewController

@property (retain, nonatomic) UIViewController *rootviewcontroller;
@property (retain, nonatomic) Engineer *PassObject;
@property (retain, nonatomic) Order *passOrder;
@property (weak, nonatomic) IBOutlet UILabel *objectName;
@property (weak, nonatomic) IBOutlet UITextView *textSendor;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UITextView *textAddress;
@property (weak, nonatomic) IBOutlet UITextView *textappointdate;

@end
