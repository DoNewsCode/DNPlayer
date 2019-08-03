//
//  DNListVideoAutoPlayViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/17.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNListVideoAutoPlayViewController.h"
#import "DNVideoListTableViewItemCell.h"
#import "DNVideoDetailViewController.h"
#import "DNListVideoDetailViewController.h"
#import <DNCommonKit/UIView+CTLayout.h>

@interface DNListVideoAutoPlayViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) DNPlayerControlViewConfig *playerControlViewConfig;
@property (nonatomic, strong) DNVideoPlayerView *videoPlayer;
/// 记录动画前的frame
@property (nonatomic, assign) CGRect markTempCellFrame;
/// 记录当前播放的 Cell indexPath
@property (nonatomic, readwrite, strong) NSIndexPath *markTempIndexPath;

@end

@implementation DNListVideoAutoPlayViewController

- (void)dealloc
{
    [self.videoPlayer releaseVideoPlayerView];
    NSLog(@"%@释放了",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.videoListTableView];

    adjustsScrollViewInsets_NO(self.videoListTableView, self);

    [self configPlayMode];

    self.videoListTableView.frame = CGRectMake(0, NAV_BAR_Y, ScreenWidth, ScreenHeight - STATUS_BAR_H_Decide);

}

- (void)configPlayMode
{
//    [self.videoListTableView dn_disenableAutoplay];
    [self.videoListTableView dn_enableAutoplayWithConfig:[DNPlayerAutoPlayManagerConfig configWithPlayerSuperviewTag:101 autoplayDelegate:self]];
    [self.videoListTableView dn_needPlayNextAsset];
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
        DNVideoListTableViewItemCell *cell = [self.videoListTableView cellForRowAtIndexPath:indexPath];

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


    //    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSBundle.mainBundle URLForResource:@"play" withExtension:@"mp4"] playModel:[SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.view.coverImageView.tag atIndexPath:indexPath tableView:self.tableView]];
    //    _player.URLAsset.title = @"Test Title";
    //    _player.URLAsset.alwaysShowTitle = YES;
}

- (void)playNewVideoWithCell:(DNVideoListTableViewItemCell *)cell indexPath:(NSIndexPath *)indexPath completeBlock:(void(^)(id sender))completeBlock
{
    // 创建播放器
    _videoPlayer = [DNVideoPlayerView dnVideoPlayerViewWithDelegate:self];
    // 播放器控制层配置
    _videoPlayer.controlViewConfig = self.playerControlViewConfig;

    ///添加播放器容器视图
    [cell.videoPlaceHolderView addSubview:_videoPlayer.containerView];
    _videoPlayer.containerView.ct_top = 0;
    _videoPlayer.containerView.ct_left= 0;
    _videoPlayer.containerView.ct_size = CGSizeMake(ScreenWidth, ScreenWidth *9 /16);
    //    [_videoPlayer.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.offset(0);
    //        make.leading.trailing.offset(0);
    //        make.height.equalTo(self->_videoPlayer.containerView.mas_width).multipliedBy(9 / 16.0f);
    //    }];

    _videoPlayer.isAnimateShowContainerView = YES;

    DNPlayModel *playModel = [DNPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.videoPlaceHolderView.tag atIndexPath:indexPath tableView:self.videoListTableView];

    playModel.videourl = [NSString stringWithFormat:@"https://niuerdata.g.com.cn/data/shareimg_oss/big_media_article_video/YLZX-MP-2/bd6b5602c872793998941755b3c7e8cb.mp4"];
    //    [NSString stringWithFormat:@"https://donewsdataoss.g.com.cn/data/video/2017/1221/A2niwf4GDP-1545373763374.mp4"];
    //https://donewsdataoss.g.com.cn/data/video/2017/1221/A2niwf4GDP-1545373763374.mp4
    [_videoPlayer playVideoWithPlayModel:playModel completeBlock:completeBlock];

}

- (void)dnVodPlayerDisappearScrollViewAction:(DNVideoPlayerView *)playerView
{
    [self.videoPlayer stopAndFadeOutCompletion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DNVideoListTableViewItemCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self)
    cell.playBtnClickBlock = ^(id  _Nonnull sender) {
        @strongify(self)
        if ( !self ) return;
        [self dn_playerNeedPlayNewAssetAtIndexPath:indexPath];
    };
}


