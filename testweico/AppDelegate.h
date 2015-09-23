//
//  AppDelegate.h
//  testweico
//
//  Created by luluteam on 15/9/14.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *wbRefreshToken;



@end

