//
//  DNPlayerControlView.m
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import "DNPlayerControlView.h"
/// 播放结束视图
#import "DNAdPlayToEndView.h"
#import "UIView+CTLayout.h"



@interface DNPlayerControlView ()

/** 中心播放暂停按钮 */
@property (nonatomic, strong) UIButton *centerPlayBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *loadingProgressView;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton *lockBtn;
/** 快进快退label */
@property (nonatomic, strong) UILabel *horizontalLabel;
/** 系统菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton *backBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton *repeatBtn;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton *volumBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView *topImageView;

/// 播放结束垫底图
@property (nonatomic, strong) DNAdPlayToEndView *adEndView;

/**
 时间显示底色
 */
@property (nonatomic, strong) UIImageView *totleTimeImageView;
/**
 显示时间label
 */
@property (nonatomic, strong) UILabel *remaindTimeLabel;


@end

@implementation DNPlayerControlView

- (void)dealloc
{
    NSLog(@"%@释放了",[self class]);
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.volumBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.loadingProgressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.bottomImageView addSubview:self.fullScreenBtn];

        [self addSubview:self.lockBtn];
        [self addSubview:self.backBtn];
        [self addSubview:self.centerPlayBtn];
        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.horizontalLabel];

        //播放器底部添加进度条视图
        [self addSubview:self.bottomloadingProgress];
        [self addSubview:self.bottomProgress];

        //倒计时label
        [self addSubview:self.totleTimeImageView];
        
        //添加播放结束垫底图
        [self addSubview:self.adEndView];

        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        [self.activity stopAnimating];
        self.horizontalLabel.hidden = YES;
        self.repeatBtn.hidden       = YES;
        // 初始化时重置controlView
        [self resetControlView];


    }
    return self;
}

- (void)makeSubViewsConstraints
{
    @weakify(self)
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self.volumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.equalTo(self.volumBtn.mas_trailing).offset(2);
        make.centerY.equalTo(self.volumBtn.mas_centerY);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.volumBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(-2);
        make.centerY.equalTo(self.volumBtn.mas_centerY);;
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(8);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-8);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-0.25);
        make.height.mas_equalTo(30);
    }];

    [self.loadingProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(8);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-8);
        make.centerY.equalTo(self.videoSlider.mas_centerY).offset(1);
    }];
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.equalTo(self.mas_leading).offset(15);
        make.top.equalTo(self.mas_top).offset(15);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.horizontalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
        make.center.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.center.equalTo(self);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.center.equalTo(self);
    }];

    [self.centerPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    [self.bottomloadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(5);
    }];
    
    [self.bottomProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(5);
    }];

    //设置播放结束视图约束
    [self.adEndView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];


}


#pragma mark - Public Method
- (void)startActivityView
{
    if (self.isShowSystemActivityLoadingView) {
        [self.activity startAnimating];
    }else{
        [self startCustomLoadingAnimation];
    }
}

- (void)stopAtivityView
{
    if (self.isShowSystemActivityLoadingView) {
        [self.activity stopAnimating];
    }else{
        [self stopCustomLoadingAnimation];
    }
}


/** 重置ControlView */
- (void)resetControlView
{
    self.videoSlider.value = 0;
    self.loadingProgressView.progress = 0;
    self.bottomProgress.progress = 0;
    self.bottomloadingProgress.progress = 0;
    self.currentTimeLabel.text = @"00:00";
    self.totalTimeLabel.text = @"00:00";
    self.adEndView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)showControlView
{
    if (!_controlViewConfig.isShowControlView) {return;}
    
    self.topImageView.alpha = 1;
    self.bottomImageView.alpha = 1;
    self.lockBtn.alpha = 1;
    self.backBtn.alpha = 1;
    self.centerPlayBtn.alpha = 1;
    self.bottomProgress.alpha = 0;
    self.bottomloadingProgress.alpha = 0;
    
}

- (void)hideControlView
{
    self.topImageView.alpha = 0;
    self.bottomImageView.alpha = 0;
    self.lockBtn.alpha = 0;
    self.backBtn.alpha = 0;
    self.centerPlayBtn.alpha = 0;
    self.bottomProgress.alpha = 1;
    self.bottomloadingProgress.alpha = 1;
}

- (void)setIsShowRemaindTimeView:(BOOL)isShowRemaindTimeView
{
    _isShowRemaindTimeView = isShowRemaindTimeView;
    self.totleTimeImageView.hidden = !_isShowRemaindTimeView;
    self.remaindTimeLabel.hidden = !_isShowRemaindTimeView;
}

