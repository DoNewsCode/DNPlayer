//
//  DNBottomWebViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/12.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNBottomWebViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DNBottomWebMainView.h"

@interface DNBottomWebViewController ()
@property (nonatomic, strong) DNBottomWebMainView *mainView;

@end


@implementation DNBottomWebViewController

- (void)dealloc
{
    NSLog(@"%@释放了",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.view.backgroundColor = [UIColor clearColor];

    self.mainView = [DNBottomWebMainView bottomWebMainViewWithFrame:self.view.bounds];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view = self.mainView;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (BOOL)fd_prefersNavigationBarHidden
{
    return YES;
}


- (BOOL)shouldAutorotate
{
    return NO;
}
@end
