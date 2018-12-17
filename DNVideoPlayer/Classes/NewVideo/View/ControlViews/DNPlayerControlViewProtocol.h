//
//  DNPlayerControlViewProtocol.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/17.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DNVideoPlayerView.h"

@class DNVideoPlayerView;
NS_ASSUME_NONNULL_BEGIN

@protocol DNPlayerControlViewProtocol <NSObject>



@end

@protocol DNVideoPlayerControlViewDelegate<NSObject>
@optional

/// 当滚动scrollView时, 播放器即将出现时会回调这个方法
- (void)videoPlayerWillAppearInScrollView:(__kindof DNVideoPlayerView *)videoPlayer;


/// 当滚动scrollView时, 播放器即将消失时会回调这个方法
- (void)videoPlayerWillDisappearInScrollView:(__kindof DNVideoPlayerView *)videoPlayer;

@end


NS_ASSUME_NONNULL_END
