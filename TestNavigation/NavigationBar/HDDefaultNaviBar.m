//
//  HDDefaultNaviBar.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/18.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDDefaultNaviBar.h"

@interface HDDefaultNaviBar ()
@end

@implementation HDDefaultNaviBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 这里什么都不用做
    }
    return self;
}

#pragma mark - Setter
- (void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    [self layoutWithData];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self layoutWithData];
}

- (void)setBackIcon:(UIImage *)backIcon {
    _backIcon = backIcon;
    [self layoutWithData];
}

- (void)layoutWithData {
    // 这里开始布局整体的UI, 首先移除所有的subView
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 设置返回按钮
    UIButton *backButton = [self backButton];
    [self addSubview:backButton];
    backButton.frame = CGRectMake(20, HDScreenInfo.statusBarHeight, 44, 44);
    if (self.backIcon) {
        [backButton setImage:self.backIcon forState:UIControlStateNormal];
    }
    else {
        [backButton setTitle:@"<" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    // 设置titleView
    if (self.titleView) {
        self.titleView.frame = CGRectMake(0, 0, [self.titleView intrinsicContentSize].width, [self.titleView intrinsicContentSize].height);
        self.titleView.center = CGPointMake(self.center.x, HDScreenInfo.statusBarHeight + 22);
        [self addSubview:self.titleView];
    }
    else {
        UILabel *defaultTitleView = [self defaultTitleView];
        defaultTitleView.text = self.title;
        if (self.title && self.title.length > 0) {
            CGSize titleSize = [self.title sizeWithFont:[UIFont systemFontOfSize:18] andBoundSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            defaultTitleView.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
        }
        defaultTitleView.center = CGPointMake(self.center.x, HDScreenInfo.statusBarHeight + 22);
        [self addSubview:defaultTitleView];
    }
}

- (void)backActionClick {
    if (self.backAction) {
        self.backAction();
    }
}

- (UILabel *)defaultTitleView {
    UILabel *defaultTitleView = [UILabel new];
    defaultTitleView = [UILabel new];
    defaultTitleView.backgroundColor = [UIColor clearColor];
    defaultTitleView.font = [UIFont systemFontOfSize:18];
    defaultTitleView.textColor = [UIColor blackColor];
    return defaultTitleView;
}

- (UIButton *)backButton {
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(backActionClick) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
