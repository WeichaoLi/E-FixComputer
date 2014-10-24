//
//  CommentCell.h
//  易修电脑
//
//  Created by administrator on 13-12-14.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LableName;
@property (weak, nonatomic) IBOutlet UILabel *labledate;
@property (weak, nonatomic) IBOutlet UILabel *lableContent;
@property (weak, nonatomic) IBOutlet UILabel *lablegrade;

@end
