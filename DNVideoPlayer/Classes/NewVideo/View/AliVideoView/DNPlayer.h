//
//  DNPlayer.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//  播放器主要功能封装

#import <UIKit/UIKit.h>
#import "DNPlayerTypeDef.h"
#import "DNPlayerControlView.h"
#import "DNPlayerControlViewConfig.h"
///// 播放结束视图
//#import "DNAdPlayToEndView.h"

@class DNPlayModel;

@interface DNPlayer : UIView

#pragma mark 播放器控制层设置 --------
@property (nonatomic, strong) DNPlayerControlViewConfig *controlViewConfig;
@property (nonatomic, readonly, strong) DNPlayerControlView *controlView;

/** 视频URL */
@property (nonatomic, strong) NSURL *videoURL;
/**
 * 功能：设置是否静音，YES为静音
 */
@property (nonatomic, assign) BOOL isMuteMode;
/**
 * 功能：设置网络超时时间，单位毫秒
 * 备注：当播放网络流时，设置网络超时时间，默认15000毫秒
 */
@property(nonatomic, assign) int timeout;
/*
 功能：视频总长度，单位为秒
 备注：在prepareWithVid之后才能够获取时长。
 */
@property (nonatomic, readonly,assign)NSTimeInterval totalDuration;
/*
 功能：当前视频播放位置，单位为秒
 备注：在开始播放之后才能够获取当前播放位置。
 */
@property (nonatomic, readonly,assign)NSTimeInterval currentTime;

/**
 * 功能：是否播放
 */
@property (nonatomic, readonly,assign) BOOL isPlaying;
/*
 功能：获取已经加载的视频长度，或者说对于网络视频来说已经下载的视频时长
 备注：在开始播放之后才能够获取此位置。
 */
@property (nonatomic, readonly,assign)NSTimeInterval loadedTime;

/**
 *  单例
 *  @return player
 */
+ (instancetype)sharedDNPlayer;



- (void)playVideoWithPlayModel:(DNPlayModel *)playModel playerDelegate:(id)delegate completeBlock:(PlayerPublicBlock)completeBlock;
/*
 功能：开始播放视频
 备注：在prepareWithVid之后可以调用start进行播放。
 */
- (void)start;

/*
 功能：恢复播放视频
 备注：在pause暂停视频之后可以调用resume进行播放。
 */
- (void)resume;

/*
 功能：暂停播放视频
 备注：在start播放视频之后可以调用pause进行暂停。
 */
- (void)pause;

/*
 功能：停止播放视频
 */
- (void)stop;
    
/// 清空播放器
- (void)reset;

/*
 功能：重播，重新播放上一次url地址视频。
 */
- (void)replay;

/*
 功能：销毁播放器
 */
- (void)releasePlayer;

/*
 功能：跳转到指定位置进行播放，单位为秒
 备注：在播放器状态AliyunVodPlayerEventFirstFrame之后才能调用此函数。
 */
- (void)seekToTime:(NSTimeInterval)time;

/// 播放器状态
- (AliyunVodPlayerState)playerState;

@end
