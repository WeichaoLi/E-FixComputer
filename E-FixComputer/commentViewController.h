//
//  commentViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
@class Order;
@interface commentViewController : UIViewController<RatingViewDelegate,ASIHTTPRequestDelegate> {
	RatingView *starView;
	UILabel *ratingLabel;
    RatingView *starView2;
	UILabel *ratingLabel2;
    AppDelegate *appcomment;
}
@property (retain, nonatomic) IBOutlet RatingView *starView;
@property (retain, nonatomic) IBOutlet UILabel *ratingLabel;
@property (retain, nonatomic) IBOutlet RatingView *starView2;
@property (retain, nonatomic) IBOutlet UILabel *ratingLabel2;
@property (weak, nonatomic) IBOutlet UITextField *comment;
@property (retain, nonatomic) Order *order;

//1个textfield编辑完成时执行的操作
@property (weak, nonatomic) IBOutlet UITextView *commenttext;

@end
