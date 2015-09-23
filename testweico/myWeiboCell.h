//
//  myWeiboCell.h
//  testweico
//
//  Created by luluteam on 15/9/16.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "WeiboModel.h"
#import "WeiboView.h"
@interface myWeiboCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;
@property (strong, nonatomic) IBOutlet UITextView *neirongTextView;

@property (strong, nonatomic) IBOutlet UILabel *repostCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UIImageView *zhengwenImage;
@property (strong, nonatomic) IBOutlet UITextView *repostArea;//转发微博
@property(nonatomic,strong)WeiboModel *weiboModel;//微博数据模型对象
//微博视图
@property(nonatomic,retain)WeiboView *weiboView;
@end
