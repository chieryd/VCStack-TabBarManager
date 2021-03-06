//
//  UIViewController+NavigationBar.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/18.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDDefaultNaviBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (NavigationBar)
- (HDDefaultNaviBar *)defaultBar;
@end

NS_ASSUME_NONNULL_END
