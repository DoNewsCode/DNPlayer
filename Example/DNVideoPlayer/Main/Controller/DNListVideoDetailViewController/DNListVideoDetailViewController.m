//
//  DNListVideoDetailViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/26.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNListVideoDetailViewController.h"
#import <DNCommonKit/UIView+Layout.h>
#import <DNVideoPlayer/DNVideoPlayerView.h>
#import <DNVideoPlayer/UIScrollView+DNListVideoPlayerAutoPlay.h>

#import "DNVideoListItemFrameModel.h"
#import "DNListVideoDetailTableViewCell.h"
#import "DNDetailVideoListViewController.h"

#import <DNVideoPlayer/DNVideoPlayerView.h>
#import <DNVideoPlayer/DNVideoPlaceHolderView.h>
#import <DNVideoPlayer/DNCustomDismissAnimator.h>
#import "UIButton+EdgeConfig.h"

#import "DNListVideoDetailCellFrameModel.h"
//#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>


@interface DNListVideoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray <DNListVideoDetailCellFrameModel *> *videoFrameModels;
@property (nonatomic, strong) UITableView *videoListTableView;
/// 记录当前播放的 Cell indexPath
@property (nonatomic, strong) DNPlayerControlViewConfig *playerControlViewConfig;
@property (nonatomic, strong) DNVideoPlayerView *videoPlayer;
/// 记录动画前的frame
@property (nonatomic, assign) CGRect markTempCellFrame;
/// 记录当前播放的 Cell indexPath
@property (nonatomic, readwrite, strong) NSIndexPath *markTempIndexPath;

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, weak) DNDetailVideoListViewController *sourceTransitionVc;
@end

@implementation DNListVideoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.videoListTableView];
    [self.view addSubview:self.tempView];

    adjustsScrollViewInsets_NO(self.videoListTableView, self);

    self.videoListTableView.frame = CGRectMake(0, NAV_BAR_Y, ScreenWidth, ScreenHeight - STATUS_BAR_H_Decide);
    self.tempView.frame = CGRectMake(0, NAV_BAR_Y, ScreenWidth, ScreenWidth*9 / 16);
//    self.videoListTableView.tableHeaderView = self.tempView;

    [self configPlayMode];

    self.closeBtn.ct_top = 44;
    self.closeBtn.ct_left = 15;
    self.closeBtn.ct_size = CGSizeMake(15, 25);


}


- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        //        _closeBtn.backgroundColor = [UIColor redColor];
        [_closeBtn setImage:[UIImage imageNamed:@"lightGray_backBtn"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn ca_setEnlargeEdge:10];

    }
    return _closeBtn;
}

- (UIView *)tempView
{
    if (!_tempView) {
        _tempView = [UIView new];
        _tempView.backgroundColor = [UIColor orangeColor];
    }
    return _tempView;
}

- (void)closeBtnClickAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configPlayMode
{
    [self.videoListTableView dn_disenableAutoplay];
}

#pragma mark - 过场动画
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
    self.videoListTableView.tableHeaderView = self.tempView;
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
        //        NSIndexPath *selectedIndexPath = [self.sourceTransitionVc.videoListTableView indexPathForSelectedRow];
        //播放器视图放回原Cell sourceView暂时定为播放器
        DNListVideoDetailTableViewCell *cell = (DNListVideoDetailTableViewCell *)[self.sourceTransitionVc.videoListTableView cellForRowAtIndexPath:self.sourceTransitionVc.markTempIndexPath];
        [cell addSubview:self.sourceView];
        self.sourceView.alpha = 0;
        self.sourceView.ct_top = 0;

        [UIView animateWithDuration:0.6 animations:^{
            self.sourceView.alpha = 1;
        }];

    }

}


- (void)dn_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{
    [self __playerNeedPlayNewAssetAtIndexPath:indexPath completeBlock:nil];
}


