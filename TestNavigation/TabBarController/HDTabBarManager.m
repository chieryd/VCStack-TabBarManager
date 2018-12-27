//
//  HDTabBarManager.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/21.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDTabBarManager.h"

@interface HDTabBarManager ()
@property (nonatomic, strong) HDVCStack *currentVCStack;
@end

@implementation HDTabBarManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

/**
 初始化配置函数
 */
- (void)initSelf {
    self.selectedIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self relayout];
}

- (void)relayoutInMainThread {
    // 当前view中的childrenVC全部删除
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 将当前需要显示的vc添加到当前的视图中去
    if (self.viewControllers && self.viewControllers.count > self.selectedIndex) {
        // 拿到当前需要显示的vc
        HDVCStack *willShowVCStack = self.viewControllers[self.selectedIndex];
        if (willShowVCStack && willShowVCStack.rootViewController) {
            [self.view addSubview:willShowVCStack.rootViewController.view];
            self.currentVCStack = willShowVCStack;
        }
    }
    
    [self.view addSubview:self.tabBarView];
}

- (void)relayout {
    if ([NSThread isMainThread]) {
        [self relayoutInMainThread];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self relayoutInMainThread];
        });
    }
}

- (void)changeViewControllerInMainThread:(NSInteger)selectedIndex {
    // 找到即将显示的VCStack
    if (self.viewControllers && self.viewControllers.count > selectedIndex) {
        // 拿到当前需要显示的vc
        HDVCStack *willShowVCStack = self.viewControllers[selectedIndex];
        if (willShowVCStack && willShowVCStack.rootViewController && self.currentVCStack) {
            [willShowVCStack.visibleViewController viewWillAppear:false];
            [self.currentVCStack.visibleViewController viewWillDisappear:false];
            // 不在走removeFromSuperView逻辑，这个逻辑会默认走VC的生命周期
            self.currentVCStack.rootViewController.view.hidden = YES;
            [self.currentVCStack.visibleViewController viewDidDisappear:false];
            if (willShowVCStack.rootViewController.view.superview != nil) {
                willShowVCStack.rootViewController.view.hidden = NO;
                [self.view bringSubviewToFront:willShowVCStack.rootViewController.view];
            }
            else {
                [self.view addSubview:willShowVCStack.rootViewController.view];
            }
            
            // 将底部的布局移动到最上层
            [self.view bringSubviewToFront:self.tabBarView];
                        
            [willShowVCStack.visibleViewController viewDidAppear:false];
            self.currentVCStack = willShowVCStack;
        }
    }
    
}

- (void)changeViewController:(NSInteger)selectedIndex {
    if ([NSThread isMainThread]) {
        [self changeViewControllerInMainThread:selectedIndex];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self changeViewControllerInMainThread:selectedIndex];
        });
    }
}

- (void)addRefChain {
    for (HDVCStack *vcStack in self.viewControllers) {
        vcStack.tabBarManager = self;
    }
}

- (HDVCStack *)selectedVCStack {
    return self.currentVCStack;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex != _selectedIndex) {
        [self changeViewController:selectedIndex];
    }
    _selectedIndex = selectedIndex;
}

- (void)setViewControllers:(NSArray<HDVCStack *> *)viewControllers {
    _viewControllers = viewControllers;
    // 增加引用链
    [self addRefChain];
    // 刷新当前视图
    [self relayout];
}

- (void)setTabBarView:(UIView *)tabBarView {
    _tabBarView = tabBarView;
    if (_tabBarView.superview == nil) {
        [self.view addSubview:_tabBarView];
    }
    __weak typeof(self) weakSelf = self;
    ((HDTabBarView *)self.tabBarView).clickHandle = ^(NSInteger index){
        weakSelf.selectedIndex = index;
    };
}

- (void)jumpToVCStackWithIdentifier:(NSString *)identifier {
    BOOL vcExist = NO;
    NSInteger jumpIndex = 0;
    for (NSInteger index = 0; index < self.viewControllers.count; index ++) {
        HDVCStack *vcStack = self.viewControllers[index];
        if ([vcStack.identifier isEqualToString:identifier]) {
            vcExist = YES;
            jumpIndex = index;
            break;
        }
    }
    
    if (vcExist) {
        [self setSelectedIndex:jumpIndex];
    }
}

@end
