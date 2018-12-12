//
//  DNVideoPlayerView.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DNPlayModel.h"
#import "DNPlayerTypeDef.h"
#import "DNPlayer.h"
#import "DNPlayerRotationManager.h"

@class DNVideoPlayerView;
@protocol DNVideoPlayerViewDelegate <NSObject>

/// 播放器横屏竖屏(播放器方向改变)返回是否为全屏
//- (void)dnVodPlayerView:(DNVideoPlayerView *)playerView fullScreen:(BOOL)isFullScreen;

@end

@interface DNVideoPlayerView : UIView

/// 旋转管理对象: 指定旋转及管理视图的自动旋转
@property (nonatomic, strong, null_resettable) id<DNPlayerRotationManagerProtocol> rotationManager;
/// 真正播放的视图(内含阿里云播放器)
@property (nonatomic, strong) DNPlayer *player;
/// 容器视图
@property (nonatomic, strong) UIView *containerView;
/// 是否为全屏播放
@property (nonatomic, readonly, getter = isFullScreen) BOOL fullScreen;
/// 播放器控制视图类型(可以设置直播或点播类型)
@property (nonatomic, assign) PlayerControlViewType controlViewType;

/// 视频进度条的单击手势
@property (nonatomic, strong) UITapGestureRecognizer *progressTap;
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

@end
