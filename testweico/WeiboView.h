//
//  WeiboView.h
//  testweico
//
//  Created by luluteam on 15/9/16.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "RCLabel.h"
#import "PhotoView.h"
#define kWeibo_Width_List  300 //微博在列表中的宽度
#define kWeibo_Width_Detail 300     //微博在详情页面的宽度

@interface WeiboView : UIView<RTLabelDelegate>
{
@private
    RCLabel          *_rcTextLabel;
    UIImageView      *image;//微博图片
    UIImageView      *repostBackgroundView;//转发的视图
    PhotoView *_photoView;
}
@property(nonatomic,strong)WeiboModel *weiboModel;//微博模型对象
@property(nonatomic,strong)WeiboView  *repostView;//转发的微博视图
@property BOOL       isRepost;//当前微博是否转发
//微博视图是否显示在详情页面
@property(nonatomic,assign)BOOL isDetail;
@property(nonatomic,strong)NSMutableString *parseText;//替换为html的结果
//计算微博视图的高度
+(CGFloat)getWeiboViewHeight:(WeiboModel*)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail;
//获取字体大小
+(CGFloat)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;

@end
