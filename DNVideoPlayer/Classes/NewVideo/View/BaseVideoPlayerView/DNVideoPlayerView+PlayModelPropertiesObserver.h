//
//  DNVideoPlayerView+PlayModelPropertiesObserver.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/17.
//  播放器在ScrollView上的控制(是否滑出可视范围或是否滑入可视范围)

#import "DNVideoPlayerView.h"


#import "DNPlayModelPropertiesObserver.h"
NS_ASSUME_NONNULL_BEGIN

@interface DNVideoPlayerView (PlayModelPropertiesObserver)<DNPlayModelPropertiesObserverDelegate>

@end

NS_ASSUME_NONNULL_END
