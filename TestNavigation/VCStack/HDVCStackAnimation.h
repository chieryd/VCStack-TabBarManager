//
//  HDVCStackAnimation.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/17.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDVCStackAnimationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDVCStackAnimation : NSObject <HDVCStackAnimationProtocol>
+ (instancetype)defaultAnimation;
@end

NS_ASSUME_NONNULL_END
