//
//  HDModelAnimation.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/25.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDModelAnimation : NSObject <HDVCStackAnimationProtocol>
+ (instancetype)defaultAnimation;
@end

NS_ASSUME_NONNULL_END
