//
//  UIViewController+HDHideBottomBarWhenPushed.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "UIViewController+HDHideBottomBarWhenPushed.h"
#import <objc/runtime.h>

@implementation UIViewController (HDHideBottomBarWhenPushed)

- (void)setHdHideBottomBarWhenPushed:(BOOL)hdHideBottomBarWhenPushed {
    NSNumber *boolNumber = [NSNumber numberWithBool:hdHideBottomBarWhenPushed];
    objc_setAssociatedObject(self, @selector(hdHideBottomBarWhenPushed), boolNumber, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hdHideBottomBarWhenPushed {
    NSNumber *boolNumber = objc_getAssociatedObject(self, @selector(hdHideBottomBarWhenPushed));
    return boolNumber.boolValue;
}

@end
