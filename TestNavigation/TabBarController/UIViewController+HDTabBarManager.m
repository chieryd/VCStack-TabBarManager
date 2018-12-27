//
//  UIViewController+HDTabBarManager.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "UIViewController+HDTabBarManager.h"
#import <objc/runtime.h>

@implementation UIViewController (HDTabBarManager)

- (void)setTabBarManager:(HDTabBarManager *)tabBarManager {
    HDWeakWrapper *wrapper = nil;
    if (tabBarManager) {
        wrapper = [HDWeakWrapper new];
        wrapper.objc = tabBarManager;
    }
    objc_setAssociatedObject(self, @selector(tabBarManager), wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HDTabBarManager *)tabBarManager {
    HDWeakWrapper *wrapper = objc_getAssociatedObject(self, @selector(tabBarManager));
    return wrapper.objc;
}

@end
