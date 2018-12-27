//
//  UIViewController+HDTabBarManager.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTabBarManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HDTabBarManager)

/**
 VC对当前tabBarManager的快捷访问
 */
@property (nonatomic, strong, nullable) HDTabBarManager *tabBarManager;

@end

NS_ASSUME_NONNULL_END