- (void)setIsShowAdPlayToEndView:(BOOL)isShowAdPlayToEndView
{
    _isShowAdPlayToEndView = isShowAdPlayToEndView;
    self.adEndView.hidden = !_isShowAdPlayToEndView;
}

#pragma mark Actions
- (void)centerPlayBtnClick:(UIButton *)btn
{
    if (self.playAndPauseClickBlock) {
        self.playAndPauseClickBlock(btn);
    }
}

- (void)volumBtnClick:(UIButton *)btn
{
    if (self.volumeOnOrOffClickBlock) {
        self.volumeOnOrOffClickBlock(btn);
    }
}

- (void)fullScreenBtnClick:(UIButton *)btn
{
    if (self.fullScreenBtnClickBlock) {
        self.fullScreenBtnClickBlock(btn);
    }
}

//- (void)fullScreenBtnToScaleSmall
//{
//    if (self.fullScreenBtnClickBlock) {
//        self.fullScreenBtn.selected = YES;
//        self.fullScreenBtnClickBlock(self.fullScreenBtn);
//    }
//}

- (void)backBtnClick:(UIButton *)btn
{
    if (self.backBtnClickBlock) {
        self.backBtnClickBlock(btn);
    }
}

#pragma mark - setter
- (void)setControlViewConfig:(DNPlayerControlViewConfig *)controlViewConfig
{
    _controlViewConfig = controlViewConfig;
    //点播,直播界面设置
    switch (_controlViewConfig.controlViewType) {
        case PlayerControlViewType_Vod:
            //点播

            break;

        case PlayerControlViewType_Live:
            //直播

            break;

        default:
            break;
    }
    //返回按钮设置
    self.backBtn.hidden = !controlViewConfig.isShowBackBtn;
    //loading加载视图
    self.isShowSystemActivityLoadingView = controlViewConfig.isShowSystemActivityLoadingView;
    if (!self.isShowSystemActivityLoadingView) {
        self.activity.hidden = YES;
        self.customLoadingView = controlViewConfig.customLoadingView;
    }else{
        self.activity.hidden = NO;
    }
    //底部进度条相关设置
    if (controlViewConfig.bottomProgressTintColor != nil) {
        self.bottomProgress.progressTintColor = controlViewConfig.bottomProgressTintColor;
    }
    
    if (controlViewConfig.bottomLoadingTintColor != nil) {
        self.bottomloadingProgress.progressTintColor = controlViewConfig.bottomLoadingTintColor;
    }
    
    if (controlViewConfig.bottomProgressView_H != 0) {
        [self.bottomloadingProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(controlViewConfig.bottomProgressView_H);
        }];

        [self.bottomProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(controlViewConfig.bottomProgressView_H);
        }];
    }
}


- (void)setIsShowSystemActivityLoadingView:(BOOL)isShowSystemActivityLoadingView
{
    _isShowSystemActivityLoadingView = isShowSystemActivityLoadingView;
    if (!_isShowSystemActivityLoadingView) {
        
        self.activity.hidden = YES;
        self.customLoadingView = self.customLoadingView;
        
    }else{
        self.activity.hidden = NO;
    }
}

/// 自定义加载视图
- (void)setCustomLoadingView:(UIImageView *)customLoadingView
{
    if (![_customLoadingView isEqual:customLoadingView]) {
        _customLoadingView = customLoadingView;
        _customLoadingView.hidden = YES;
        [self insertSubview:_customLoadingView aboveSubview:self.activity];
        @weakify(self)
        [_customLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.center.equalTo(self);
        }];
        
    }
}

