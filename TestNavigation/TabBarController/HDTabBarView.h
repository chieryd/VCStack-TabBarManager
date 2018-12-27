//
//  HDTabBarView.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTabBarItemInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HDTabBarClick) (NSInteger index);
@interface HDTabBarView : UIView

/**
 点击回调
 */
@property (nonatomic, copy) HDTabBarClick clickHandle;

/**
 根据给定的信息，初始化函数

 @param items 给定的元素信息
 @param frame 给定尺寸
 @return 当前实例
 */
- (instancetype)initWithItems:(NSArray <__kindof HDTabBarItemInfo *> *)items
                     andFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
