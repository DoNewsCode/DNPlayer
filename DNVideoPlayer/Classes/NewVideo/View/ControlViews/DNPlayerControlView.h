//
//  DNPlayerControlView.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNPlayerTypeDef.h"


@interface DNPlayerControlView : UIView

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL isShowBackBtn;
@property (nonatomic, assign) PlayerControlViewType controlViewType;


@property (nonatomic, copy) PlayerPublicBlock fullScreenBtnClickBlock;
@property (nonatomic, copy) PlayerPublicBlock backBtnClickBlock;
@property (nonatomic, copy) PlayerPublicBlock playAndPauseClickBlock;
@property (nonatomic, copy) PlayerPublicBlock volumeOnOrOffClickBlock;
@property (nonatomic, copy) PlayerPublicBlock adEndViewReplayClickBlock;

/** 滑杆 */
@property (nonatomic, strong) UISlider *videoSlider;
/// 音量按钮选中状态
@property (nonatomic, assign) BOOL isVolumeSelected;
/// 全屏按钮选中状态
@property (nonatomic, assign) BOOL isfullScreenBtnSelected;
/// 是否展示播放按钮(播放展示暂停按钮,暂停展示播放按钮)
@property (nonatomic, assign, getter=isShowPlayBtn) BOOL showPlayBtn;

/// 是否展示播放结束视图(广告播放结束视图)
@property (nonatomic, assign) BOOL isShowAdPlayToEndView;


/// 总时间
@property (nonatomic, copy) NSString *totalTime;

/// 当前时间
@property (nonatomic, copy) NSString *currentTime;
/// 滑动进度条value改变
@property (nonatomic, assign) CGFloat slidChangeValue;

/// 进度条value
@property (nonatomic, assign) CGFloat proSliderValue;
/// 缓冲进度条value
@property (nonatomic, assign) CGFloat loadingValue;

@property (nonatomic, strong) UIProgressView *bottomProgress;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *bottomloadingProgress;

/** 重置ControlView */
- (void)resetControlView;
/** 显示top、bottom、lockBtn*/
- (void)showControlView;
/** 隐藏top、bottom、lockBtn*/
- (void)hideControlView;

/// 显示菊花缓冲视图
- (void)startActivityView;
- (void)stopAtivityView;
@end
