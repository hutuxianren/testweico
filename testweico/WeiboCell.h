//
//  WeiboCell.h
//  testweico
//
//  Created by luluteam on 15/9/16.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
@interface WeiboCell : UITableViewCell
{
    UIImageView *userImage;//用户头像
    UILabel     *nickNameLabel;//昵称
    UILabel     *repostCountLabel;//转发数
    UILabel     *commentCountLabel;//评论数
    UILabel     *sourceLabel;//发布来源
    UILabel     *creatDateLabel;//发布时间
}
@property(nonatomic,strong)WeiboModel *weiboModel;//微博数据模型对象
@property(nonatomic,strong)WeiboView *weiboView;//微博视图
@end
