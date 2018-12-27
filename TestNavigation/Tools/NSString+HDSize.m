//
//  NSString+HDSize.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/18.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "NSString+HDSize.h"

@implementation NSString (HDSize)
- (CGSize)sizeWithFont:(UIFont *)font andBoundSize:(CGSize)size {
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size;
}
@end