- (void)animateCurrentItemCellWithIndexPath:(NSIndexPath *)indexPath completion:(void (^ __nullable)(BOOL finished))completion
{

    DNVideoListItemFrameModel *frameModel= self.videoFrameModels[indexPath.row];
    if (frameModel.isSelected) {
        if (completion) {completion(nil);}
        return;
    }

    [self.videoFrameModels enumerateObjectsUsingBlock:^(DNVideoListItemFrameModel * _Nonnull frameModel, NSUInteger idx, BOOL * _Nonnull stop) {
        frameModel.isSelected = NO;
    }];

    frameModel.isSelected = YES;
    //    [self.videoListTableView reloadData];

    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    //        DNVideoListItemFrameModel *frameModel= self.videoFrameModels[indexPath.row];
    //        frameModel.isSelected = YES;

    [self.videoListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    if (completion) {
        completion(YES);
    }
    //    });

}

- (void)playVideoOnListVideoDetailVcWithIndexPath:(NSIndexPath *)indexPath
{

    DNListVideoDetailViewController *desVc = [[DNListVideoDetailViewController alloc]init];

    desVc.presentStyle = DNCustomPresentStyleFadeIn;
    desVc.dismissStyle = DNCustomDismissStyleFadeOut;

    [self.navigationController pushViewController:desVc animated:YES];

}


- (void)playVideoOnDetailVcActionWithIndexPath:(NSIndexPath *)indexPath
{
    //1.视频开始播放
    @weakify(self)
    [self __playerNeedPlayNewAssetAtIndexPath:indexPath completeBlock:^(id sender) {

        @strongify(self)
        if (![self.markTempIndexPath isEqual:indexPath]) {
            //根据frameModel判断(如果模型相同则不重新播放)
            if (![self.videoFrameModels[self.markTempIndexPath.row] isEqual:self.videoFrameModels[indexPath.row]]) {
                [self.videoPlayer restPlayer];
            }
        }

        DNVideoDetailViewController *desVc = [[DNVideoDetailViewController alloc]init];

        desVc.presentStyle = DNCustomPresentStyleFadeIn;
        desVc.dismissStyle = DNCustomDismissStyleFadeOut;

        [self.navigationController pushViewController:desVc animated:YES];

        //        self.markTempIndexPath = indexPath;

    }];

    //    DNVideoListTableViewItemCell *cell = [self.videoListTableView cellForRowAtIndexPath:indexPath];
    //    self.markTempIndexPath = indexPath;
    //
    //    if ( self->_videoPlayer &&
    //        !self->_videoPlayer.isFullScreen ) {
    //        // 有播放器或者小窗播放
    //        @weakify(self)
    //        [self->_videoPlayer stopAndFadeOutCompletion:^(UIView *view) {
    //            //让旧的播放器淡出
    //            @strongify(self)
    //            [self playNewVideoWithCell:cell indexPath:indexPath];
    //        }];
    //
    //    }else{
    //
    //        [self playNewVideoWithCell:cell indexPath:indexPath];
    //
    //    }


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
    return self.videoFrameModels[indexPath.row].cellItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DNVideoListItemFrameModel *frameModel= self.videoFrameModels[indexPath.row];

    DNVideoListTableViewItemCell *cell = [DNVideoListTableViewItemCell cellWithTableView:tableView indexPath:indexPath];

    [cell setLayout:frameModel];

    @weakify(self)
    cell.bottomView.bottomViewTapActionBlock = ^(id  _Nonnull sender) {
        @strongify(self)

        //跳转详情页
        [self playVideoOnDetailVcActionWithIndexPath:indexPath];

    };


    cell.bottomView.headerImageTapActionBlock = ^(id  _Nonnull sender) {
        @strongify(self)
        //跳转列表详情页
        [self playVideoOnListVideoDetailVcWithIndexPath:indexPath];
    };


    return cell;
}

- (UITableView *)videoListTableView
{
    if (!_videoListTableView) {
        _videoListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];

        _videoListTableView.estimatedRowHeight = 0;
        _videoListTableView.estimatedSectionHeaderHeight = 0;
        _videoListTableView.estimatedSectionFooterHeight = 0;

        _videoListTableView.backgroundColor = [UIColor blueColor];
        _videoListTableView.delegate = self;
        _videoListTableView.dataSource = self;

        [_videoListTableView registerClass:[DNVideoListTableViewItemCell class] forCellReuseIdentifier:@"DNVideoListTableViewItemCell"];

    }
    return _videoListTableView;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置顶部状态栏颜色 -- 黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (nonnull UIView *)transitionSourceView
{
    //    NSIndexPath *selectedIndexPath = [self.videoListTableView indexPathForSelectedRow];
    DNVideoListTableViewItemCell *cell = (DNVideoListTableViewItemCell *)[self.videoListTableView cellForRowAtIndexPath:self.markTempIndexPath];


    CGRect playerFrameInSuperview = [cell convertRect:cell.videoPlaceHolderView.frame toView:[UIApplication sharedApplication].keyWindow];

    cell.videoPlaceHolderView.frame = playerFrameInSuperview;
    //    cell.frame = frameInSuperview;

    self.markTempCellFrame = playerFrameInSuperview;
    //    self.markTempCellFrame = frameInSuperview;

    return cell.videoPlaceHolderView;
    //    return cell;
}

- (CGRect)transitionDestinationViewFrame
{
    NSLog(@"frameInSuperview===%f",self.markTempCellFrame.origin.y);
    return self.markTempCellFrame;
}

- (void)customTransitionAnimator:(nonnull DNCustomAnimator *)animator
           didCompleteTransition:(BOOL)didComplete
             animatingSourceView:(nonnull UIView *)sourceView;
{

    //    NSIndexPath *selectedIndexPath = [self.videoListTableView indexPathForSelectedRow];
    //播放器视图放回原Cell sourceView暂时定为播放器
    //设置cell在tableview上的frame;
    NSLog(@"%@",sourceView.superview);
    DNVideoListTableViewItemCell *cell = (DNVideoListTableViewItemCell *)[self.videoListTableView cellForRowAtIndexPath:self.markTempIndexPath];

    [cell addSubview:sourceView];
    sourceView.ct_top = 0;

}

- (DNPlayerControlViewConfig *)playerControlViewConfig
{
    if (!_playerControlViewConfig) {
        _playerControlViewConfig = [DNPlayerControlViewConfig new];
        _playerControlViewConfig.isShowBackBtn = NO;
    }
    return _playerControlViewConfig;
}

- (NSArray<DNVideoListItemFrameModel *> *)videoFrameModels
{
    if (!_videoFrameModels) {
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 20; i ++) {
            DNVideoListItemFrameModel *frameModel = [[DNVideoListItemFrameModel alloc]initWithModel:nil];
            [marr addObject:frameModel];
        }
        _videoFrameModels = marr.copy;
    }
    return _videoFrameModels;
}


@end
