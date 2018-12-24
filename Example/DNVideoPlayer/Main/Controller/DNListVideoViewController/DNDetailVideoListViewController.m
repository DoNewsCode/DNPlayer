//
//  DNDetailVideoListViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNDetailVideoListViewController.h"
#import "DNVideoListTableViewItemCell.h"
#import "DNVideoDetailViewController.h"

@interface DNDetailVideoListViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) DNPlayerControlViewConfig *playerControlViewConfig;
@property (nonatomic, strong) DNVideoPlayerView *videoPlayer;
/// 记录动画前的frame
@property (nonatomic, assign) CGRect markTempCellFrame;
/// 记录当前播放的 Cell indexPath
@property (nonatomic, strong) NSIndexPath *markTempIndexPath;

@end

@implementation DNDetailVideoListViewController

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
    [self.videoListTableView dn_disenableAutoplay];
}

- (void)dn_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoListTableViewItemCell *cell = [self.videoListTableView cellForRowAtIndexPath:indexPath];
    self.markTempIndexPath = indexPath;
    if ( _videoPlayer &&
        !_videoPlayer.isFullScreen ) {
        // 有播放器或者小窗播放
        @weakify(self)
        [_videoPlayer stopAndFadeOutCompletion:^(UIView *view) {
            //让旧的播放器淡出
            @strongify(self)
            [self playNewVideoWithCell:cell indexPath:indexPath];
        }];
    }else{
         [self playNewVideoWithCell:cell indexPath:indexPath];
    }

//    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSBundle.mainBundle URLForResource:@"play" withExtension:@"mp4"] playModel:[SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.view.coverImageView.tag atIndexPath:indexPath tableView:self.tableView]];
//    _player.URLAsset.title = @"Test Title";
//    _player.URLAsset.alwaysShowTitle = YES;

}

- (void)playNewVideoWithCell:(DNVideoListTableViewItemCell *)cell indexPath:(NSIndexPath *)indexPath
{
    // 创建播放器
    _videoPlayer = [DNVideoPlayerView dnVideoPlayerViewWithDelegate:self];
    // 播放器控制层配置 
    _videoPlayer.controlViewConfig = self.playerControlViewConfig;

    ///添加播放器容器视图
    [cell.videoPlaceHolderView addSubview:_videoPlayer.containerView];
    [_videoPlayer.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(self->_videoPlayer.containerView.mas_width).multipliedBy(9 / 16.0f);
    }];

    _videoPlayer.isAnimateShowContainerView = YES;
    //        _videoPlayer.generatePreviewImages = YES; // 生成预览缩略图, 大概20张
    // fade in(淡入)
//    _videoPlayer.containerView.alpha = 0.001;
//    [UIView animateWithDuration:DNPlayerContainerShowTimeInterval animations:^{
//        self.videoPlayer.containerView.alpha = 1;
//    }];


    DNPlayModel *playModel = [DNPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.videoPlaceHolderView.tag atIndexPath:indexPath tableView:self.videoListTableView];

    playModel.videourl = [NSString stringWithFormat:@"http:\/\/tb-video.bdstatic.com\/videocp\/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4"];
//    [NSString stringWithFormat:@"https://donewsdataoss.g.com.cn/data/video/2017/1221/A2niwf4GDP-1545373763374.mp4"];


//https://donewsdataoss.g.com.cn/data/video/2017/1221/A2niwf4GDP-1545373763374.mp4



    [_videoPlayer playVideoWithPlayModel:playModel completeBlock:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //有问题
    if (![self.markTempIndexPath isEqual:indexPath]) {
        if (self.videoPlayer.player.playerState == AliyunVodPlayerStatePlay ||
            self.videoPlayer.player.playerState == AliyunVodPlayerStatePause ) {
            [self.videoPlayer restPlayer];
        }
    }

    DNVideoDetailViewController *desVc = [[DNVideoDetailViewController alloc]init];

    desVc.presentStyle = DNCustomPresentStyleFadeIn;
    desVc.dismissStyle = DNCustomDismissStyleFadeOut;

    [self.navigationController pushViewController:desVc animated:YES];

    self.markTempIndexPath = indexPath;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenWidth * 9 / 16)+50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoListTableViewItemCell *cell = [DNVideoListTableViewItemCell cellWithTableView:tableView indexPath:indexPath];
    return cell;
}

- (UITableView *)videoListTableView
{
    if (!_videoListTableView) {
        _videoListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];

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
    NSIndexPath *selectedIndexPath = [self.videoListTableView indexPathForSelectedRow];
    DNVideoListTableViewItemCell *cell = (DNVideoListTableViewItemCell *)[self.videoListTableView cellForRowAtIndexPath:selectedIndexPath];
//    CGRect frameInSuperview = [self.videoListTableView convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];

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
//    NSIndexPath *selectedIndexPath = [self.videoListTableView indexPathForSelectedRow];
//    DNVideoListTableViewItemCell *cell = (DNVideoListTableViewItemCell *)[self.videoListTableView cellForRowAtIndexPath:selectedIndexPath];
//    CGRect frameInSuperview = [self.videoListTableView convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];

    NSLog(@"frameInSuperview===%f",self.markTempCellFrame.origin.y);
//    frameInSuperview.origin.x -= cell.contentView.layoutMargins.left;
//    frameInSuperview.origin.y -= cell.contentView.layoutMargins.top;
    return self.markTempCellFrame;
}

- (void)customTransitionAnimator:(nonnull DNCustomAnimator *)animator
           didCompleteTransition:(BOOL)didComplete
             animatingSourceView:(nonnull UIView *)sourceView;
{

    NSIndexPath *selectedIndexPath = [self.videoListTableView indexPathForSelectedRow];
    //播放器视图放回原Cell sourceView暂时定为播放器
    //设置cell在tableview上的frame;
    NSLog(@"%@",sourceView.superview);
//    [self.videoListTableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    DNVideoListTableViewItemCell *cell = (DNVideoListTableViewItemCell *)[self.videoListTableView cellForRowAtIndexPath:selectedIndexPath];

    [cell addSubview:sourceView];
    sourceView.top = 0;

    

//    if (self.videoPlayer) {
//        [cell.videoPlaceHolderView bringSubviewToFront:self.videoPlayer];
//    }

//    [self.videoListTableView insertRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (DNPlayerControlViewConfig *)playerControlViewConfig
{
    if (!_playerControlViewConfig) {
        _playerControlViewConfig = [DNPlayerControlViewConfig new];
        _playerControlViewConfig.isShowBackBtn = NO;
    }
    return _playerControlViewConfig;
}


@end
