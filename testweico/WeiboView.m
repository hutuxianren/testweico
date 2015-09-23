
//  WeiboView.m
//  testweico
//
//  Created by luluteam on 15/9/16.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import "WeiboView.h"
//#import "RTLabel.h"
#import <CoreText/CoreText.h>
#import "UIViewExt.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+WebCache.h>
#import "RegexKitLite.h"
#define LIST_FONT   14.0f           //列表中文本字体
#define LIST_REPOST_FONT  13.0f;    //列表中转发的文本字体
#define DETAIL_FONT  18.0f          //详情的文本字体
#define DETAIL_REPOST_FONT 17.0f    //详情中转发的文本字体
@implementation WeiboView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        [self initView];
        _parseText=[NSMutableString string];
        _imageViews=[NSMutableArray array];
    }
    return  self;
}
-(void)initView
{
    _rcTextLabel=[[RCLabel alloc]initWithFrame:CGRectZero];
        _rcTextLabel.delegate=self;
    _rcTextLabel.font=[UIFont systemFontOfSize:14.0f];

    [self addSubview:_rcTextLabel];
 
//    _textLabel=[[RTLabel alloc]initWithFrame:CGRectZero];
//    _textLabel.delegate=self;
//    _textLabel.font=[UIFont systemFontOfSize:14.0f];
//    _textLabel.linkAttributes=[NSDictionary dictionaryWithObject:@"green" forKey:@"color"];
//    _textLabel.selectedLinkAttributes=[NSDictionary dictionaryWithObject:@"red" forKey:@"color"];
//    [self addSubview:_textLabel];
    
    //微博图片
    _photoView = [[PhotoView alloc] initWithFrame:CGRectZero];
    [self addSubview:_photoView];

    
    
    //转发的背景视图
    repostBackgroundView.image=[UIImage imageNamed:@"timeline_retweet_background.png"];
    UIImage *repostImage=[repostBackgroundView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    repostBackgroundView.image=repostImage;
    [self insertSubview:repostBackgroundView atIndex:0];
}
//创建转发视图
-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    if(_weiboModel!=weiboModel)
    {
        _weiboModel=weiboModel;
    }
    if(_repostView==nil)
    {
    _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
    _repostView.isRepost = YES;
    [self addSubview:_repostView];
    }

    [self parseLink];
}

-(void)parseLink
{
    [_parseText setString:@""];
    NSString *regex=@"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    NSString *userName=@"";
    if (_isRepost) {
        
        userName= _weiboModel.user.screen_name;
        if(userName!=nil)
        {
        userName=[NSString stringWithFormat:@"<a href='userName://%@'>@%@</a>:",userName,userName];
        }
        else
        {
            userName=@"";
        }
        //[_parseText appendString:@"@"];
    }
    [_parseText appendString:userName];
    NSString *text=_weiboModel.text;

    NSArray *array=[text componentsMatchedByRegex:regex];
    for(NSString *part in array)
    {
       // NSLog(@"%@",part);
        NSString *repels=nil;
        //@对象
        if([part hasPrefix:@"@"])
        {
            repels=[NSString stringWithFormat:@"<a href='user://'>%@</a>",part];
        }
        //网址
        else if([part hasPrefix:@"http"])
        {
            repels=[NSString stringWithFormat:@"<a href='http://%@'>%@</a>",part,part];
        }
        //话题
        else if([part hasPrefix:@"#"])
        {
            repels=[NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",part,part];
        }
        
        if(repels!=nil)
        {
           text= [text stringByReplacingOccurrencesOfString:part withString:repels];
        }
    }
    [_parseText appendString:text];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //-----------1⃣️微博内容
   CGFloat fontSize=[WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
      _rcTextLabel.font=[UIFont systemFontOfSize:fontSize];
    _rcTextLabel.frame=CGRectMake(0, 10, self.width, 20);
    //当前视图是转发微博的视图
    if(self.isRepost)
    {
       _rcTextLabel.frame=CGRectMake(10, 10, self.width-20, 20);
    }
    _rcTextLabel.componentsAndPlainText=[RCLabel extractTextStyle:_parseText];
//    _textLabel.text=_parseText;
    _rcTextLabel.height=_rcTextLabel.optimumSize.height;
    
    //------------2⃣️转发的微博视图
    if(_weiboModel.retweeted_status)
    {
        _repostView.weiboModel=_weiboModel.retweeted_status;
       CGFloat height= [WeiboView getWeiboViewHeight:_repostView.weiboModel isRepost:YES isDetail:self.isDetail];
       _repostView.frame=CGRectMake(0, _rcTextLabel.bottom, self.width, height);
        _repostView.hidden=NO;
    }
    else
    {
        _repostView.hidden=YES;
    }
    
    //-------------3⃣️图片视图
        NSArray *picUrls=_weiboModel.pic_urls;

        NSUInteger picNums=picUrls.count;
    if(picNums>0)
    {
        _photoView.urls=picUrls;
        [_photoView setFrame:CGRectMake(10, _rcTextLabel.bottom + 5, 140, 220)];
        _photoView.hidden=NO;
    }
    else
    {
        _photoView.hidden=YES;
    }
    //--------------4⃣️转发的微博视图背景
    if(self.isRepost)
    {
        repostBackgroundView.frame=self.bounds;//布满整个转发视图
        repostBackgroundView.backgroundColor=[UIColor redColor];
        repostBackgroundView.hidden=NO;
    }
    else
    {
        repostBackgroundView.hidden=YES;
    }
    
    
}
//获得字体大小
+(CGFloat)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost
{
    CGFloat fontSize=14.0f;
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    }
    else if(!isDetail && isRepost) {
        return LIST_REPOST_FONT;
    }
    else if(isDetail && !isRepost) {
        return DETAIL_FONT;
    }
    else if(isDetail && isRepost) {
        return DETAIL_REPOST_FONT;
    }
    
    return fontSize;
}
//计算微博视图的高度
+(CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail
{
    CGFloat height=0;
    //——------------计算微博内容的高度
    RCLabel *textLabel=[[RCLabel alloc]initWithFrame:CGRectZero];
    CGFloat fontSize=[WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font=[UIFont systemFontOfSize:fontSize];
    if(isRepost)
    {
        textLabel.width-=20;
    }
    if(isDetail)
    {
        textLabel.width=kWeibo_Width_Detail;
    }
    else
    {
        textLabel.width=kWeibo_Width_List;
        
    }
    textLabel.componentsAndPlainText=[RCLabel extractTextStyle:weiboModel.text];
    //textLabel.text=weiboModel.text;
    height+=textLabel.optimumSize.height+5;
    
    //计算微博图片的高度
    NSArray *picUrls=weiboModel.pic_urls;
    NSUInteger picNums=picUrls.count;
    height += [PhotoView getHeight:picNums];
//    NSString *thumbnailImage = weiboModel.bmiddle_pic;
//    if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage])
//    {
//        height+=(80+10);
//    }
    //计算转发微博视图的高度
    if(weiboModel.retweeted_status!=nil)
    {
       CGFloat repostHeight= [WeiboView getWeiboViewHeight:weiboModel.retweeted_status isRepost:YES isDetail:isDetail];
        height+=(repostHeight);
    }
    if(isRepost==YES)
    {
        height+=(25);
    }
    return height;
    
}

#pragma mark -RCLabel delegate
-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSString *)url
{
    
}
@end
