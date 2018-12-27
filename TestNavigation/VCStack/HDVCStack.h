//
//  HDNavigationController.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/14.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDVCStackAnimationProtocol.h"
@class HDTabBarManager;

@interface HDVCStack : NSObject

/**
 当前堆栈中存在的所有的viewController
 */
@property (nonatomic, readonly, strong) NSMutableArray *viewControllers;

/**
 根节点
 */
@property (nonatomic, readonly, strong) UIViewController *rootViewController;

/**
 当前可视viewController
 */
@property (nonatomic, readonly, strong) UIViewController *visibleViewController;

/**
 上层控制器容器，tabBarManager
 */
@property (nonatomic, weak) HDTabBarManager *tabBarManager;

/**
 当前VCStack的唯一标识，在tabBarManager结合的时候使用
 */
@property (nonatomic, readonly, strong) NSString *identifier;

/**
 给定一个rootViewController,用作配置

 @param viewController rootVC
 */
- (instancetype)initWithRootViewController:(UIViewController *)viewController;

/**
 给定一个rootViewController和一个唯一标识（在tabBarmanager结合的时候使用）,用作配置

 @param viewController rootVC
 @param identifier 唯一标识
 */
- (instancetype)initWithRootViewController:(UIViewController *)viewController
                      andVCStackIdentifier:(NSString *)identifier;

/**
 push 操作，向当前堆栈中r压入一个对象

 @param vc 即将被入栈的viewController
 @param animation 入栈动画
 */
- (void)pushto:(UIViewController *)vc
     animation:(NSObject<HDVCStackAnimationProtocol> *)animation;

/**
 出栈操作

 @param animation 出栈动画
 */
- (void)popWithAnimation:(NSObject<HDVCStackAnimationProtocol> *)animation;

/**
 出栈到根节点操作

 @param animation 出栈动画类型
 */
- (void)popToRootViewControllerWithAnimation:(NSObject<HDVCStackAnimationProtocol> *)animation;

/**
 出栈到指定的vc操作，匹配条件是当前的vc名称

 @param vcName 即将要显示的vc名称
 @param popAnimation 出栈动画
 */
- (void)popToVCWithName:(NSString *)vcName
    animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation;

/**
 出栈到指定的vc,匹配条件是实例对象的id指针是否相等

 @param vc 即将要显示的vc实例
 @param popAnimation 出栈动画
 @param popCompletion 操作完成之后的回调，主要用于pop then push这种操作
 */
- (void)popTo:(UIViewController *)vc
    animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation
popCompleteHandle:(void (^)(BOOL))popCompletion;

/**
 出栈到指定的vc名称，之后再压栈到一个的vc

 @param popVCName 即将在栈顶出现的vc名称
 @param popAnimation 出栈动画
 @param pushVC 即将压栈的vc实例
 @param pushAnimation 压栈动画
 */
- (void)popToVCWithName:(NSString *)popVCName
              animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation
             thenPushTo:(UIViewController *)pushVC
              animation:(NSObject<HDVCStackAnimationProtocol> *)pushAnimation;

/**
 出栈到指定的vc实例，之后再压栈到一个的vc

 @param popVC 即将在栈顶出现的vc名称
 @param popAnimation 出栈动画
 @param pushVC 即将压栈的vc实例
 @param pushAnimation 压栈动画
 */
- (void)popTo:(UIViewController *)popVC
    animation:(NSObject<HDVCStackAnimationProtocol> *)popAnimation
   thenPushTo:(UIViewController *)pushVC
    animation:(NSObject<HDVCStackAnimationProtocol> *)pushAnimation;

@end
