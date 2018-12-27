//
//  HDTabBarManager.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/21.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDVCStack.h"
#import "HDTabBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDTabBarManager : UIViewController

/**
 当前容器中的堆栈
 */
@property (nonatomic, strong) NSArray <HDVCStack *> *viewControllers;

/**
 选中的index
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 选中的堆栈
 */
@property (nonatomic,  strong, readonly) HDVCStack *selectedVCStack;

/**
 底部的tabBar按钮
 */
@property (nonatomic, strong) UIView *tabBarView;

/**
 通过idnetifier跳转到对应的VCStack

 @param identifier 唯一标识
 */
- (void)jumpToVCStackWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
