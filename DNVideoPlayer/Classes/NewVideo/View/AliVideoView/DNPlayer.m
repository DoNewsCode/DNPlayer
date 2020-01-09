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
@property (nonatomic, strong) AliPlayer *aliPlayer;
@property (nonatomic, readwrite, strong) DNPlayerControlView *controlView;

/**
 播放器view
 */
@property (nonatomic, strong) UIView *playerView;

@end


@implementation DNPlayer

+ (instancetype)sharedDNPlayer
{
    static DNPlayer *playerView = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        playerView = [[DNPlayer alloc] init];
//    });
    return playerView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.controlView];
        
        [AliPlayer setEnableLog:NO];
    }
    return self;
}

- (void)fullScreenMode
{
    self.aliPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT;
}

- (void)smallScreenMode
{
    self.aliPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
}


- (void)playVideoWithPlayModel:(DNPlayModel *)playModel playerDelegate:(id)delegate completeBlock:(PlayerPublicBlock)completeBlock
{
    if (self.aliPlayer) {
        [self.aliPlayer reset];
    }
    
    if (!self.aliPlayer) {
        self.aliPlayer = [[AliPlayer alloc] init];

        self.aliPlayer.rate = 1;
        
        [self.aliPlayer setCacheConfig:self.cachConfig];
        
    }
    self.aliPlayer.delegate = delegate;
    //设置填充模式
    [self.aliPlayer setScalingMode:AVP_SCALINGMODE_SCALEASPECTFIT];
    //设置自动播放
    [self.aliPlayer setAutoPlay:YES];

    //设置frame
    self.playerView.frame = self.bounds;
    self.aliPlayer.playerView = self.playerView;
    self.controlView.frame = self.bounds;
    
    [self addSubview:self.playerView];
    [self bringSubviewToFront:self.controlView];

    [self setUpControlView];
    
    if (playModel.videourl != nil &&
        ![playModel.videourl isEqualToString:@""]) {
        
        NSString *videoUrl = playModel.videourl;
        
        AVPUrlSource *source = [[[AVPUrlSource alloc] init] urlWithString:playModel.videourl];
        
        NSString *filePath = [self.aliPlayer getCacheFilePath:playModel.videourl];
         
        if (filePath.length > 0) {
            source = [[[AVPUrlSource alloc] init] fileURLWithPath:filePath];
        }
        
        //播放
        [self.aliPlayer setUrlSource:source];
        
    }
    AVPConfig *config = [self.aliPlayer getConfig];
    if (playModel.videourl.length > 4 && [[playModel.videourl substringToIndex:4] isEqualToString:@"artp"]) {
        config.maxDelayTime = 100;
    }else {
        config.maxDelayTime = 5000;
    }
    
    config.enableSEI = YES;
    
    [self.aliPlayer setConfig:config];
    
    [self.aliPlayer prepare];
    
    [self.aliPlayer start];
    
    if (completeBlock) {
        completeBlock(nil);
    }
}

- (void)setDisplayMode:(AVPScalingMode)displayMode
{
    _displayMode = displayMode;
    [self.aliPlayer setScalingMode:_displayMode];
}

- (void)setControlViewConfig:(DNPlayerControlViewConfig *)controlViewConfig
{
    _controlViewConfig = controlViewConfig;
    //设置控制层配置
    self.controlView.controlViewConfig = _controlViewConfig;
}

- (void)setUpControlView
{
    //重置控制层
    [self.controlView resetControlView];
    //播放时隐藏控制层
    [self.controlView hideControlView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.aliPlayer.playerView.frame = self.bounds;
    self.controlView.frame = self.bounds;
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
    [self.aliPlayer start];
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
//    [self.aliPlayer reset];
}

/*
 功能：销毁播放器
 */
- (void)releasePlayer
{
    [self.aliPlayer destroy];
}

/*
 功能：跳转到指定位置进行播放，单位为秒
 备注：在播放器状态AliyunVodPlayerEventFirstFrame之后才能调用此函数。
 */
- (void)seekToTime:(NSTimeInterval)time
{
    [self.aliPlayer seekToTime:time seekMode:AVP_SEEKMODE_ACCURATE];
}

/**
 * 功能：设置是否静音，YES为静音
 */
- (void)setIsMuteMode:(BOOL)isMuteMode
{
    _isMuteMode = isMuteMode;
    self.aliPlayer.muted = _isMuteMode;
}

- (void)setLoopPlay:(BOOL)loop {
    
    self.aliPlayer.loop = loop;
    
}

/*
 功能：视频总长度，单位为秒
 备注：在prepareWithVid之后才能够获取时长。
 */
- (NSTimeInterval)totalDuration
{
    return self.aliPlayer.duration/1000;
}

/*
 功能：当前视频播放位置，单位为秒
 备注：在开始播放之后才能够获取当前播放位置。
 */
- (NSTimeInterval)currentTime
{
    return self.aliPlayer.currentPosition/1000;
}

/*
 功能：获取已经加载的视频长度，或者说对于网络视频来说已经下载的视频时长
 备注：在开始播放之后才能够获取此位置。
 */
- (NSTimeInterval)loadedTime
{
    return self.aliPlayer.bufferedPosition/1000;
}


#pragma mark - 懒加载 lazyLoad

- (AVPCacheConfig *)cachConfig {
    
    if (!_cachConfig) {
        _cachConfig = [[AVPCacheConfig alloc] init];
        _cachConfig.path = [self videoCachPath];
        _cachConfig.maxDuration = 120*60;
        _cachConfig.maxSizeMB = 1024*2;
        _cachConfig.enable = YES;
    }
    
    return _cachConfig;
}

- (DNPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[DNPlayerControlView alloc]init];
    }
    return _controlView;
}

- (UIView *)playerView {
    
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:self.bounds];
    }
    
    return _playerView;
}

- (NSString *)videoCachPath {
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return [docPath stringByAppendingString:@"/renren/videoListPath"];
    
}


@end
