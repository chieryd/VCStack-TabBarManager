//
//  NSString+HDSize.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/18.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HDSize)
- (CGSize)sizeWithFont:(UIFont *)font andBoundSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
