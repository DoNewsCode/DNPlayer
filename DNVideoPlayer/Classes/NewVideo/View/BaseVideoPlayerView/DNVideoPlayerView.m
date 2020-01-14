//
//  DNVideoPlayerView.m
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//  播放器+控制层视图

#import "DNVideoPlayerView.h"
#import "DNPlayerControlView.h"
#import "DNVideoPlayerView+PlayControl.h"
#import "UIScrollView+DNListVideoPlayerAutoPlay.h"
#import <objc/runtime.h>
#import "DNPlayModelPropertiesObserver.h"


NS_ASSUME_NONNULL_BEGIN
static UIScrollView *_Nullable _getScrollViewOfPlayModel(DNPlayModel *playModel) {
    if (playModel.isPlayInTableView) {
        __kindof UIView *superview = playModel.playerSuperview;
        while ( superview && ![superview isKindOfClass:[UIScrollView class]] ) {
            superview = superview.superview;
        }
        return superview;
    }
    return nil;
}


@interface UIWindow (CurrentViewController)

/*!
 @method currentViewController
 @return Returns the topViewController in stack of topMostController.
 */
+ (UIViewController*)currentViewController;

@end

@implementation UIWindow (CurrentViewController)

+ (UIViewController*)currentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end




@interface DNVideoPlayerView ()<AVPDelegate,DNPlayerRotationManagerDelegate>
{
    DNPlayerRotationManager *_rotationManager;
}
/** 是否在cell上播放video */
@property (nonatomic, assign) BOOL isCellVideo;
/// 是否从后台进入前台
@property (nonatomic, assign) BOOL isBackgroundToActive;
@property (nonatomic, strong) NSTimer *sliderTimer;

@property (nonatomic, strong) DNPlayModel *playModel;




@property (nonatomic, strong, nullable) DNPlayModelPropertiesObserver *playModelObserver;
@end


@implementation DNVideoPlayerView

- (void)dealloc
{
    NSLog(@"DNVideoPlayerView-----%@释放了",[self class]);
}

- (void)releaseVideoPlayerView
{
//    [self.player releasePlayer];
    [self.player reset];
    [self removeNotifications];
    self.playModelObserver = nil;
    self.controlLayerDelegate = nil;

}

- (void)restPlayer
{
    [self.player reset];
    self.player = nil;
    self.playModelObserver = nil;
    self.controlLayerDelegate = nil;
}

- (void)removeNotifications
{
    // 添加检测app进入后台的观察者
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    //监听系统音量
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

+ (instancetype)dnVideoPlayerViewWithDelegate:(id<DNVideoPlayerViewDelegate>)delegate
{
    DNVideoPlayerView *playerView = [[DNVideoPlayerView alloc]init];
    playerView.videoPlayerDelegate = delegate;
    return playerView;
}

- (void)dn_addToSuperContainerView:(UIView *)containerView
{
    ///添加播放器容器视图
    if (containerView != nil) {
        [containerView addSubview:self.containerView];
        self.containerView.frame = containerView.bounds;
        if (self.player.superview == nil) {
            [self creatSubViews];
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化播放器
        [self creatSubViews];
        //初始化控制层
        [self configPlayControlAction];
        //添加通知
        [self addNotifications];
        //初始化旋转管理类
        [self rotationManager];
    }
    return self;
}

/// 播放器控制层初始化设置
- (void)setControlViewConfig:(DNPlayerControlViewConfig *)controlViewConfig
{
    _controlViewConfig = controlViewConfig;
    self.player.controlViewConfig = _controlViewConfig;
    self.isAnimateShowContainerView = _controlViewConfig.isAnimateShowContainerView;
    self.isShowBottomProgressView = _controlViewConfig.isShowBottomProgressView;
//    self.isShowSystemActivityLoadingView = _controlViewConfig.isShowSystemActivityLoadingView;
}

- (void)setCustomLoadingView:(UIImageView *)customLoadingView
{
    _customLoadingView = customLoadingView;
    if (_customLoadingView != nil) {
        self.player.controlView.isShowSystemActivityLoadingView = NO;
        self.player.controlView.customLoadingView = _customLoadingView;
    }
}

- (void)setIsShowRemaindTimeView:(BOOL)isShowRemaindTimeView
{
    _isShowRemaindTimeView = isShowRemaindTimeView;
    self.player.controlView.isShowRemaindTimeView = _isShowRemaindTimeView;
}

- (void)setIsShowBottomProgressView:(BOOL)isShowBottomProgressView
{
    _isShowBottomProgressView = isShowBottomProgressView;
    self.player.controlView.bottomProgress.hidden = !_isShowBottomProgressView;
    self.player.controlView.bottomloadingProgress.hidden = !_isShowBottomProgressView;
}

/// 是否动画显示播放器
- (void)setIsAnimateShowContainerView:(BOOL)isAnimateShowContainerView
{
    _isAnimateShowContainerView = isAnimateShowContainerView;
    if (_isAnimateShowContainerView) {
        _containerView.alpha = 0.001;
        @weakify(self)
        [UIView animateWithDuration:DNPlayerContainerShowTimeInterval animations:^{
            @strongify(self)
            self->_containerView.alpha = 1;
        }];
    }
}

- (id<DNPlayerRotationManagerProtocol>)rotationManager
{
    if ( _rotationManager ) {
        return _rotationManager;
    }
    _rotationManager = [[DNPlayerRotationManager alloc] init];
    [self _configRotationManager:_rotationManager];
    return _rotationManager;
}

- (void)stopAndFadeOutAnimated:(BOOL)isAnimate Completion:(void(^)(void))block
{
    if (isAnimate) {
        _containerView.alpha = 1;
        @weakify(self)
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self)
            self->_containerView.alpha = 0.001;
        } completion:^(BOOL finished) {
            [self->_containerView removeFromSuperview];
            [self restPlayer];
            if (block) block();
        }];

    }else{
        [_containerView removeFromSuperview];
        [self restPlayer];
        if (block) {
            block();
        }
    }
    
}

