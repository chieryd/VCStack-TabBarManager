//
//  HDVCStackAnimation.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/17.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDVCStackAnimation.h"
#import "HDScreenInfo.h"

@implementation HDVCStackAnimation
+ (instancetype)defaultAnimation {
    return [HDVCStackAnimation new];
}

- (void)pushWithWillShowVC:(UIViewController *)willShowVC
                 currentVC:(UIViewController *)currentVC
                completion:(void (^)(BOOL))completion {
    // 动画开始前的UI效果
    willShowVC.view.frame = CGRectMake(HDScreenInfo.width, 0, HDScreenInfo.width, HDScreenInfo.height);
    [UIView animateWithDuration:0.34 animations:^{
        willShowVC.view.frame = CGRectMake(HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
        currentVC.view.frame = CGRectMake(- HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
    } completion:^(BOOL finished) {
        if (finished) {
            /* 将对应View的frame还原
             保持和无动画的逻辑对应
             同时保证在UI调试时的正确性
             */
            willShowVC.view.frame = CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.height);
            currentVC.view.frame = CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.height);
        }
        completion(finished);
    }];
}

- (void)popWithWillShowVC:(UIViewController *)willShowVC
                currentVC:(UIViewController *)currentVC
               completion:(void (^)(BOOL))completion {
    // 动画开始前的UI效果
    willShowVC.view.frame = CGRectMake(- HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
    currentVC.view.frame = CGRectMake(HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
    [UIView animateWithDuration:0.34 animations:^{
        willShowVC.view.frame = CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.height);
        currentVC.view.frame = CGRectMake(HDScreenInfo.width, 0, HDScreenInfo.width, HDScreenInfo.height);
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}


@end