- (void)startCustomLoadingAnimation
{
    self.customLoadingView.hidden = NO;
    //添加动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1;
    animation.cumulative = YES;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = ULLONG_MAX;
    [self.customLoadingView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)stopCustomLoadingAnimation
{
    [self.customLoadingView.layer removeAllAnimations];
    self.customLoadingView.hidden = YES;
}


- (void)setTotalTime:(NSString *)totalTime
{
    _totalTime = totalTime;
    self.totalTimeLabel.text = _totalTime;
}

- (void)setCurrentTime:(NSString *)currentTime
{
    _currentTime = currentTime;
    self.currentTimeLabel.text = _currentTime;
}

- (void)setRemaindTimeStr:(NSString *)remaindTimeStr
{
    _remaindTimeStr = remaindTimeStr;
    self.remaindTimeLabel.text = _remaindTimeStr;
    [self.remaindTimeLabel sizeToFit];
    self.remaindTimeLabel.ct_height = 25.0f;
    self.totleTimeImageView.ct_width = self.remaindTimeLabel.ct_width + 14;
    self.remaindTimeLabel.ct_left = 7;
    self.totleTimeImageView.ct_left = SCREEN_WIDTH-12-self.totleTimeImageView.ct_width;
    self.totleTimeImageView.ct_top = self.ct_height-12-self.totleTimeImageView.ct_height;
}

- (void)setSlidChangeValue:(CGFloat)slidChangeValue
{
    _slidChangeValue = slidChangeValue;
    self.bottomProgress.progress = _slidChangeValue;
}

- (void)setProSliderValue:(CGFloat)proSliderValue
{
    _proSliderValue = proSliderValue;
    [self.videoSlider setValue:_proSliderValue animated:YES];
    self.bottomProgress.progress = _proSliderValue;
}

- (void)setLoadingValue:(CGFloat)loadingValue
{
    _loadingValue = loadingValue;
    [self.loadingProgressView setProgress:_loadingValue];
    self.bottomloadingProgress.progress  = _loadingValue;
}

- (void)setShowPlayBtn:(BOOL)showPlayBtn
{
    _showPlayBtn = showPlayBtn;
    self.centerPlayBtn.selected = !_showPlayBtn;
}

- (void)setIsfullScreenBtnSelected:(BOOL)isfullScreenBtnSelected
{
    _isfullScreenBtnSelected = isfullScreenBtnSelected;
    self.fullScreenBtn.selected = _isfullScreenBtnSelected;
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    self.isfullScreenBtnSelected = _isFullScreen;
    //全屏的时候显示返回按钮
    if (_isFullScreen) {
        self.backBtn.hidden = NO;
    }else{
        self.backBtn.hidden = !self.controlViewConfig.isShowBackBtn;
    }
}

- (void)setIsVolumeSelected:(BOOL)isVolumeSelected
{
    _isVolumeSelected = isVolumeSelected;
    self.volumBtn.selected = _isVolumeSelected;
}


#pragma mark - getter

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageWithImageName:@"player_whiteBack_icon" inBundle:self.resourceBundle] forState:UIControlStateNormal];
//         [UIImage ca_imageName:@"player_whiteBack_icon" inBundle:DNPlaceholderResource] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        [_topImageView setImage:[UIImage imageWithImageName:@"player_shadowTop_icon" inBundle:self.resourceBundle]];
//        [_topImageView setImage:[UIImage ca_imageName:@"player_shadowTop_icon" inBundle:DNPlaceholderResource]];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        [_bottomImageView setImage:[UIImage imageWithImageName:@"player_shadowBottom_icon" inBundle:self.resourceBundle]];
//        [_bottomImageView setImage:[UIImage ca_imageName:@"player_shadowBottom_icon" inBundle:DNPlaceholderResource]];
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn
{
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_lockBtn setImage:[UIImage imageNamed:ZFPlayerSrcName(@"unlock-nor")] forState:UIControlStateNormal];
//        [_lockBtn setImage:[UIImage imageNamed:ZFPlayerSrcName(@"lock-nor")] forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (UIButton *)volumBtn
{
    if (!_volumBtn) {
        _volumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _volumBtn.selected = NO;
        _volumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_volumBtn setImage:[UIImage imageWithImageName:@"player_volumeOn_icon" inBundle:self.resourceBundle] forState:UIControlStateNormal];
//        [_volumBtn setImage:[UIImage ca_imageName:@"player_volumeOn_icon" inBundle:DNPlaceholderResource] forState:UIControlStateNormal];
        [_volumBtn setImage:[UIImage imageWithImageName:@"player_volumeOff_icon" inBundle:self.resourceBundle] forState:UIControlStateSelected];
//        [_volumBtn setImage:[UIImage ca_imageName:@"player_volumeOff_icon" inBundle:DNPlaceholderResource] forState:UIControlStateSelected];
        [_volumBtn addTarget:self action:@selector(volumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_volumBtn setImage:[UIImage imageNamed:ZFPlayerSrcName(@"kr-video-player-play")] forState:UIControlStateNormal];
//        [_volumBtn setImage:[UIImage imageNamed:ZFPlayerSrcName(@"kr-video-player-pause")] forState:UIControlStateSelected];
    }
    return _volumBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _currentTimeLabel;
}

- (UIProgressView *)loadingProgressView
{
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _loadingProgressView.progressTintColor = [UIColor redColor];//[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        _loadingProgressView.trackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];

    }
    return _loadingProgressView;
}

