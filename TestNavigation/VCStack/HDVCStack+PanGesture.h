//
//  HDVCStack+PanGesture.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/21.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDVCStack.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HDVCStackPanGestureBlock) (void);
@interface HDVCStack (PanGesture)
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, copy, nullable) HDVCStackPanGestureBlock successBlock;

// 手势操作
- (void)pangestureWithView:(UIView *)view completeHandle:(void(^)(void))completeHandle;
@end

NS_ASSUME_NONNULL_END
