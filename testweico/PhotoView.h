//
//  PhotoView.h
//  testweico
//
//  Created by luluteam on 15/9/22.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView
@property(nonatomic,strong)NSArray *urls;//微博图片集合
+ (CGFloat)getHeight:(NSUInteger)count;
@end