- (void)_configRotationManager:(id<DNPlayerRotationManagerProtocol>)rotationManager {
    rotationManager.superview = self.containerView;
    rotationManager.target = self.player;
    rotationManager.duration = 0.45;
    @weakify(self)
    rotationManager.rotationCondition = ^BOOL(id<DNPlayerRotationManagerProtocol>  _Nonnull mgr) {
        @strongify(self)
        //是否自动旋转的一些控制
        if ( !self ) return NO;
        if ( !self.containerView.superview ) return NO;
        //        if ( self.touchedScrollView ) return NO;
        //        if ( self.isPlayOnScrollView && !self.isScrollAppeared ) return NO;
        //        if ( self.isLockedScreen ) return NO;
        //        if ( self.registrar.state == DNVideoPlayerAppState_ResignActive ) return NO;
        //        if ( self.useFitOnScreenAndDisableRotation ) return NO;
        //        if ( self.vc_isDisappeared ) return NO;
        //        if ( self.isTriggeringForPopGesture ) return NO;
        return YES;
    };
    rotationManager.delegate = self;
}

#pragma mark 旋转管理类代理方法(将要旋转/已经旋转)
/// 将要旋转
- (void)rotationManager:(id<DNPlayerRotationManagerProtocol>)manager willRotateView:(BOOL)isFullscreen
{
//    if (isFullscreen) {
//        [self.player fullScreenMode];
//    }else{
//        [self.player smallScreenMode];
//    }
    //将要旋转时隐藏控制层.
    [self hideControlView];
}

/// 已经旋转
- (void)rotationManager:(id<DNPlayerRotationManagerProtocol>)manager didRotateView:(BOOL)isFullscreen
{
    self.fullScreen = isFullscreen;
}

- (void)addNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
//    // 添加检测app进入后台的观察者
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationWillResignActiveNotification object:nil];

    //监听系统音量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

}

- (void)creatSubViews
{
    [self.containerView addSubview:self.player];
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.containerView);
    }];
    self.mpVolumVC = [MPMusicPlayerController applicationMusicPlayer];
}


- (void)playVideoWithPlayModel:(DNPlayModel *)playModel completeBlock:(PlayerPublicBlock)completeBlock
{
    self.playModel = playModel;
    //获取系统音量
    [self configureVolume];
    //播放视频
    [self.player playVideoWithPlayModel:playModel playerDelegate:self completeBlock:completeBlock];

    // 维护当前播放的indexPath
    UIScrollView *scrollView = _getScrollViewOfPlayModel(playModel);
    if (scrollView.dn_enabledAutoplay ) {
        scrollView.dn_currentPlayingIndexPath = [playModel performSelector:@selector(indexPath)];
    }

    self.playModelObserver = [[DNPlayModelPropertiesObserver alloc]initWithPlayModel:playModel];
    self.playModelObserver.delegate = (id)self;
    self.controlLayerDelegate = (id)self;
}

- (void)setPlayerDisplayMode:(AVPScalingMode)displayMode
{
    self.player.displayMode = displayMode;
}

