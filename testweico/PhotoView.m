//
//  PhotoView.m
//  testweico
//
//  Created by luluteam on 15/9/22.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import "PhotoView.h"
#import "UIImageView+WebCache.h"
@implementation PhotoView
CGFloat width = 50.0f;
CGFloat height = 50.0f;
CGFloat margin = 5.0f;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

-(void)layoutSubviews
{
    NSUInteger count=self.urls.count;
    if(count==0)
    {
        return;
    }
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }

    UIImage *image = [UIImage imageNamed:@"timeline_image_loading@2x.png"];
    NSUInteger column = 0;
    NSUInteger row = 0;
    int columnCount = (count > 4 ? 3 : 2);
    for (int i = 0; i < count; i++) {


//                    NSUInteger X=i%3;
//                    NSUInteger Y=0;
//                   if (i<=2) {
//                        Y=0;
//                    }
//                    else if(i<=5)
//                    {
//                        Y=1;
//                    }
//                    else
//                    {
//                        Y=2;
//                    }
//
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.frame =CGRectMake(50*X, 25+50*Y, 50, 50);
        row = i / columnCount;
        column = i % columnCount;
        
        CGFloat x = column * (width + margin);
        CGFloat y = row * (height + margin);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(x, y, width, height);
        [imageView sd_setImageWithURL:[[self.urls objectAtIndex:i] objectForKey:@"thumbnail_pic"] placeholderImage:image];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
}

#pragma mark - Public Methods
+ (CGFloat)getHeight:(NSUInteger)count
{
    if (count > 4) {
        return (count + 1) / 3 * 55;
    }
    return (count + 1) / 2 * 55;
}

#pragma mark - Setting Methods
- (void)setUrls:(NSArray *)urls
{
    if (_urls != urls) {
        _urls = urls;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}
@end
