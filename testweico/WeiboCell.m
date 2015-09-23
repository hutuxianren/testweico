//
//  WeiboCell.m
//  testweico
//
//  Created by luluteam on 15/9/16.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewExt.h"
#import <ImageIO/ImageIO.h>
#import "UIUtils.h"
@implementation WeiboCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self _initView];
    }
    return  self;
}
//初始化子视图
-(void)_initView
{
    //用户头像
    userImage=[[UIImageView alloc]initWithFrame:CGRectZero];
    userImage.backgroundColor=[UIColor clearColor];
    userImage.layer.cornerRadius=5;
    userImage.layer.borderWidth=.5;
    userImage.layer.borderColor=[UIColor grayColor].CGColor;
    userImage.layer.masksToBounds=YES;//超出部分裁减掉
    [self.contentView addSubview:userImage];
    
    //昵称
    nickNameLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    nickNameLabel.backgroundColor=[UIColor clearColor];
    nickNameLabel.font=[UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:nickNameLabel];
    
    //转发数
    repostCountLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    repostCountLabel.font=[UIFont systemFontOfSize:12.0f];
    repostCountLabel.backgroundColor=[UIColor clearColor];
    repostCountLabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:repostCountLabel];
    
    //评论数
    commentCountLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    commentCountLabel.font=[UIFont systemFontOfSize:12.0f];
    commentCountLabel.backgroundColor=[UIColor clearColor];
        commentCountLabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:commentCountLabel];

    //微博发布时间
    creatDateLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    creatDateLabel.font=[UIFont systemFontOfSize:12.0f];
    creatDateLabel.backgroundColor=[UIColor clearColor];
    creatDateLabel.textColor=[UIColor blueColor];
    [self.contentView addSubview:creatDateLabel];
    
    //微博发布来源
    sourceLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    sourceLabel.font=[UIFont systemFontOfSize:12.0f];
    sourceLabel.backgroundColor=[UIColor clearColor];
    sourceLabel.textColor=[UIColor blueColor];
    [self.contentView addSubview:sourceLabel];
    
 
    
    //微博视图
    _weiboView=[[WeiboView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //-----------用户头像视图_userImage--------
    userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [userImage sd_setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:[UIImage imageNamed:@"btn_map_location.png"]];

    
    //昵称_nickLabel
    nickNameLabel.frame = CGRectMake(50, 0, 200, 20);
    nickNameLabel.text = _weiboModel.user.screen_name;
    
    //微博发布时间
    creatDateLabel.frame=CGRectMake(50, 25, 100, 15);
    NSString *data=[UIUtils fomateString:_weiboModel.created_at];
    creatDateLabel.text=data;
    
    //微博发布来源
    sourceLabel.frame=CGRectMake(160, 25, 150, 15);
    sourceLabel.text=[UIUtils spilt:_weiboModel.source];
    //微博视图_weiboView
    _weiboView.weiboModel = _weiboModel;
    CGFloat h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(10, nickNameLabel.bottom+20, kWeibo_Width_List, h);
    
    //转发数
    repostCountLabel.frame=CGRectMake(20, _weiboView.bottom+20, 60, 20);
    repostCountLabel.text=[[NSString alloc] initWithFormat:@"转发%@",_weiboModel.reposts_count];
    //评论数
    commentCountLabel.frame=CGRectMake(150, _weiboView.bottom+20, 60, 20);
    commentCountLabel.text=[[NSString alloc]initWithFormat:@"评论%@",_weiboModel.comments_count];

}


@end
