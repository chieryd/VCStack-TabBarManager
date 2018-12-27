//
//  HDVCAnimationProtocol.h
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/17.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDVCStackAnimationProtocol <NSObject>
- (void)pushWithWillShowVC:(UIViewController *)willShowVC
                 currentVC:(UIViewController *)currentVC
                completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);

- (void)popWithWillShowVC:(UIViewController *)willShowVC
                currentVC:(UIViewController *)currentVC
               completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);

@end