- (void)__playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath completeBlock:(void(^)(id sender))completeBlock
{
    @weakify(self)
    [self animateCurrentItemCellWithIndexPath:indexPath completion:^(BOOL finished) {
        @strongify(self)
        DNListVideoDetailTableViewCell *cell = [self.videoListTableView cellForRowAtIndexPath:indexPath];

        //播放的Cell相同--是否正在播放(根据模型判断.若当前播放的视频模型相同)
        if ([indexPath isEqual:self.markTempIndexPath])
        {
            if (completeBlock) {completeBlock(nil);}
            return ;
        }


        self.markTempIndexPath = indexPath;

        if ( self->_videoPlayer &&
            !self->_videoPlayer.isFullScreen ) {
            // 有播放器或者小窗播放 -- 播放新的视频(先让旧的播放器淡出,然后在播放)
            [self->_videoPlayer stopAndFadeOutCompletion:^(UIView *view) {
                //让旧的播放器淡出
                @strongify(self)
                [self playNewVideoWithCell:cell indexPath:indexPath completeBlock:completeBlock];
            }];

        }else{
            //初次播放
            [self playNewVideoWithCell:cell indexPath:indexPath completeBlock:completeBlock];

        }
    }];

}

- (void)playNewVideoWithCell:(DNListVideoDetailTableViewCell *)cell indexPath:(NSIndexPath *)indexPath completeBlock:(void(^)(id sender))completeBlock
{
    // 创建播放器
    _videoPlayer = [DNVideoPlayerView dnVideoPlayerViewWithDelegate:self];
    // 播放器控制层配置
    _videoPlayer.controlViewConfig = self.playerControlViewConfig;

    ///添加播放器容器视图
//    [cell.videoPlaceHolderView addSubview:_videoPlayer.containerView];
    _videoPlayer.containerView.ct_top = 0;
    _videoPlayer.containerView.ct_left= 0;
    _videoPlayer.containerView.ct_size = CGSizeMake(ScreenWidth, ScreenWidth *9 /16);


    _videoPlayer.isAnimateShowContainerView = YES;

}

- (void)dnVodPlayerDisappearScrollViewAction:(DNVideoPlayerView *)playerView
{
    [self.videoPlayer stopAndFadeOutCompletion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DNListVideoDetailTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)animateCurrentItemCellWithIndexPath:(NSIndexPath *)indexPath completion:(void (^ __nullable)(BOOL finished))completion
{

//    DNListVideoDetailCellFrameModel *frameModel= self.videoFrameModels[indexPath.row];
//    if (frameModel.isSelected) {
//        if (completion) {completion(nil);}
//        return;
//    }


//    frameModel.isSelected = YES;

//    [self.videoListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    if (completion) {
        completion(YES);
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoFrameModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.videoFrameModels[indexPath.row] itemSize].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DNListVideoDetailCellFrameModel *frameModel= self.videoFrameModels[indexPath.row];

    DNListVideoDetailTableViewCell *cell = [DNListVideoDetailTableViewCell cellWithTableView:tableView indexPath:indexPath];

    [cell setLayout:frameModel];

    return cell;
}

- (UITableView *)videoListTableView
{
    if (!_videoListTableView) {
        _videoListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];

        _videoListTableView.estimatedRowHeight = 0;
        _videoListTableView.estimatedSectionHeaderHeight = 0;
        _videoListTableView.estimatedSectionFooterHeight = 0;

        _videoListTableView.backgroundColor = [UIColor blackColor];
        _videoListTableView.delegate = self;
        _videoListTableView.dataSource = self;

        [_videoListTableView registerClass:[DNListVideoDetailTableViewCell class] forCellReuseIdentifier:@"DNVideoListTableViewItemCell"];

    }
    return _videoListTableView;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)fd_prefersNavigationBarHidden
{
    return YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置顶部状态栏颜色 -- 黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (DNPlayerControlViewConfig *)playerControlViewConfig
{
    if (!_playerControlViewConfig) {
        _playerControlViewConfig = [DNPlayerControlViewConfig new];
        _playerControlViewConfig.isShowBackBtn = NO;
    }
    return _playerControlViewConfig;
}

- (NSArray<DNListVideoDetailCellFrameModel *> *)videoFrameModels
{
    if (!_videoFrameModels) {
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 20; i ++) {
            DNListVideoDetailCellFrameModel *frameModel = [[DNListVideoDetailCellFrameModel alloc]initWithModel:nil];
            [marr addObject:frameModel];
        }
        _videoFrameModels = marr.copy;
    }
    return _videoFrameModels;
}

@end
