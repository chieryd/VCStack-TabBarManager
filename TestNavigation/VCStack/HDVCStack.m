//
//  HDNavigationController.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/14.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDVCStack.h"
#import "HDRootViewController.h"
#import "HDScreenInfo.h"
#import "HDVCStackPanProtocol.h"
#import "HDVCStack+PanGesture.h"
#import "HDTabBarManager.h"

@interface HDVCStack ()
@property (nonatomic, readwrite, strong) NSMutableArray *viewControllers;
@property (nonatomic, readwrite, strong) UIViewController *visibleViewController;
@property (nonatomic, readwrite, strong) UIViewController *rootViewController;
@property (nonatomic, readwrite, strong) NSString *identifier;
@end

@implementation HDVCStack

- (instancetype)initWithRootViewController:(UIViewController *)viewController {
    return [self initWithRootViewController:viewController andVCStackIdentifier:nil];
}

- (instancetype)initWithRootViewController:(UIViewController *)viewController
              andVCStackIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        _rootViewController = viewController;
        _identifier = identifier;
        self.visibleViewController = _rootViewController;
        viewController.vcStack = self;
        [self.viewControllers addObject:viewController];
    }
    return self;
}

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray new];
    }
    return _viewControllers;
}

// 模拟左滑手势的处理，如果用户实现了协议，且标明不使用左滑手势，则不增加手势选项，否则默认是增加的
- (void)panGestureWithView:(UIViewController *)vc {
    if ([vc conformsToProtocol:@protocol(HDVCEnableDragBackProtocol)] &&
        [vc respondsToSelector:@selector(enableDrag)] &&
        [(UIViewController <HDVCEnableDragBackProtocol> *)vc enableDrag] == NO) {
        // 这里什么都不做
        return;
    }
    // 添加拖动手势的操作
    
    [self pangestureWithView:vc.view completeHandle:^() {
        if ([self.viewControllers count] > 1) {
            // 底部的vc
            UIViewController *bottomVC = self.viewControllers[self.viewControllers.count - 2];
            // 当前显示的vc
            UIViewController *currentVC = self.visibleViewController;
            
            if (bottomVC && currentVC) {
                // 当前禁止任何手势
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                
                [bottomVC viewWillAppear:true];
                [currentVC viewWillDisappear:true];
                [UIView animateWithDuration:0.34 animations:^{
                    currentVC.view.frame = CGRectMake(HDScreenInfo.width, 0, HDScreenInfo.width, HDScreenInfo.height);
                    bottomVC.view.frame = CGRectMake(0, 0, HDScreenInfo.width, HDScreenInfo.height);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [currentVC.view removeFromSuperview];
                        [currentVC viewDidDisappear:true];
                        currentVC.vcStack = nil;
                        [bottomVC viewDidAppear:true];
                        self.visibleViewController = bottomVC;
                        [[self viewControllers] removeLastObject];
                        // 手势禁用关闭
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    }
                }];
            }
        }
    }];
}

