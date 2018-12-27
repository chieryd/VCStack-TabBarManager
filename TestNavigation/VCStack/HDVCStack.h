//
//  HDNavigationController.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/14.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HDVCStackAnimationFunctions <NSObject>
- (void)pushWithWillShowVC:(UIViewController *)willShowVC
                 currentVC:(UIViewController *)currentVC
                completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);

- (void)popWithWillShowVC:(UIViewController *)willShowVC
                currentVC:(UIViewController *)currentVC
               completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);

@end

@protocol HDVCEnableDragBackProtocol <NSObject>
- (BOOL)enableDrag;
@end

@interface HDVCStackAnimation: NSObject <HDVCStackAnimationFunctions>
+ (instancetype)defaultAnimation;
@end

@interface HDVCStack : NSObject

@property (nonatomic, readonly, strong) NSMutableArray *vcArray;
@property (nonatomic, readonly, strong) UIViewController *rootViewController;
@property (nonatomic, readonly, strong) UIViewController *visibleVC;


+ (instancetype)shareInstance;
+ (void)pushto:(UIViewController *)vc animation:(NSObject<HDVCStackAnimationFunctions> *)animation;
+ (void)popWithAnimation:(NSObject<HDVCStackAnimationFunctions> *)animation;

@end
