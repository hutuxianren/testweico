//
//  ViewController.h
//  testweico
//
//  Created by luluteam on 15/9/14.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
@interface ViewController : UIViewController<WBHttpRequestDelegate>
@property(nonatomic,strong)NSString *lastWeiboId;//最小的微博ID
@property(nonatomic,strong)NSString *topWeiboId;//最大的微博ID
@property(nonatomic,strong)NSMutableArray *fullWeibos;//完整的微博列表
@property(nonatomic)NSUInteger recordRequest;//记录不同请求的数据
@end

