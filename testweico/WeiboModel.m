//
//  WeiboModel.m
//  testweico
//
//  Created by luluteam on 15/9/15.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import "WeiboModel.h"
#import "UserModel.h"
/*
 @property(strong,nonatomic)NSString *created_at;//微博创建时间
 @property(strong,nonatomic)NSNumber* id;//微博ID
 @property(strong,nonatomic)NSString *text;//微博内容
 @property(strong,nonatomic)NSString *source;//微博来源
 @property(strong,nonatomic)NSNumber * favorited;//是否收藏
 @property(strong,nonatomic)NSString *thumbnail_pic;//微博图片缩略图片地址
 @property(strong,nonatomic)NSString *bmiddle_pic;//中等尺寸图片地址
 @property(strong,nonatomic)NSDictionary *geo;//地理信息字段
 @property(strong,nonatomic)WeiboModel * retweeted_status;//被转发的原微博信息字段
 @property(strong,nonatomic)NSNumber * reposts_count;//转发数
 @property(strong,nonatomic)NSNumber * comments_count;//评论数
 @property(strong,nonatomic)UserModel *user;//微博作者的用户信息字段
 
*/
@implementation WeiboModel
-(NSDictionary*)attributeMapDictionary
{
    NSDictionary *mapAtt=@{@"created_at":@"created_at",
                           @"id":@"id",
                           @"text":@"text",
                           @"source":@"source",
                           @"favorited":@"favorited",
                           @"thumbnail_pic":@"thumbnail_pic",
                           @"bmiddle_pic":@"bmiddle_pic",
                           @"original_pic":@"original_pic",
                           @"geo":@"geo",
                           @"reposts_count":@"reposts_count",
                           @"comments_count":@"comments_count",
                           @"pic_urls":@"pic_urls"
                           };
    return mapAtt;
}

-(void)setAttributes:(NSDictionary *)dataDic
{
    //将字典数据根据映射关系填充到当前对象的属性
    [super setAttributes:dataDic];
    NSDictionary *retweetDic=[dataDic objectForKey:@"retweeted_status"];
    if(retweetDic !=nil)
    {
    WeiboModel *retWeibo=[[WeiboModel alloc]initWithDataDic:retweetDic];
    self.retweeted_status=retWeibo;//将转发的字典给对应的model
    }
    
    NSDictionary *userDic=[dataDic objectForKey:@"user"];
    if(userDic!=nil)
    {
    UserModel *user=[[UserModel alloc]initWithDataDic:userDic];
    self.user=user;
    }
}
@end
