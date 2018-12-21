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
#import "DNPlayer.h"
#import "DNPlayerRotationManager.h"
#import "DNPlayerControlViewProtocol.h"
#import "DNPlayerControlViewConfig.h"

typedef void(^DNVideoPlayerPublicBlock)(id sender);

@class DNVideoPlayerView;
@protocol DNVideoPlayerViewDelegate <NSObject>


/// 播放器滑出ScrollView代理方法
- (void)dnVodPlayerDisappearScrollViewAction:(DNVideoPlayerView *)playerView;

@end

@interface DNVideoPlayerView : DNVideoBaseView

/// 旋转管理对象: 指定旋转及管理视图的自动旋转
@property (nonatomic, strong, null_resettable) id<DNPlayerRotationManagerProtocol> rotationManager;
/// 真正播放的视图(内含阿里云播放器)
@property (nonatomic, strong) DNPlayer *player;
/// 是否动画显示播放器(初始化播放器后 1.添加容器视图到主视图上.2.设置容器视图frame)
@property (nonatomic, assign) BOOL isAnimateShowContainerView;
/// 容器视图
@property (nonatomic, strong) UIView *containerView;
/// 播放器控制视图类型(可以设置直播或点播类型)
@property (nonatomic, strong) DNPlayerControlViewConfig *controlViewConfig;
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

/// 播放视频 (playModel--视频播放模型)
- (void)playVideoWithPlayModel:(DNPlayModel *)playModel completeBlock:(PlayerPublicBlock)completeBlock;


/// 重置/清空播放器
- (void)restPlayer;
/// 播放器播放
- (void)playerPlay;
/// 播放器暂停
- (void)playerPause;
/// 停止并移除
- (void)stopAndFadeOutCompletion:(void(^)(UIView *view))block;
@end
