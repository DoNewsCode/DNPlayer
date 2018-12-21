//
//  UIScrollView+DNListVideoPlayerAutoPlay.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import <UIKit/UIKit.h>
#import "DNPlayerAutoPlayManagerConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// List view autoplay.
/// 列表自动播放功能
@interface UIScrollView (DNListVideoPlayerAutoPlay)

@property (nonatomic, readonly) BOOL dn_enabledAutoplay;

/// enable autoplay
/// 开启
- (void)dn_enableAutoplayWithConfig:(DNPlayerAutoPlayManagerConfig *)autoplayConfig;

/// 关闭
- (void)dn_disenableAutoplay;

@end


@interface UIScrollView (DNPlayerCurrentPlayingIndexPath)
@property (nonatomic, strong, nullable, readonly) NSIndexPath *dn_currentPlayingIndexPath;

- (void)setDn_currentPlayingIndexPath:(nullable NSIndexPath *)dn_currentPlayingIndexPath;

- (void)dn_needPlayNextAsset;
@end


NS_ASSUME_NONNULL_END
