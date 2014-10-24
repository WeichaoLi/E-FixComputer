//
//  voucherViewController.h
//  易修电脑
//
//  Created by administrator on 13-12-12.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface voucherViewController : UIViewController
{
    AppDelegate *appvoucher;
}
@property (weak, nonatomic) IBOutlet UITextField *money;
- (IBAction)paymoney:(id)sender;

@end
