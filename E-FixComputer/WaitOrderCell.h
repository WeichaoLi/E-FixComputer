//
//  WaitOrderCell.h
//  易修电脑
//
//  Created by administrator on 13-12-18.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageView.h"

@interface WaitOrderCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIView *badgeview;
@property (weak, nonatomic) IBOutlet ImageView *imagePortrait;
@property (weak, nonatomic) IBOutlet UILabel *lableName;
@property (weak, nonatomic) IBOutlet UILabel *LableDate;
@property (weak, nonatomic) IBOutlet UILabel *LableContent;
@property (weak, nonatomic) IBOutlet UILabel *lablestatus;

@end
