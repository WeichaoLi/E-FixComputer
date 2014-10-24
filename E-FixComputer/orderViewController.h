//
//  orderViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
@class waitViewController;
@class fixingViewController;
@class completedViewController;

@interface orderViewController : UIViewController

@property (retain, nonatomic) waitViewController *viewController3;
@property (retain, nonatomic) fixingViewController *viewController4;
@property (retain, nonatomic) completedViewController *viewController5;
@property BOOL isreload;
@property BOOL IsWait;

@property (retain, nonatomic) UISegmentedControl *segentedControl;
@property(retain,nonatomic)orderViewController *viewcontroller;

- (void)segmentAction;

@end
