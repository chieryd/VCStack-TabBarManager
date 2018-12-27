//
//  HDScreenInfo.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/17.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDScreenInfo.h"

@implementation HDScreenInfo
+ (CGFloat)width {
    return UIScreen.mainScreen.bounds.size.width;
}

+ (CGFloat)height {
    return UIScreen.mainScreen.bounds.size.height;
}

+ (CGFloat)statusBarHeight {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGFloat)navigationBarHeight {
    return 44.0;
}

@end
