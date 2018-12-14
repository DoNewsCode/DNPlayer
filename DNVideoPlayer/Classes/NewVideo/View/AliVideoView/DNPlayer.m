//
//  DNPlayer.m
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import "DNPlayer.h"

@interface DNPlayer () 
/// 阿里云播放器
@property (nonatomic, strong) AliyunVodPlayer *aliPlayer;


@end


@implementation DNPlayer

+ (instancetype)sharedPlayerView
{
    static DNPlayer *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[DNPlayer alloc] init];
    });
    return playerView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.controlView];
    }
    return self;
}



- (void)playVideoWithPlayModel:(DNPlayModel *)playModel playerDelegate:(id)delegate completeBlock:(PlayerPublicBlock)completeBlock
{
    if (self.aliPlayer.isPlaying) {
        [self.aliPlayer reset];
    }
    
    if (!self.aliPlayer) {
        self.aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    self.aliPlayer.delegate = delegate;
    //设置填充模式
    [self.aliPlayer setDisplayMode:AliyunVodPlayerDisplayModeFitWithCropping];
    //设置自动播放
    [self.aliPlayer setAutoPlay:YES];

    [self addSubview:self.aliPlayer.playerView];
    [self bringSubviewToFront:self.controlView];

    [self setUpControlView];


    //设置frame
    self.aliPlayer.playerView.frame = self.bounds;
    self.controlView.frame = self.bounds;
    
    if (playModel.videourl != nil &&
        ![playModel.videourl isEqualToString:@""]) {
        //播放
        [self.aliPlayer prepareWithURL:[NSURL URLWithString:playModel.videourl]];
        //检查网络
        //[self netWorking];
    }
    //    [self tapPlayerViewGestureAction];
    if (completeBlock) {
        completeBlock(nil);
    }
}

- (void)setUpControlView
{
    //重置控制层
    [self.controlView resetControlView];
    //设置控制层类型
    self.controlView.controlViewType = self.controlViewType;
    //播放时隐藏控制层
    [self.controlView hideControlView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.aliPlayer.playerView.frame = self.bounds;
    self.controlView.frame = self.bounds;
}


- (AliyunVodPlayerState)playerState
{
    return self.aliPlayer.playerState;
}

/*
 功能：开始播放视频
 备注：在prepareWithVid之后可以调用start进行播放。
 */
- (void)start
{
    [self.aliPlayer start];
}

/*
 功能：恢复播放视频
 备注：在pause暂停视频之后可以调用resume进行播放。
 */
- (void)resume
{
    [self.aliPlayer resume];
}

/*
 功能：暂停播放视频
 备注：在start播放视频之后可以调用pause进行暂停。
 */
- (void)pause
{
    [self.aliPlayer pause];
}

/*
 功能：停止播放视频
 */
- (void)stop
{
    [self.aliPlayer stop];
}

/// 清空播放器
- (void)reset
{
    [self.aliPlayer reset];
    //重置控制层
    [self.controlView resetControlView];
}

/*
 功能：重播，重新播放上一次url地址视频。
 */
- (void)replay
{
    [self.aliPlayer replay];
}

/*
 功能：销毁播放器
 */
- (void)releasePlayer
{
    [self.aliPlayer releasePlayer];
}

/*
 功能：跳转到指定位置进行播放，单位为秒
 备注：在播放器状态AliyunVodPlayerEventFirstFrame之后才能调用此函数。
 */
- (void)seekToTime:(NSTimeInterval)time
{
    [self.aliPlayer seekToTime:time];
}

/**
 * 功能：设置是否静音，YES为静音
 */
- (void)setIsMuteMode:(BOOL)isMuteMode
{
    _isMuteMode = isMuteMode;
    self.aliPlayer.muteMode = _isMuteMode;
}

/**
 * 功能：播放器初始化后，获取播放器是否播放。
 */
- (BOOL)isPlaying
{
    return self.aliPlayer.isPlaying;
}

/**
 * 功能：设置网络超时时间，单位毫秒
 * 备注：当播放网络流时，设置网络超时时间，默认15000毫秒
 */
- (void)setTimeout:(int)timeout
{
    _timeout = timeout;
    self.aliPlayer.timeout = _timeout;
}

/*
 功能：视频总长度，单位为秒
 备注：在prepareWithVid之后才能够获取时长。
 */
- (NSTimeInterval)totalDuration
{
    return self.aliPlayer.duration;
}

/*
 功能：当前视频播放位置，单位为秒
 备注：在开始播放之后才能够获取当前播放位置。
 */
- (NSTimeInterval)currentTime
{
    return self.aliPlayer.currentTime;
}

/*
 功能：获取已经加载的视频长度，或者说对于网络视频来说已经下载的视频时长
 备注：在开始播放之后才能够获取此位置。
 */
- (NSTimeInterval)loadedTime
{
    return self.aliPlayer.loadedTime;
}


#pragma mark - 懒加载 lazyLoad
- (DNPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[DNPlayerControlView alloc]init];
        _controlView.backgroundColor = [UIColor greenColor];
    }
    return _controlView;
}




@end
