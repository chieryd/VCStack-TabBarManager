//
//  UIViewController+NavigationBar.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/18.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "HDDefaultNaviBar.h"

@implementation UIViewController (NavigationBar)

- (HDDefaultNaviBar *)defaultBar {
    HDDefaultNaviBar *customerBar = [[HDDefaultNaviBar alloc] initWithFrame:CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.navigationBarHeight + HDScreenInfo.statusBarHeight)];
    customerBar.backgroundColor = [UIColor whiteColor];
    customerBar.title = @"测试title";
    customerBar.backIcon = [UIImage imageNamed:@"NaviBack"];
    customerBar.backAction = ^{
        [self.vcStack popWithAnimation:[HDVCStackAnimation defaultAnimation]];
    };
    return customerBar;
}

@end
