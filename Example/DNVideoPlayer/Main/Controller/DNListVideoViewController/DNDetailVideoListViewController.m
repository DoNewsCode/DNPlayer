//
//  DNDetailVideoListViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNDetailVideoListViewController.h"
#import "DNVideoListTableViewItemCell.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>
#import <DNVideoPlayer/UIScrollView+DNListVideoPlayerAutoPlay.h>


@interface DNDetailVideoListViewController ()<UITableViewDelegate,UITableViewDataSource,SJPlayerAutoplayDelegate,DNVideoPlayerViewDelegate>

@property (nonatomic, strong) UITableView *videoListTableView;
@property (nonatomic, strong) DNVideoPlayerView *videoPlayer;

@end

@implementation DNDetailVideoListViewController

- (void)dealloc
{
    [self.videoPlayer restPlayer];
    NSLog(@"%@释放了",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.videoListTableView];
    adjustsScrollViewInsets_NO(self.videoListTableView, self);
    self.videoListTableView.frame = CGRectMake(0, TGStatuBarHeight, ScreenWidth, ScreenHeight - TGStatuBarHeight);
//    [self.videoListTableView sj_enableAutoplayWithConfig:[DNPlayerAutoPlayManagerConfig configWithPlayerSuperviewTag:101 autoplayDelegate:self]];
//    [self.videoListTableView sj_needPlayNextAsset];
    [self.videoListTableView sj_disenableAutoplay];
}

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoListTableViewItemCell *cell = [self.videoListTableView cellForRowAtIndexPath:indexPath];
    if ( _videoPlayer &&
        !_videoPlayer.isFullScreen ) {
        // 有播放器或者小窗播放
        @weakify(self)
        [_videoPlayer stopAndFadeOutCompletion:^(UIView *view) {
            // 让旧的播放器淡出
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
    _videoPlayer = [DNVideoPlayerView dnVideoPlayerViewWithDelegate:self]; // 创建一个新的播放器
    //        _videoPlayer.generatePreviewImages = YES; // 生成预览缩略图, 大概20张
    // fade in(淡入)
    _videoPlayer.containerView.alpha = 0.001;
    [UIView animateWithDuration:0.6 animations:^{
        self.videoPlayer.containerView.alpha = 1;
    }];

    ///添加播放器容器视图
    [cell.placeHolderView addSubview:self.videoPlayer.containerView];
    [_videoPlayer.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.trailing.offset(0);    make.height.equalTo(self.videoPlayer.containerView.mas_width).multipliedBy(9 / 16.0f);
    }];


    DNPlayModel *playModel = [DNPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.placeHolderView.tag atIndexPath:indexPath tableView:self.videoListTableView];
    playModel.videourl = [NSString stringWithFormat:@"http:\/\/tb-video.bdstatic.com\/videocp\/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4"];

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
        [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
    };
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
    return (ScreenWidth * 9 / 16);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoListTableViewItemCell *cell = [DNVideoListTableViewItemCell cellWithTableView:tableView indexPath:indexPath];
    return cell;
}

- (UITableView *)videoListTableView
{
    if (!_videoListTableView) {
        _videoListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];

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

@end
