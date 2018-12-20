//
//  DNCustomDismissAnimator.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/19.
//

#import "DNCustomDismissAnimator.h"

@implementation DNCustomDismissAnimator

#pragma mark - UIViewControllerAnimatedTransitioning  Methods
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.dismissStyle) {
        case DNCustomDismissStyleFadeOut:
            [self fadeOutAnimationWithContext:transitionContext];
            break;
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.dismissStyle) {
        case DNCustomDismissStyleFadeOut:
            return 0.15;
    }
}

- (void)fadeOutAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    toVC.view.alpha = 0;

    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];

    UIView *sourceView = [self.sourceTransition transitionSourceView];
    [containerView addSubview:sourceView];

    [fromVC beginAppearanceTransition:NO animated:YES];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.alpha = 0;
                         sourceView.frame = [self.destinationTransition transitionDestinationViewFrame];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                         [UIView animateWithDuration:0.45
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
//                                              sourceView.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              if ([self.destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
                                                  [self.destinationTransition respondsToSelector:@selector(customTransitionAnimator:didCompleteTransition:animatingSourceView:)]) {

                                                  [self.destinationTransition customTransitionAnimator:self didCompleteTransition:![transitionContext transitionWasCancelled] animatingSourceView:sourceView];

                                              }
//                                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//                                              if(![[UIApplication sharedApplication].keyWindow.subviews containsObject:toVC.view]) {
//                                                  [[UIApplication sharedApplication].keyWindow addSubview:toVC.view];
//                                              }
//                                              [alphaView removeFromSuperview];
                                              [sourceView removeFromSuperview];
                                          }];
                     }];
}

@end
