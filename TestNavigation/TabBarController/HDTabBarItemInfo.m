//
//  HDTabBarItemInfo.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDTabBarItemInfo.h"

@implementation HDTabBarItemInfo
- (instancetype)initWithTitle:(NSString *)title itemImage:(UIImage *)itemImage {
    if (self = [super init]) {
        self.title = title;
        self.itemImage = itemImage;
    }
    return self;
}
@end
