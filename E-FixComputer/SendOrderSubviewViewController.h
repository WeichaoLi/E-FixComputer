//
//  SendOrderSubviewViewController.h
//  易修电脑
//
//  Created by administrator on 13-12-9.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrderSubviewViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textviewContent;
@property (weak, nonatomic) IBOutlet UITextView *textviewAddress;
@property (weak, nonatomic) IBOutlet UITextView *textviewdate;

@end
