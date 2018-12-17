//
//  DNVideoPlayerView+PlayModelPropertiesObserver.m
//  DNVideoPlayer
//  播放器在ScrollView上的控制(是否滑出可视范围或是否滑入可视范围)
//  Created by Madjensen on 2018/12/17.
//

#import "DNVideoPlayerView+PlayModelPropertiesObserver.h"
#import <Foundation/Foundation.h>

@implementation DNVideoPlayerView (PlayModelPropertiesObserver)
//- (void)observer:(nonnull DNPlayModelPropertiesObserver *)observer userTouchedCollectionView:(BOOL)touched
//{
////    self.touchedScrollView = touched;
//}
//- (void)observer:(nonnull DNPlayModelPropertiesObserver *)observer userTouchedTableView:(BOOL)touched
//{
//    self.touchedScrollView = touched;
//}
- (void)playerWillAppearForObserver:(nonnull DNPlayModelPropertiesObserver *)observer superview:(nonnull UIView *)superview
{
//    [self.displayRecorder layerAppear];
    if (superview && self.containerView.superview != superview ) {
        [self.containerView removeFromSuperview];
        [superview addSubview:self.containerView];
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superview);
        }];
    }

    if ( [self.controlLayerDelegate respondsToSelector:@selector(videoPlayerWillAppearInScrollView:)] ) {
        [self.controlLayerDelegate videoPlayerWillAppearInScrollView:self];
    }

}
- (void)playerWillDisappearForObserver:(nonnull DNPlayModelPropertiesObserver *)observer
{
    if ( [self.controlLayerDelegate respondsToSelector:@selector(videoPlayerWillDisappearInScrollView:)] ) {
        [self.controlLayerDelegate videoPlayerWillDisappearInScrollView:self];
    }
}
@end
