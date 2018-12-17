//
//  DNVideoPlayerView+PlayControl.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/6.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import "DNVideoPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNVideoPlayerView (PlayControl)<UIGestureRecognizerDelegate,DNVideoPlayerControlViewDelegate,NSObject>


- (void)configPlayControlAction;

/// 获取系统音量
- (void)configureVolume;
/// 显示控制层
- (void)animateShow;
/// 隐藏控制层
- (void)hideControlView;
/// 强制设置为竖屏
- (void)scaleSmallTo_Orientation_Portrait;
@end

NS_ASSUME_NONNULL_END
