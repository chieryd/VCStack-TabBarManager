//
//  HDTabBarItemInfo.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDTabBarItemInfo : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *itemImage;
- (instancetype)initWithTitle:(NSString *)title itemImage:(UIImage *)itemImage;
@end

NS_ASSUME_NONNULL_END