- (UISlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc] init];
        // 设置slider
        [_videoSlider setThumbImage:[UIImage imageWithImageName:@"player_sliderDot_icon" inBundle:self.resourceBundle] forState:UIControlStateNormal];

        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];//[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_fullScreenBtn setImage:[UIImage imageWithImageName:@"player_scaleFull_icon" inBundle:self.resourceBundle] forState:UIControlStateNormal];

//        [_fullScreenBtn setImage:[UIImage ca_imageName:@"player_scaleFull_icon" inBundle:DNPlaceholderResource] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageWithImageName:@"player_scaleSmall_icon" inBundle:self.resourceBundle] forState:UIControlStateSelected];

//        [_fullScreenBtn setImage:[UIImage ca_imageName:@"player_scaleSmall_icon" inBundle:DNPlaceholderResource] forState:UIControlStateSelected];

        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_fullScreenBtn setImage:[UIImage imageNamed:ZFPlayerSrcName(@"kr-video-player-fullscreen")] forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}

- (UILabel *)horizontalLabel
{
    if (!_horizontalLabel) {
        _horizontalLabel = [[UILabel alloc] init];
        _horizontalLabel.textColor = [UIColor whiteColor];
        _horizontalLabel.textAlignment = NSTextAlignmentCenter;
        // 设置快进快退label
//        _horizontalLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:ZFPlayerSrcName(@"Management_Mask")]];
    }
    return _horizontalLabel;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activity;
}

- (UIButton *)repeatBtn
{
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_repeatBtn setImage:[UIImage imageNamed:ZFPlayerSrcName(@"repeat_video")] forState:UIControlStateNormal];
    }
    return _repeatBtn;
}


- (UIImage *)imageWithImageName:(NSString *)imageName inBundle:(nullable NSBundle *)bundle
{
    UIImage *image = [[UIImage imageNamed:imageName inBundle:self.resourceBundle compatibleWithTraitCollection:nil]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

- (UIButton *)centerPlayBtn
{
    if (!_centerPlayBtn) {
        _centerPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_centerPlayBtn setImage:[UIImage imageWithImageName:@"player_playBtn_icon" inBundle:self.resourceBundle] forState:UIControlStateNormal];


        [_centerPlayBtn setImage:[UIImage imageWithImageName:@"player_pause_icon" inBundle:self.resourceBundle] forState:UIControlStateSelected];

        [_centerPlayBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _centerPlayBtn.selected = YES;
        //        [_centerPlayBtn setImage:[UIImage imageNamed:ZFPlayerSrcName(@"repeat_video")] forState:UIControlStateNormal];
    }
    return _centerPlayBtn;
}

- (UIProgressView *)bottomloadingProgress
{
    if (!_bottomloadingProgress) {
        _bottomloadingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bottomloadingProgress.trackTintColor = [UIColor grayColor];
        _bottomloadingProgress.progressTintColor = [UIColor lightGrayColor];
        _bottomloadingProgress.alpha = 1;
    }
    return _bottomloadingProgress;
}

- (UIProgressView *)bottomProgress
{
    if (!_bottomProgress) {
        _bottomProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bottomProgress.trackTintColor = [UIColor clearColor];
        _bottomProgress.progressTintColor = [UIColor orangeColor];
        _bottomProgress.alpha = 1;
    }
    return _bottomProgress;
}


- (DNAdPlayToEndView *)adEndView
{
    if (!_adEndView) {
        _adEndView = [DNAdPlayToEndView dnAdPlayToEndView];
        _adEndView.hidden = YES;
        @weakify(self)
        [_adEndView setReplayBtnClickBlock:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.adEndViewReplayClickBlock) {
                self.adEndViewReplayClickBlock(sender);
            }
        }];
    }
    return _adEndView;
}


- (UIImageView *)totleTimeImageView {
    
    if (!_totleTimeImageView) {
        _totleTimeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
        _totleTimeImageView.backgroundColor = [UIColor clearColor];
        _totleTimeImageView.image = [UIImage imageWithImageName:@"main_newsFeed_photoIcon" inBundle:self.resourceBundle];
        [_totleTimeImageView addSubview:self.remaindTimeLabel];
    }
    
    return _totleTimeImageView;
}

- (UILabel *)remaindTimeLabel
{
    if (!_remaindTimeLabel) {
        _remaindTimeLabel = [[UILabel alloc] init];
        _remaindTimeLabel.frame = CGRectMake(0, 0, 0, 0);
        _remaindTimeLabel.text = @"";
        _remaindTimeLabel.textAlignment = NSTextAlignmentCenter;
        _remaindTimeLabel.textColor = [UIColor whiteColor];
        _remaindTimeLabel.font = [UIFont systemFontOfSize:16.0f];
        _remaindTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _remaindTimeLabel;
}

@end
