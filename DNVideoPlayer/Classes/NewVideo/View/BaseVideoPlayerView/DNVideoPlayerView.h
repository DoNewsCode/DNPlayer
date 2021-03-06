//
//  DNVideoPlayerView.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import "DNVideoBaseView.h"
#import "DNPlayerTypeDef.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DNPlayer.h"
#import "DNPlayerRotationManager.h"
#import "DNPlayerControlViewProtocol.h"
#import "DNPlayerControlViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DNVideoPlayerPublicBlock)(id sender);

@class DNVideoPlayerView;
@protocol DNVideoPlayerViewDelegate <NSObject>

/// 播放器滑出ScrollView代理方法
- (void)dnVodPlayerDisappearScrollViewAction:(DNVideoPlayerView *)playerView;

@end

@interface DNVideoPlayerView : DNVideoBaseView

#pragma - mark 播放状态的一些回调Block共外界使用
/// 准备播放回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventPrepareDone;
/// 暂停播放回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventPause;
/// 播放回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventPlay;
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventStop;
/// 开始加载回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventBeginLoading;
/// 结束加载回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventEndLoading;
/// 结束播放回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventFinish;
/// 出现第一帧画面回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventFirstFrame;
/// 改变进度回调
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerEventSeekDone;

/// 进度条
@property (nonatomic,   copy) DNVideoPlayerPublicBlock PlayerChangeCurrentTimeBlock;
@property (nonatomic,   copy) void(^PlayerChangeCurrentValueBlock)(CGFloat sender);
@property (nonatomic,   copy) void(^PlayerChangeLoadingValueBlock)(CGFloat sender) ;


/// 旋转管理对象: 指定旋转及管理视图的自动旋转
@property (nonatomic, strong, null_resettable) id<DNPlayerRotationManagerProtocol> rotationManager;
/// 真正播放的视图(内含阿里云播放器)
@property (nonatomic, strong) DNPlayer *player;
/// 容器视图
@property (nonatomic, strong) UIView *containerView;
/// 是否动画显示播放器(初始化播放器后 1.添加容器视图到主视图上.2.设置容器视图frame)
@property (nonatomic, assign) BOOL isAnimateShowContainerView;
/// 播放器控制视图类型(可以设置直播或点播类型)
@property (nonatomic, strong) DNPlayerControlViewConfig *controlViewConfig;
/// 单独设置底部进度条是否显示
@property (nonatomic, assign) BOOL isShowBottomProgressView;
/// 是否展示剩余时间视图
@property (nonatomic, assign) BOOL isShowRemaindTimeView;
/// 单独设置缓冲视图
@property (nonatomic, strong) UIImageView *customLoadingView;

/// 视频进度条的单击手势
@property (nonatomic, strong) UITapGestureRecognizer *progressTap;
/// 是否为全屏播放
@property (nonatomic, readonly, getter = isFullScreen) BOOL fullScreen;
/// 是否可以更新进度条
@property (nonatomic, assign) BOOL mProgressCanUpdate;
/// 是否显示controlView
@property (nonatomic, assign) BOOL isMaskShowing;
/// 系统音量控制
@property (nonatomic, strong) MPMusicPlayerController *mpVolumVC;
/// 音量滑杆
@property (nonatomic, strong) UISlider *volumeViewSlider;
/// 设置DNVideoPlayerViewDelegate代理(播放器放大或者缩小)
@property (nonatomic, weak) id<DNVideoPlayerViewDelegate> videoPlayerDelegate;

/// 播放器在ScrollView滑动控制
@property (nonatomic, weak, nullable) id <DNVideoPlayerControlViewDelegate> controlLayerDelegate;


/// 播放器初始化
+ (instancetype)dnVideoPlayerViewWithDelegate:(id<DNVideoPlayerViewDelegate>)delegate;
/// 添加到父视图上
- (void)dn_addToSuperContainerView:(UIView *)containerView;

/// 播放视频 (playModel--视频播放模型)
- (void)playVideoWithPlayModel:(DNPlayModel *)playModel completeBlock:(PlayerPublicBlock)completeBlock;

/**
 * 功能：获取/设置显示模式
 * 显示模式有：
 * AliyunVodPlayerDisplayModeFit,            // 保持原始比例
 * AliyunVodPlayerDisplayModeFitWithCropping // 全屏占满屏幕
 */
- (void)setPlayerDisplayMode:(AVPScalingMode)displayMode;

/// 设置静音(YES静音 NO不静音)
- (void)setPlayerMuteMode:(BOOL)isMute;
/// 重置/清空播放器
- (void)restPlayer;
/// 播放器播放
- (void)playerPlay;
/// 播放器暂停
- (void)playerPause;
/// 播放器重新播放
- (void)playerReplay;
/// 停止并移除视图
- (void)stopAndFadeOutAnimated:(BOOL)isAnimate Completion:(void(^)(void))block;
/// 销毁播放器
- (void)releaseVideoPlayerView;

/// 是否循环播放
/// @param loop yes 是 NO 不是 默认不开启
- (void)setLoopPlay:(BOOL)loop;

NS_ASSUME_NONNULL_END

@end
