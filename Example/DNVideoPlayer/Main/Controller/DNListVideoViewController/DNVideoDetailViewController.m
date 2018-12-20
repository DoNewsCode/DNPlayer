//
//  DNVideoDetailViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/18.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoDetailViewController.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>
@interface DNVideoDetailViewController ()

@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation DNVideoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.tempView];
    self.closeBtn.top = TGStatuBarHeight;
    self.closeBtn.left = 15;
    self.closeBtn.size = CGSizeMake(45, 45);
    self.tempView.frame = CGRectMake(0, TGNavHeight, ScreenWidth, ScreenWidth*9 / 16);
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.backgroundColor = [UIColor redColor];
        [_closeBtn addTarget:self action:@selector(closeBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)tempView
{
    if (!_tempView) {
        _tempView = [UIView new];
//        _tempView.backgroundColor = [UIColor redColor];
    }
    return _tempView;
}

- (void)closeBtnClickAction
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (CGRect)transitionDestinationViewFrame
{
    return self.tempView.frame;
}

- (UIView *)transitionSourceView
{
    return self.tempView;
}

- (void)customTransitionAnimator:(nonnull DNCustomAnimator *)animator
           didCompleteTransition:(BOOL)didComplete
             animatingSourceView:(nonnull UIView *)sourceView;
{
//    self.tempView.backgroundColor = sourceView.backgroundColor;
    self.tempView = sourceView;
//    self.tempView.alpha = 1;
}

- (BOOL)fd_prefersNavigationBarHidden
{
    return YES;
}

@end
