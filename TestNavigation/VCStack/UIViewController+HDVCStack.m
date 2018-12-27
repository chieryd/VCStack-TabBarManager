//
//  UIViewController+HDVCStack.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/21.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "UIViewController+HDVCStack.h"
#import <objc/runtime.h>

@implementation UIViewController (HDVCStack)

- (void)setVcStack:(HDVCStack *)vcStack {
    HDWeakWrapper *wrapper = nil;
    if (vcStack) {
        wrapper = [[HDWeakWrapper alloc] init];
        wrapper.objc = vcStack;
    }
    objc_setAssociatedObject(self, @selector(vcStack), wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HDVCStack *)vcStack {
    HDWeakWrapper *wrapper = objc_getAssociatedObject(self, @selector(vcStack));
    return wrapper.objc;
}

@end
