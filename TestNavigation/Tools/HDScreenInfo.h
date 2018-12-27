//
//  HDScreenInfo.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/17.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDScreenInfo : NSObject
+ (CGFloat)width;
+ (CGFloat)height;
+ (CGFloat)statusBarHeight;
+ (CGFloat)navigationBarHeight;
@end

NS_ASSUME_NONNULL_END
