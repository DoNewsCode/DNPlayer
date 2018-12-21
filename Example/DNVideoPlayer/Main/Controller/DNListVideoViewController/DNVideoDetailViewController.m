//
//  DNVideoDetailViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/18.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoDetailViewController.h"
#import "DNDetailVideoListViewController.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>
#import <DNVideoPlayer/DNVideoPlaceHolderView.h>
#import <DNVideoPlayer/DNCustomDismissAnimator.h>
#import "DNVideoListTableViewItemCell.h"
@interface DNVideoDetailViewController ()

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, weak) DNDetailVideoListViewController *sourceTransitionVc;

@end

@implementation DNVideoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.tempView];
    self.closeBtn.top = 44;
    self.closeBtn.left = 15;
    self.closeBtn.size = CGSizeMake(45, 45);
    self.tempView.frame = CGRectMake(0, TGNavHeight, ScreenWidth, ScreenWidth*9 / 16);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.backgroundColor = [UIColor redColor];
        [_closeBtn setImage:[UIImage imageNamed:@"lightGray_backBtn"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)tempView
{
    if (!_tempView) {
        _tempView = [UIView new];
        _tempView.backgroundColor = [UIColor redColor];
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
    //记录上层控制器
    self.sourceTransitionVc = (DNDetailVideoListViewController *)animator.sourceTransition;
    self.sourceView = sourceView;
    [self.tempView addSubview:self.sourceView];
    self.sourceView.frame = self.tempView.bounds;
    //播放器开始播放视频
    if (![DNPlayer sharedDNPlayer].isPlaying) {
        DNVideoPlaceHolderView *holderView = (DNVideoPlaceHolderView *)sourceView;
        if (holderView.placeHolderPlayBtnClickBlock) {
            holderView.placeHolderPlayBtnClickBlock(nil);
        }
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"parent = %@",parent);
    //push进来会调用 parent 不为空
    //pop回上一页面会调用 parent 为空
    if (parent == nil) {
        NSLog(@"%@",self.sourceView);
        //让sourceView复原
        NSIndexPath *selectedIndexPath = [self.sourceTransitionVc.videoListTableView indexPathForSelectedRow];
        //播放器视图放回原Cell sourceView暂时定为播放器
        DNVideoListTableViewItemCell *cell = (DNVideoListTableViewItemCell *)[self.sourceTransitionVc.videoListTableView cellForRowAtIndexPath:selectedIndexPath];
        [cell addSubview:self.sourceView];
        self.sourceView.alpha = 0;
        self.sourceView.top = 0;

        [UIView animateWithDuration:0.6 animations:^{
            self.sourceView.alpha = 1;
        }];

    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置顶部状态栏颜色 -- 白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

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
