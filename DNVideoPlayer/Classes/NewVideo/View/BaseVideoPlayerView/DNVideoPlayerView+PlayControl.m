//
//  DNVideoPlayerView+PlayControl.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/6.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import "DNVideoPlayerView+PlayControl.h"

@implementation DNVideoPlayerView (PlayControl)


- (void)configPlayControlAction
{
    //进度条的拖拽事件
    [self.player.controlView.videoSlider addTarget:self action:@selector(slideValueChanged:)  forControlEvents:UIControlEventValueChanged];
    //进度条的点击事件
    [self.player.controlView.videoSlider addTarget:self action:@selector(seekToTimeProgress:) forControlEvents:UIControlEventTouchUpInside];
    //给进度条添加单击手势
    self.progressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.progressTap.delegate = self;
    [self.player.controlView.videoSlider addGestureRecognizer:self.progressTap];

    //全屏按钮
    @weakify(self)
    [self.player.controlView setFullScreenBtnClickBlock:^(id sender) {
        @strongify(self)
        [self fullScreenAction:sender];

    }];

    //返回按钮
    [self.player.controlView setBackBtnClickBlock:^(id sender) {
        @strongify(self)
        [self backBtnAction:sender];
    }];

    //暂停播放按钮
    [self.player.controlView setPlayAndPauseClickBlock:^(id sender) {
        @strongify(self)
        [self playAndPauseBtnAction];
    }];

    //静音按钮事件
    [self.player.controlView setVolumeOnOrOffClickBlock:^(id sender) {
        @strongify(self)
        [self volumeBtnClickAction:sender];
    }];

    //重新播放事件
    [self.player.controlView setAdEndViewReplayClickBlock:^(id sender) {
         @strongify(self)
        [self replayCurrentVideoItem];

    }];

    [self createGesture];

}


//创建手势
- (void)createGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.player.controlView addGestureRecognizer:tap];
}

#pragma mark - 点击屏幕方法
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isMaskShowing) {
            [self hideControlView];
        } else {
            [self animateShow];
        }
    }
}


#pragma mark 隐藏控制层
- (void)hideControlView
{
    if (!self.isMaskShowing) {
        return;
    }
    @weakify(self)
    [UIView animateWithDuration:DNPlayerControlBarAutoFadeOutTimeInterval animations:^{
        @strongify(self)
        [self.player.controlView hideControlView];
    }completion:^(BOOL finished) {
        self.isMaskShowing = NO;
    }];
}

#pragma mark 显示控制层
- (void)animateShow
{
    if (self.isMaskShowing) {
        return;
    }
    @weakify(self)
    [UIView animateWithDuration:DNPlayerControlBarAutoFadeOutTimeInterval animations:^{
        @strongify(self)
        [self.player.controlView showControlView];
    } completion:^(BOOL finished) {
        self.isMaskShowing = YES;
        [self autoFadeOutControlBar];
    }];
}


#pragma mark - ShowOrHideControlView
- (void)autoFadeOutControlBar
{
    if (!self.isMaskShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:DNPlayerAnimationTimeInterval];
}

/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark 全屏按钮事件(放大/缩小)
- (void)fullScreenAction:(UIButton *)sender
{
    if (sender.selected) {
        //缩小
        [self scaleSmallTo_Orientation_Portrait];
        sender.selected = NO;
    }else{
        //放大
        [self scaleFullTo_Orientation_LandscapeLeft];
        sender.selected = YES;
    }
}

- (void)scaleSmallTo_Orientation_Portrait
{
    [self.rotationManager rotate:DNOrientation_Portrait animated:YES];
}

- (void)scaleFullTo_Orientation_LandscapeLeft
{
    [self.rotationManager rotate:DNOrientation_LandscapeLeft animated:YES];;
}


#pragma mark 返回按钮事件
- (void)backBtnAction:(UIButton *)sender
{
    if (self.isFullScreen) {
        //缩小
        [self scaleSmallTo_Orientation_Portrait];
        
    }else{
        //退出播放器
        NSLog(@"退出播放器");
        //清空播放器
        [self.player reset];
        UIViewController *rootVC = [UIViewController ca_currentTopViewController];
        [rootVC.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 重新播放当前视频
- (void)replayCurrentVideoItem
{
    [self.player.controlView resetControlView];
    [self.player replay];
}

#pragma mark 播放暂停事件
- (void)playAndPauseBtnAction
{
    //选中则暂停
    if (self.player.controlView.isShowPlayBtn) {
        [self playerPlay];
    }else{
        [self playerPause];
    }
}

#pragma mark 音量按钮事件
- (void)volumeBtnClickAction:(UIButton *)btn
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //选中则静音
    if (btn.selected) {
        btn.selected = NO;
        self.mpVolumVC.volume = 0.3;
    }else{
        btn.selected = YES;
        self.mpVolumVC.volume = 0;

    }
#pragma clang diagnostic pop
}

//获取系统音量
- (void)configureVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    if (!success) { /* handle the error in setCategoryError */ }
}

#pragma mark 进度条值改变
- (void)slideValueChanged:(UISlider *)slider
{
    self.mProgressCanUpdate = NO;
    NSLog(@"slideValueChanged----value = %f----",slider.value);
    //滑动时--时间同步改变
    self.player.controlView.currentTime = [DNVideoPlayerTools timeFormate:(self.player.totalDuration * slider.value)];
    //滑动时--进度值同步改变
    self.player.controlView.slidChangeValue = slider.value;
}

//播放进度
- (void)seekToTimeProgress:(UISlider *)slider
{
    [self playerSeekToTimeWithValue:slider.value];
}

//视频进度条的点击事件
- (void)actionTapGesture:(UITapGestureRecognizer *)sender
{
    CGPoint touchLocation = [sender locationInView:self.player.controlView.videoSlider];
    CGFloat value = (self.player.controlView.videoSlider.maximumValue - self.player.controlView.videoSlider.minimumValue) * (touchLocation.x/self.player.controlView.videoSlider.frame.size.width);

    self.player.controlView.proSliderValue = value;

    [self playerSeekToTimeWithValue:value];
    //    if (self.player.rate != 1.f) {
    //        self.playOrPauseBtn.selected = NO;
    //        [self.player play];
    //    }
}

- (void)playerSeekToTimeWithValue:(CGFloat)value
{
    //AliyunVodPlayerEventFirstFrame在此状态之后调用
    if (self.player.playerState == AliyunVodPlayerStateLoading ||
        self.player.playerState == AliyunVodPlayerStatePause ||
        self.player.playerState == AliyunVodPlayerStatePlay)
    {
        self.mProgressCanUpdate = NO;
        NSLog(@"快进的时间s-------%f",(self.player.totalDuration * value));
        [self.player seekToTime:(self.player.totalDuration * value)];
    }
}


- (void)videoPlayerWillAppearInScrollView:(__kindof DNVideoPlayerView *)videoPlayer
{
    NSLog(@"videoPlayerWillAppearInScrollView---播放器将要出现");
    //1.播放器继续播放操作
    [videoPlayer playerPlay];
}

- (void)videoPlayerWillDisappearInScrollView:(__kindof DNVideoPlayerView *)videoPlayer
{
    NSLog(@"videoPlayerWillDisappearInScrollView---播放器将要消失");
    //1.播放器暂停操作
    [videoPlayer playerPause];
    //2.播放器内部清空操作,删除需要在控制器操作
    if ([self.videoPlayerDelegate respondsToSelector:@selector(dnVodPlayerDisappearScrollViewAction:)]) {
        [self.videoPlayerDelegate dnVodPlayerDisappearScrollViewAction:videoPlayer];
    }
}


@end
