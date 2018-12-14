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
/// v1.3.0 新增
@interface UIScrollView (DNListVideoPlayerAutoPlay)

@property (nonatomic, readonly) BOOL sj_enabledAutoplay;

/// enable autoplay
/// 开启
- (void)sj_enableAutoplayWithConfig:(DNPlayerAutoPlayManagerConfig *)autoplayConfig;

/// 关闭
- (void)sj_disenableAutoplay;

@end


/// 开发者无需关心, 此分类由播放器自动维护
@interface UIScrollView (SJPlayerCurrentPlayingIndexPath)
@property (nonatomic, strong, nullable, readonly) NSIndexPath *sj_currentPlayingIndexPath;
- (void)setSj_currentPlayingIndexPath:(nullable NSIndexPath *)sj_currentPlayingIndexPath;
- (void)sj_needPlayNextAsset;
@end


NS_ASSUME_NONNULL_END
