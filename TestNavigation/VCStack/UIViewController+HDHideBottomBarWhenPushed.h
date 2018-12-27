//
//  UIViewController+HDHideBottomBarWhenPushed.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HDHideBottomBarWhenPushed)

/**
 压栈的时候是否需要隐藏底部的tabbar
 */
@property (nonatomic, assign) BOOL hdHideBottomBarWhenPushed;

@end

NS_ASSUME_NONNULL_END
