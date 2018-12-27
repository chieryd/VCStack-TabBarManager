//
//  UIViewController+HDVCStack.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/21.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVCStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HDVCStack)

/**
 VC对当前stack的快捷访问
 */
@property (nonatomic, strong, nullable) HDVCStack *vcStack;

@end

NS_ASSUME_NONNULL_END
