//
//  DNDetailVideoListViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNDetailVideoListViewController.h"
#import "DNVideoListTableViewItemCell.h"
//#import "DNVideoPlayerView.h"

#import <DNVideoPlayer/DNVideoPlayerView.h>

//#import "UIScrollView+DNListVideoPlayerAutoPlay.h"


@interface DNDetailVideoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *videoListTableView;
@property (nonatomic, strong) DNVideoPlayerView *videoPlayer;

@end

@implementation DNDetailVideoListViewController

- (void)dealloc
{
    NSLog(@"%@释放了",[self class]);
    [self.videoPlayer restPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.videoListTableView];
    adjustsScrollViewInsets_NO(self.videoListTableView, self);
    self.videoListTableView.frame = CGRectMake(0, TGStatuBarHeight, ScreenWidth, ScreenHeight - TGStatuBarHeight);

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoListTableViewItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ///初始化播放器
    self.videoPlayer = [DNVideoPlayerView dnVideoPlayerViewWithDelegate:self];
    ///添加播放器容器视图
    [cell addSubview:self.videoPlayer.containerView];
    [self.videoPlayer.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.trailing.offset(0);    make.height.equalTo(self.videoPlayer.containerView.mas_width).multipliedBy(9 / 16.0f);
    }];


    DNPlayModel *playModel = [[DNPlayModel alloc]init];
    playModel.videourl = [NSString stringWithFormat:@"http:\/\/tb-video.bdstatic.com\/videocp\/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4"];

    [self.videoPlayer playVideoWithPlayModel:playModel completeBlock:nil];
    cell.placeHolderView.hidden = YES;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNVideoListTableViewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNVideoListTableViewItemCell" forIndexPath:indexPath];

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
