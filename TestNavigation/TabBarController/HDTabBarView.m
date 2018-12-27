//
//  HDTabBarView.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/24.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDTabBarView.h"

@implementation HDTabBarView

- (instancetype)initWithItems:(NSArray<__kindof HDTabBarItemInfo *> *)items andFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutWithItems:items];
    }
    return self;
}

- (void)clickAction:(UIControl *)control {
    if (self.clickHandle) {
        self.clickHandle(control.tag);
    }
}

- (void)layoutWithItems:(NSArray<__kindof HDTabBarItemInfo *> *)items {
    // 移除当前view的所有的subViews
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 做数量上的限制，最多不超过五个
    NSAssert(items.count <= 5, @"元素过多，请重新设置");
    
    // item 宽度
    CGFloat itemWidth = HDScreenInfo.width / items.count;
    
    for (NSInteger i = 0; i < items.count; i ++) {
        HDTabBarItemInfo *info = items[i];
        // 通过UIControl接受手势
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 44)];
        control.tag = i;
        [control addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, itemWidth, 16)];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.textColor = [UIColor blackColor];
        titleView.font = [UIFont systemFontOfSize:12];
        titleView.text = info.title;
        [control addSubview:titleView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, 20, 20)];
        imageView.center = CGPointMake(itemWidth / 2.0, 30);
        imageView.clipsToBounds = YES;
        imageView.image = info.itemImage;
        [control addSubview:imageView];
        
        [self addSubview:control];
    }
}

@end
