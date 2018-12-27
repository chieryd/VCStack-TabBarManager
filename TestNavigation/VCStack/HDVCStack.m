//
//  HDNavigationController.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/14.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDVCStack.h"
#import "HDRootViewController.h"

@interface HDScreenInfo: NSObject
+ (CGFloat)width;
+ (CGFloat)height;
@end

@implementation HDScreenInfo
+ (CGFloat)width {
    return UIScreen.mainScreen.bounds.size.width;
}

+ (CGFloat)height {
    return UIScreen.mainScreen.bounds.size.height;
}
@end

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

typedef void(^HDViewPanGestureBlock) (void);
@interface HDViewPanGesture : NSObject
@property (nonatomic, copy) HDViewPanGestureBlock successBlock;
+ (instancetype)shareInstance;
- (void)pangestureWithView:(UIView *)view completeHandle:(void(^)(void))completeHandle;
@end

@implementation HDViewPanGesture

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static HDViewPanGesture *__instance;
    dispatch_once(&onceToken, ^{
        __instance = [HDViewPanGesture new];
    });
    return __instance;
}

- (void)pangestureWithView:(UIView *)view completeHandle:(void (^)(void))completeHandle {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.successBlock = completeHandle;
    [view addGestureRecognizer:panGesture];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    // 当前正在拖动的view
    UIView *view = pan.view;
    // 即将要显示的View
    if (HDVCStack.shareInstance.vcArray.count > 1) {
        UIViewController *bottomViewController = HDVCStack.shareInstance.vcArray[HDVCStack.shareInstance.vcArray.count - 2];
        UIView *bottomView = bottomViewController.view;
        
        // 一些标记值
        static CGPoint startViewCenter;
        static CGPoint startBottomViewCenter;
        BOOL continueFlag = YES;
        
        if (view && bottomView) {
            // 拖动开始的检测
            if (pan.state == UIGestureRecognizerStateBegan) {
                // 拖动开始时View的frame需要先发生变化，保证和系统的UI风格统一
                bottomView.frame = CGRectMake(- HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
                view.frame = CGRectMake(HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
                // 检测当前的拖动的位置是否在合适的点，当前确立，view的左边1/3z位置可以作为触发的初始点
                CGPoint startPoint = [pan locationInView:view];
                if (startPoint.x > (view.frame.size.height / 4.0)) {
                    continueFlag = NO;
                }
                startViewCenter = view.center;
                startBottomViewCenter = bottomView.center;
            }
            else if (pan.state == UIGestureRecognizerStateChanged) {
                // 拿到对一个的偏移量
                CGPoint transition = [pan translationInView:view];
                view.center = CGPointMake(startViewCenter.x + transition.x / 3.0 * 2.0, startViewCenter.y);
                bottomView.center = CGPointMake(startBottomViewCenter.x + transition.x / 3.0, startBottomViewCenter.y);
            }
            else if (pan.state == UIGestureRecognizerStateEnded) {
                // 开始收尾动画
                if (view.center.x > (view.frame.size.width / 6.0 * 7.0)) {
                    if (self.successBlock) {
                        self.successBlock();
                    }
                }
                else {
                    // 禁止用户操作
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    // 还原到初始的位置
                    [UIView animateWithDuration:0.34 animations:^{
                        view.frame = CGRectMake(HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
                        bottomView.frame = CGRectMake(- HDScreenInfo.width / 3.0, 0, HDScreenInfo.width, HDScreenInfo.height);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            // 解开用户手势操作
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                            // 还原对象的位置
                            view.frame = CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.height);
                            bottomView.frame = CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.height);
                        }
                    }];
                }
            }
        }
    }
}
@end

@interface HDVCStack ()
@property (nonatomic, readwrite, strong) NSMutableArray *vcArray;
@property (nonatomic, readwrite, strong) UIViewController *visibleVC;
@property (nonatomic, readwrite, strong) UIViewController *rootViewController;

@property (nonatomic, strong) HDViewPanGesture *temp;
@end

@implementation HDVCStack

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static HDVCStack *__instance = nil;
    dispatch_once(&onceToken, ^{
        __instance = [[HDVCStack alloc] init];
    });
    return __instance;
}

- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [NSMutableArray new];
    }
    return _vcArray;
}

- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [[HDRootViewController alloc] init];
        self.visibleVC = _rootViewController;
        [self.vcArray addObject:_rootViewController];
    }
    return _rootViewController;
}

+ (void)pushto:(UIViewController *)vc animation:(NSObject<HDVCStackAnimationFunctions> *)animation {
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    // 添加拖动手势的操作
    [[HDViewPanGesture shareInstance] pangestureWithView:vc.view completeHandle:^() {
        if ([HDVCStack.shareInstance.vcArray count] > 1) {
            // 底部的vc
            UIViewController *bottomVC = HDVCStack.shareInstance.vcArray[HDVCStack.shareInstance.vcArray.count - 2];
            // 当前显示的vc
            UIViewController *currentVC = HDVCStack.shareInstance.visibleVC;
            
            if (bottomVC && currentVC) {
                // 当前禁止任何手势
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                
                [bottomVC viewWillAppear:true];
                [currentVC viewWillDisappear:true];
                [currentVC viewDidAppear:true];
                [UIView animateWithDuration:0.34 animations:^{
                    currentVC.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
                    bottomVC.view.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [currentVC viewDidDisappear:true];
                        [currentVC.view removeFromSuperview];
                        HDVCStack.shareInstance.visibleVC = bottomVC;
                        [[[HDVCStack shareInstance] vcArray] removeLastObject];
                        // 手势禁用关闭
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    }
                }];
            }
            
        }
        [UIView animateWithDuration:0.34 animations:^{
            vc.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }];
    // 当前禁止任何手势
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [HDVCStack.shareInstance.vcArray addObject:vc];
    [vc viewWillAppear:false];
    [HDVCStack.shareInstance.visibleVC viewWillDisappear:false];
    [HDVCStack.shareInstance.visibleVC.view addSubview:vc.view];
    [HDVCStack.shareInstance.visibleVC viewDidDisappear:false];
    [vc viewDidAppear:false];
    
    if (animation) {
        // 动画开始
        [animation pushWithWillShowVC:vc currentVC:HDVCStack.shareInstance.visibleVC completion:^(BOOL finished) {
            if (finished) {
                HDVCStack.shareInstance.visibleVC =  vc;
                // 手势禁用关闭
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        }];
    }
    else {
        // 手势禁用关闭
        HDVCStack.shareInstance.visibleVC =  vc;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
}

+ (void)popWithAnimation:(NSObject<HDVCStackAnimationFunctions> *)animation {
    if ([[HDVCStack shareInstance] vcArray].count > 0) {
        [[[HDVCStack shareInstance] vcArray] removeLastObject];
        UIViewController *willVisibleVC = [[HDVCStack shareInstance] vcArray].lastObject;
        
        // 当前禁止任何手势
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        if (willVisibleVC) {
            if (animation) {
                [willVisibleVC viewWillAppear:true];
                [[HDVCStack shareInstance].visibleVC viewWillDisappear:true];
                [willVisibleVC viewDidAppear:true];
                [animation popWithWillShowVC:willVisibleVC currentVC:HDVCStack.shareInstance.visibleVC
                                  completion:^(BOOL finished) {
                                      [HDVCStack.shareInstance.visibleVC viewDidDisappear:true];
                                      [HDVCStack.shareInstance.visibleVC.view removeFromSuperview];
                                      HDVCStack.shareInstance.visibleVC = willVisibleVC;
                                      // 手势禁用关闭
                                      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                  }];
            }
            else {
                [willVisibleVC viewWillAppear:false];
                [HDVCStack.shareInstance.visibleVC viewWillDisappear:false];
                [willVisibleVC viewDidAppear:false];
                [HDVCStack.shareInstance.visibleVC viewDidDisappear:false];
                [HDVCStack.shareInstance.visibleVC.view removeFromSuperview];
                [HDVCStack.shareInstance.visibleVC viewDidDisappear:false];
                HDVCStack.shareInstance.visibleVC = willVisibleVC;
                // 手势禁用关闭
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        }
    }
}

@end