#pragma mark - 通知事件
-(void)volumeChanged:(NSNotification *)notification
{
    NSString * volume = notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"];
    if([volume floatValue]>0){
        self.player.controlView.isVolumeSelected = YES;
    }else if ([volume floatValue] == 0){
        self.player.controlView.isVolumeSelected = NO;
    }
}

-(void)applicationEnterBackground
{
    if (self.player.playerState == AVPStatusStarted ||
        self.player.playerState == AVPStatusIdle) {
        [self playerPause];
    }
}

-(void)applicationBecomeActive
{
    if (self.player.playerState == AVPStatusPaused ||
        self.player.playerState == AVPStatusIdle) {
        self.isBackgroundToActive = YES;
        [self playerPlay];
    }
}

/// 设置静音(YES静音 NO不静音)
- (void)setPlayerMuteMode:(BOOL)isMute
{
    self.player.isMuteMode = isMute;
}

- (void)playerPlay
{
    self.player.controlView.showPlayBtn = NO;
    [self.player resume];
}

- (void)playerPause
{
    self.player.controlView.showPlayBtn = YES;
    [self.player pause];
}

/// 播放器重新播放
- (void)playerReplay
{
    [self.player replay];
}

- (void)setLoopPlay:(BOOL)loop {
    
    [self.player setLoopPlay:loop];
    
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    self.player.controlView.isFullScreen = _fullScreen;
    //状态栏控制
    [[UIWindow currentViewController] setNeedsStatusBarAppearanceUpdate];
}

- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType {
    
    /**@brief 准备完成事件*/
    /****@brief Preparation completion event*/
    //AVPEventPrepareDone,
    /**@brief 自动启播事件*/
    /****@brief Autoplay start event*/
    //AVPEventAutoPlayStart,
    /**@brief 首帧显示时间*/
    /****@brief First frame display event*/
    //AVPEventFirstRenderedStart,
    /**@brief 播放完成事件*/
    /****@brief Playback completion event*/
    //AVPEventCompletion,
    /**@brief 缓冲开始事件*/
    /****@brief Buffer start event*/
    //AVPEventLoadingStart,
    /**@brief 缓冲完成事件*/
    /****@brief Buffer completion event*/
   // AVPEventLoadingEnd,
    /**@brief 跳转完成事件*/
    /****@brief Seeking completion event*/
   // AVPEventSeekEnd,
    /**@brief 循环播放开始事件*/
    /****@brief Loop playback start event*/
   // AVPEventLoopingStart,
    
    switch (eventType) {
        case AVPEventPrepareDone:{
            
            self.mProgressCanUpdate = YES;
            
            NSInteger playTime = self.player.totalDuration;
            NSString *totalTimeStr = [NSString stringWithFormat:@"%@",[DNVideoPlayerTools timeFormate:playTime]];
            
            self.player.controlView.totalTime = totalTimeStr;
            self.player.controlView.remaindTimeStr = totalTimeStr;
            
            self.player.controlView.showPlayBtn = NO;
            [self.player.controlView stopAtivityView];
            
            if (self.PlayerEventPrepareDone) {
                self.PlayerEventPrepareDone(nil);
            }
            
        }
            
        break;
         
        case AVPEventLoadingStart:{
            
            [self.player.controlView startActivityView];
            if (self.PlayerEventBeginLoading) {
                self.PlayerEventBeginLoading(nil);
            }
            
        }
            
            break;
        case AVPEventLoadingEnd:{
            
            [self.player.controlView stopAtivityView];
            if (self.PlayerEventEndLoading) {
                self.PlayerEventEndLoading(nil);
            }
            
        }
            
            break;
        case AVPEventFirstRenderedStart:{
            
            [self.player.controlView stopAtivityView];
            if (self.PlayerEventFirstFrame) {
                self.PlayerEventFirstFrame(nil);
            }
            
        }
            break;
           
        case AVPEventSeekEnd:{
            
            self.mProgressCanUpdate = YES;
            NSLog(@"**********AliyunVodPlayerEventSeekDone**********");
            if (self.PlayerEventSeekDone) {
                self.PlayerEventSeekDone(nil);
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}


- (void)onPlayerStatusChanged:(AliPlayer *)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus
{
    
    self.player.playerState = newStatus;
    self.player.isPlaying = YES;
    switch (newStatus) {
            
        case AVPStatusIdle:{
            [self.player.controlView startActivityView];
        }
            break;
            
            //暂停事件
        case AVPStatusPaused:{
            NSLog(@"**********AliyunVodPlayerEventPause**********");
            
            self.player.isPlaying = NO;
            
            if (self.PlayerEventPause) {
                self.PlayerEventPause(nil);
            }
//            [self.integralTimer setFireDate:[NSDate distantFuture]];
            
            
        }
            break;
            //播放事件
        case AVPStatusStarted: {
            NSLog(@"**********AliyunVodPlayerEventPlay**********");
            
            self.player.isPlaying = YES;
            
            if (self.PlayerEventPlay) {
                self.PlayerEventPlay(nil);
            }


        }
            break;

            //播放停止事件
        case AVPStatusStopped: {
            NSLog(@"**********AliyunVodPlayerEventStop**********");
            self.player.isPlaying = NO;
            if (self.PlayerEventStop) {
                self.PlayerEventStop(nil);
            }

        }

            break;
            
            //播放结束事件
        case AVPStatusCompletion:{
            NSLog(@"**********AliyunVodPlayerEventFinish**********");
            //强制播放器竖屏展示(横屏点击详情页的情况)
            [self.rotationManager rotate:DNOrientation_Portrait animated:YES];
            //1.广告播放结束展示广告结束页面
            //2.普通视频播放结束展示重新播放视图
            //3.展示重新播放视图,及自动播放下一个视频
            if (self.PlayerEventFinish) {
                self.PlayerEventFinish(nil);
            }
//            self.player.controlView.isShowAdPlayToEndView = YES;

            UIScrollView *scrollView = _getScrollViewOfPlayModel(self.playModel);
            if (scrollView.dn_enabledAutoplay ) {
//                if (self.playDidToEndExeBlock) {
//                    self.playDidToEndExeBlock(self);
//                }
                [scrollView dn_needPlayNextAsset];
                return;
            }
            //广告 -- 展示播放结束广告页面
        }
            break;
        
        default:
            break;
    }
}

- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel
{
    NSLog(@"===playBackErrorModel===%@",errorModel);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mProgressCanUpdate = YES;
//        [self.PlaceholderImageView setHidden:NO];
//        self.continuePlayButton.hidden = NO;
    });
}

/**
 @brief 视频当前播放位置回调
 @param player 播放器player指针
 @param position 视频当前播放位置
 */
/****
 @brief Current playback position callback.
 @param player Player pointer.
 @param position Current playback position.
 */
- (void)onCurrentPositionUpdate:(AliPlayer*)player position:(int64_t)position{
    
    if (self.player && self.mProgressCanUpdate) {
        
        NSString *currentTime = [DNVideoPlayerTools timeFormate:position/1000];
        
        self.player.controlView.currentTime = currentTime;
        
        //当前播放的时间
        if (self.PlayerChangeCurrentTimeBlock) {
            self.PlayerChangeCurrentTimeBlock(currentTime);
        }
        
        if (self.isShowRemaindTimeView) {
            NSString *remaindTime = [DNVideoPlayerTools timeFormate:(self.player.totalDuration - self.player.currentTime)];
            self.player.controlView.remaindTimeStr = remaindTime;
        }
        
        if(self.player.currentTime > 0 &&
           self.player.totalDuration > 0) {

            CGFloat Value = round(self.player.currentTime)/self.player.totalDuration;
            self.player.controlView.proSliderValue = Value;
            //播放的进度
            if (self.PlayerChangeCurrentValueBlock) {
                self.PlayerChangeCurrentValueBlock(Value);
            }
            
            
        }
        
        
    }
    
}

/**
 @brief 视频缓存位置回调
 @param player 播放器player指针
 @param position 视频当前缓存位置
 */
/****
 @brief Current cache position callback.
 @param player Player pointer.
 @param position Current cache position.
 */
- (void)onBufferedPositionUpdate:(AliPlayer*)player position:(int64_t)position {
    
    CGFloat progress = (CGFloat)position/(CGFloat)(self.player.totalDuration*1000);
    
    self.player.controlView.loadingValue = (CGFloat)position/(CGFloat)(self.player.totalDuration*1000);
    //缓存的进度
    if (self.PlayerChangeLoadingValueBlock) {
        self.PlayerChangeLoadingValueBlock(progress);
    }
    
}
// 缓存进度
- (void)onLoadingProgress:(AliPlayer *)player progress:(float)progress {
    
    
    
}
// 实现,否则崩溃
- (void)onSEIData:(AliPlayer *)player type:(int)type data:(NSData *)data {
    
    
    
}

#pragma mark - 懒加载
// 播放器
- (DNPlayer *)player
{
    if (!_player) {
        _player = [DNPlayer sharedDNPlayer];
    }
    return _player;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

@end

NS_ASSUME_NONNULL_END
