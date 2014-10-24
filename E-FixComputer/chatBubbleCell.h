//
//  chatBubbleCell.h
//  易修电脑
//
//  Created by administrator on 13-12-30.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageView.h"

@interface chatBubbleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundimage;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet ImageView *Imageopposite;
@property (weak, nonatomic) IBOutlet ImageView *Imageself;
@end
