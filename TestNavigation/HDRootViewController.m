//
//  HDRootViewController.m
//  TestNavigation
//
//  Created by HanDong Wang on 2018/12/14.
//  Copyright © 2018 HanDong Wang. All rights reserved.
//

#import "HDRootViewController.h"
#import "HDSubViewController.h"
#import "HDVCStack.h"
#import "HDVCStackAnimation.h"

@interface HDRootViewController ()

@end

@implementation HDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"点击跳转" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)clickButton {
    HDSubViewController *vc = [[HDSubViewController alloc] init];
    [self.vcStack pushto:vc animation:[HDVCStackAnimation defaultAnimation]];
}

// 测试生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end
