//
//  EngineerCell.h
//  E-FixComputer
//
//  Created by administrator on 13-12-3.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageView.h"

@interface EngineerCell : UITableViewCell


@property (weak, nonatomic) IBOutlet ImageView *imagePortrait;
@property (weak, nonatomic) IBOutlet UILabel *lablename;
@property (weak, nonatomic) IBOutlet UILabel *lablegrade;
@property (weak, nonatomic) IBOutlet UILabel *lablestatus;
@property (weak, nonatomic) IBOutlet UILabel *lablerepairNumber;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *begoodat;

@end