- (void)pushto:(UIViewController *)vc animation:(NSObject<HDVCStackAnimationProtocol> *)animation {
    // 添加手势处理
    [self panGestureWithView:vc];
    
    // 当前禁止任何手势
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.viewControllers addObject:vc];
    [vc viewWillAppear:false];
    [self.visibleViewController viewWillDisappear:false];
    [self.visibleViewController.view addSubview:vc.view];
    vc.vcStack = self;

    // 对底部的tabBar做层级操作
    if (vc.hdHideBottomBarWhenPushed) {
        // 这里什么都不做
        [self.tabBarManager.view bringSubviewToFront:vc.view];
    }
    
    if (animation) {
        // 动画开始
        [animation pushWithWillShowVC:vc currentVC:self.visibleViewController completion:^(BOOL finished) {
            if (finished) {
                [self.visibleViewController viewDidDisappear:true];
                [vc viewDidAppear:true];
                self.visibleViewController = vc;
                // 手势禁用关闭
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        }];
    }
    else {
        // 手势禁用关闭
        [self.visibleViewController viewDidDisappear:false];
        [vc viewDidAppear:false];
        self.visibleViewController = vc;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
}

// 提取出一些公共方法，减少代码的行数
- (void)popToVC:(UIViewController *)popToVC
      animation:(NSObject<HDVCStackAnimationProtocol> *)animation
  willDismissVC:(UIViewController *)willDismissVC {
    [self popToVC:popToVC
        animation:animation
    willDismissVC:willDismissVC
popCompleteHandle:nil];
}

- (void)popToVC:(UIViewController *)popToVC
      animation:(NSObject<HDVCStackAnimationProtocol> *)animation
  willDismissVC:(UIViewController *)willDismissVC
popCompleteHandle:(void (^)(BOOL))popCompletion {
    if (popToVC) {
        // 基础引用链
        willDismissVC.vcStack = nil;
        // 当前禁止任何手势
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        if (animation) {
            [popToVC viewWillAppear:true];
            [willDismissVC viewWillDisappear:true];
            [animation popWithWillShowVC:popToVC currentVC:willDismissVC
                              completion:^(BOOL finished) {
                                  if (finished) {
                                      [willDismissVC.view removeFromSuperview];
                                      [willDismissVC viewDidDisappear:true];
                                      [popToVC viewDidAppear:true];
                                      self.visibleViewController = popToVC;
                                      // 手势禁用关闭
                                      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                      // completion handle
                                      if (popCompletion) {
                                          popCompletion(finished);
                                      }
                                  }
                              }];
        }
        else {
            [popToVC viewWillAppear:false];
            [willDismissVC viewWillDisappear:false];
            [willDismissVC.view removeFromSuperview];
            [willDismissVC viewDidDisappear:false];
            [popToVC viewDidAppear:false];
            self.visibleViewController = popToVC;
            // 手势禁用关闭
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (popCompletion) {
                popCompletion(YES);
            }
        }
    }
    else {
        if (popCompletion) {
            popCompletion(NO);
        }
    }
}

- (void)popWithAnimation:(NSObject<HDVCStackAnimationProtocol> *)animation {
    if ([self viewControllers].count > 0) {
        [[self viewControllers] removeLastObject];
        UIViewController *willVisibleVC = [self viewControllers].lastObject;
        
        // 当前禁止任何手势
        [self popToVC:willVisibleVC animation:animation willDismissVC:self.visibleViewController];
    }
}

- (void)popToRootViewControllerWithAnimation:(NSObject<HDVCStackAnimationProtocol> *)animation {
    if ([self viewControllers].count > 0) {
        UIViewController *willVisibleVC = [self viewControllers].firstObject;
        
        // 将中间view全部删除
        for (NSInteger i = self.viewControllers.count - 1; i > 0; i--) {
            if (i == 0) {
                break;
            }
            UIViewController *vc = self.viewControllers[i];
            [vc viewWillDisappear:false];
            [vc.view removeFromSuperview];
            [vc viewDidDisappear:false];
            [self.viewControllers removeObjectAtIndex:i];
        }
        
        // 已出当前已经添加上的view
        if (willVisibleVC) {
            [willVisibleVC.view addSubview:self.visibleViewController.view];
        }
        
        // 当前禁止任何手势
        [self popToVC:willVisibleVC animation:animation willDismissVC:self.visibleViewController];
    }
}

- (UIViewController *)vcByName:(NSString *)vcName {
    if (self.viewControllers.count > 0) {
        for (UIViewController *vc in self.viewControllers) {
            if ([NSStringFromClass([vc class]) isEqualToString:vcName]) {
                return vc;
            }
        }
    }
    return nil;
}

- (void)popToVCWithName:(NSString *)vcName
              animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation {
    if ([self vcByName:vcName]) {
        [self popTo:[self vcByName:vcName] animation:popAnimation popCompleteHandle:nil];
    }
}

- (void)popTo:(UIViewController *)vc
    animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation
popCompleteHandle:(void (^)(BOOL))popCompletion {
    if (self.viewControllers.count > 0 &&
        [self.viewControllers containsObject:vc]) {
        UIViewController *willVisibleVC = vc;
        
        NSInteger willVisibleVCIndex = [self.viewControllers indexOfObject:vc];
        
        // 将中间view全部删除
        for (NSInteger i = self.viewControllers.count - 1; i > 0; i--) {
            if (i == willVisibleVCIndex) {
                break;
            }
            UIViewController *vc = self.viewControllers[i];
            [vc viewWillDisappear:false];
            [vc.view removeFromSuperview];
            [vc viewDidDisappear:false];
            [self.viewControllers removeObjectAtIndex:i];
        }
        
        // 已出当前已经添加上的view
        if (willVisibleVC) {
            [willVisibleVC.view addSubview:self.visibleViewController.view];
        }
        
        // 当前禁止任何手势
        [self popToVC:willVisibleVC animation:popAnimation willDismissVC:self.visibleViewController popCompleteHandle:popCompletion];
    }
    else {
        if (popCompletion) {
            popCompletion(NO);
        }
    }
}

- (void)popToVCWithName:(NSString *)popVCName
              animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation
             thenPushTo:(UIViewController *)pushVC
              animation:(NSObject<HDVCStackAnimationProtocol> *)pushAnimation {
    if ([self vcByName:popVCName]) {
        [self popTo:[self vcByName:popVCName]
          animation:popAnimation
         thenPushTo:pushVC
          animation:pushAnimation];
    }
}

- (void)popTo:(UIViewController *)popVC
    animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation
   thenPushTo:(UIViewController *)pushVC
    animation:(NSObject<HDVCStackAnimationProtocol> *)pushAnimation {
    [self popTo:popVC animation:popAnimation popCompleteHandle:^(BOOL finished) {
        if (finished) {
            [self pushto:pushVC animation:pushAnimation];
        }
    }];
}

@end
