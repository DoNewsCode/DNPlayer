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




@interface DNVideoPlayerView ()<AliyunVodPlayerDelegate,DNPlayerRotationManagerDelegate>
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
    self.playModelObserver = nil;
    self.controlLayerDelegate = nil;
}

- (void)removeNotifications
{
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    //监听系统音量
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

+ (instancetype)dnVideoPlayerViewWithDelegate:(id<DNVideoPlayerViewDelegate>)delegate
{
    DNVideoPlayerView *playerView = [[DNVideoPlayerView alloc]init];
    playerView.videoPlayerDelegate = delegate;
    return playerView;
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

- (void)stopAndFadeOutCompletion:(void(^)(UIView *view))block
{
    [self.containerView dn_fadeOutAndCompletion:^(UIView *view) {
        [view removeFromSuperview];
        [self restPlayer];
        if (block) {
            block(nil);
        }
    }];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationWillResignActiveNotification object:nil];

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
    if (self.player.playerState == AliyunVodPlayerStatePlay ||
        self.player.playerState == AliyunVodPlayerStateIdle) {
        [self playerPause];
    }
}

-(void)applicationBecomeActive
{
    if (self.player.playerState == AliyunVodPlayerStatePause ||
        self.player.playerState == AliyunVodPlayerStateIdle) {
        self.isBackgroundToActive = YES;
        [self playerPlay];
    }
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

- (void)setFullScreen:(BOOL)fullScreen
{
    _fullScreen = fullScreen;
    self.player.controlView.isFullScreen = _fullScreen;
    //状态栏控制
    [[UIWindow currentViewController] setNeedsStatusBarAppearanceUpdate];
}


- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event
{
    switch (event) {
            //准备播放
        case AliyunVodPlayerEventPrepareDone:{
            NSLog(@"**********AliyunVodPlayerEventPrepareDone**********");
            //TODO: 设置时间, 界面设置, 缓冲视图控制
            NSInteger playTime = self.player.totalDuration;
            self.player.controlView.totalTime = [NSString stringWithFormat:@"%@",[DNVideoPlayerTools timeFormate:playTime]];
//
            self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sliderTimerRun:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.sliderTimer forMode:NSDefaultRunLoopMode];
            self.player.controlView.showPlayBtn = NO;
            [self.player.controlView stopAtivityView];
//            self.playView.hidden = NO;
//            self.loadIndicatorView.hidden = YES;
        }
            break;
            //暂停事件
        case AliyunVodPlayerEventPause:{
            NSLog(@"**********AliyunVodPlayerEventPause**********");
//            [self.integralTimer setFireDate:[NSDate distantFuture]];
            
        }
            break;
            //播放事件
        case AliyunVodPlayerEventPlay: {
            NSLog(@"**********AliyunVodPlayerEventPlay**********");

//            [self.integralTimer setFireDate:[NSDate distantPast]];
//            self.loadIndicatorView.hidden = YES;
//            self.PlaceholderImageView.hidden = YES;
//            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
            break;

            //播放停止事件
        case AliyunVodPlayerEventStop: {
            NSLog(@"**********AliyunVodPlayerEventStop**********");
//            isStop  = YES;
//            self.playButton.selected = NO;
            //阻止设备自动锁屏
//            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//
//
        }

            break;
            
            //开始加载事件
        case AliyunVodPlayerEventBeginLoading: {
            NSLog(@"**********AliyunVodPlayerEventBeginLoading**********");
            [self.player.controlView startActivityView];
//            [self bringSubviewToFront:self.loadIndicatorView];
//            self.loadIndicatorView.hidden  = NO;
//            self.playView.hidden = YES;
        }
            
            break;
            //加载结束事件
        case AliyunVodPlayerEventEndLoading: {
            NSLog(@"**********AliyunVodPlayerEventEndLoading**********");
            [self.player.controlView stopAtivityView];
//            self.loadIndicatorView.hidden  = YES;
//            [self sendSubviewToBack:self.loadIndicatorView];
//            self.playView.hidden = NO;
            
        }
            break;
            
            //播放结束事件
        case AliyunVodPlayerEventFinish:{
            NSLog(@"**********AliyunVodPlayerEventFinish**********");
            //强制播放器竖屏展示(横屏点击详情页的情况)
            [self.rotationManager rotate:DNOrientation_Portrait animated:YES];
            //1.广告播放结束展示广告结束页面
            //2.普通视频播放结束展示重新播放视图
            //3.展示重新播放视图,及自动播放下一个视频
            self.player.controlView.isShowAdPlayToEndView = YES;

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
            //获取到第一帧事件
        case AliyunVodPlayerEventFirstFrame:{
            NSLog(@"**********AliyunVodPlayerEventFirstFrame**********");
            [self.player.controlView stopAtivityView];
//            self.loadIndicatorView.hidden  = YES;
//            self.PlaceholderImageView.hidden = YES;
//            [DNNetworkTool sharedInstance].isStopMonitoring = YES;
//            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            
//            if(!PointsFunctionHidden){
//                if (isLogIn) {
//                    if (!self.isQuanZi) {
//
//
//                        //是否给积分开关
//                        if (![DNConfigManager sharedInstance].score) {
//                            return;
//                        }
//
//
//                        NSTimeInterval TimeValue;
//
//                        NSDictionary * Dic =  [DNConfigManager sharedInstance].readtime;
//
//                        if ([Dic objectForKey:@"video"]) {
//
//                            NSString * string = [Dic objectForKey:@"video"];
//
//                            TimeValue = string.intValue;
//                        }
//                        else{
//
//                            TimeValue = 15.f;
//
//                        }
//
//
//                        self.integralTimer = [NSTimer scheduledTimerWithTimeInterval:TimeValue target:self selector:@selector(addIntegral:) userInfo:@"视频计时器" repeats:NO];
//                        [[NSRunLoop currentRunLoop] addTimer:self.integralTimer forMode:NSDefaultRunLoopMode];
//                    }
//
//                }
//            }
        }
            //快退快进完成事件
        case AliyunVodPlayerEventSeekDone:{
            self.mProgressCanUpdate = YES;
            NSLog(@"**********AliyunVodPlayerEventSeekDone**********");
        }
        default:
            break;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel
{
    NSLog(@"===playBackErrorModel===%@",errorModel);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mProgressCanUpdate = YES;
//        [self.PlaceholderImageView setHidden:NO];
//        self.continuePlayButton.hidden = NO;
    });
}


- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer willSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition
{
    NSLog(@"===willSwitchToQuality===");
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer didSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition
{
    NSLog(@"===didSwitchToQuality===");
}

- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition
{
    
}

- (void)onCircleStartWithVodPlayer:(AliyunVodPlayer*)vodPlayer
{
    
}
/*
 *功能：播放器鉴权数据过期。
 */
- (void)onTimeExpiredErrorWithVodPlayer:(AliyunVodPlayer *)vodPlayer
{
    
}

/*
 *功能：播放地址存在过期时间，此时播放地址过期时提供的回调消息
 *参数：videoid：过期时播放的videoId
 *参数：quality：过期时播放的清晰度，playauth播放方式和STS播放方式有效。
 *参数：videoDefinition：过期时播放的清晰度，MTS播放方式时有效。
 */
- (void)vodPlayerPlaybackAddressExpiredWithVideoId:(NSString *)videoId quality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition
{
    
}

#pragma mark - 进度条
- (void)sliderTimerRun:(NSTimer *)sender
{

    if (self.player && self.mProgressCanUpdate) {

        self.player.controlView.currentTime = [DNVideoPlayerTools timeFormate:self.player.currentTime];
        
        if(self.player.currentTime > 0 &&
           self.player.totalDuration > 0) {

            CGFloat Value = round(self.player.currentTime)/self.player.totalDuration;
            self.player.controlView.proSliderValue = Value;
        }
        CGFloat cacheValue = round(self.player.loadedTime)/self.player.totalDuration;
        if (cacheValue>0) {
            self.player.controlView.loadingValue = cacheValue;
        }
    }
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
        _containerView.backgroundColor = [UIColor blackColor];
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
