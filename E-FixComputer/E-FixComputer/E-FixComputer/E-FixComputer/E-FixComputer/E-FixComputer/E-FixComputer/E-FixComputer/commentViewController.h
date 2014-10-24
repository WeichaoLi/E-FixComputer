//
//  commentViewController.h
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface commentViewController : UIViewController<RatingViewDelegate> {
	RatingView *starView;
	UILabel *ratingLabel;
    RatingView *starView2;
	UILabel *ratingLabel2;
}
@property (retain, nonatomic) IBOutlet RatingView *starView;
@property (retain, nonatomic) IBOutlet UILabel *ratingLabel;
@property (retain, nonatomic) IBOutlet RatingView *starView2;
@property (retain, nonatomic) IBOutlet UILabel *ratingLabel2;
@property (weak, nonatomic) IBOutlet UITextField *comment;

//提交评论
- (IBAction)sure:(id)sender;

- (IBAction)TextField_DidEndOnExit:(id)sender;
//1个textfield编辑完成时执行的操作


- (IBAction)do:(id)sender;


@end
