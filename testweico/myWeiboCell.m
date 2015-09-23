//
//  myWeiboCell.m
//  testweico
//
//  Created by luluteam on 15/9/16.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import "myWeiboCell.h"

@implementation myWeiboCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //用户头像
    _headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImage.backgroundColor = [UIColor clearColor];
    _headImage.layer.cornerRadius = 5;  //圆弧半径
    _headImage.layer.borderWidth = .5;
    _headImage.layer.borderColor = [UIColor grayColor].CGColor;
    _headImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    //昵称
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _authorLabel .backgroundColor = [UIColor clearColor];
    _authorLabel .font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_authorLabel];
    
    //转发数
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    //回复数
    _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentCountLabel.font = [UIFont systemFontOfSize:12.0];
    _commentCountLabel.backgroundColor = [UIColor clearColor];
    _commentCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentCountLabel];
    
    
    //微博来源
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_timeLabel];
    //微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //-----------用户头像视图_userImage--------
    _headImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    //昵称_authorLabel
    _authorLabel.frame = CGRectMake(50, 5, 200, 20);
    _authorLabel.text = _weiboModel.user.screen_name;
    
    
    //微博视图_weiboView
    _weiboView.weiboModel = _weiboModel;
    //获取微博视图的高度
    //float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    //_weiboView.frame = CGRectMake(50, _nickLabel.bottom+10, kWeibo_Width_List, h);
    
    
}

@end
