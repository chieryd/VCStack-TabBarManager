//
//  HDModelAnimation.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/25.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDModelAnimation.h"

@implementation HDModelAnimation
+ (instancetype)defaultAnimation {
    return [HDModelAnimation new];
}

- (void)pushWithWillShowVC:(UIViewController *)willShowVC
                 currentVC:(UIViewController *)currentVC
                completion:(void (^)(BOOL))completion {
    // 动画开始前的UI效果
    willShowVC.view.frame = CGRectMake(0, HDScreenInfo.height, HDScreenInfo.width, HDScreenInfo.height);
    [UIView animateWithDuration:0.34 animations:^{
        willShowVC.view.frame = CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.height);
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)popWithWillShowVC:(UIViewController *)willShowVC
                currentVC:(UIViewController *)currentVC
               completion:(void (^)(BOOL))completion {
    // 动画开始前的UI效果
    [UIView animateWithDuration:0.34 animations:^{
        currentVC.view.frame = CGRectMake(0, HDScreenInfo.height, HDScreenInfo.width, HDScreenInfo.height);
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

@end
