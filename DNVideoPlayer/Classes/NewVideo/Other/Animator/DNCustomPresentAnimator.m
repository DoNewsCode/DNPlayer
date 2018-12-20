//
//  DNCustomPresentAnimator.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/19.
//

#import "DNCustomPresentAnimator.h"
#import "DNPlayerTypeDef.h"
@implementation DNCustomPresentAnimator

#pragma mark - UIViewControllerAnimatedTransitioning  Methods
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.presentStyle) {
        case DNCustomPresentStyleFadeIn:
            [self fadeInAnimationWithContext:transitionContext];
            break;
    }
}


- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.presentStyle) {
        case DNCustomPresentStyleFadeIn:
            return 0.45;
    }
}

#pragma mark - Private Methods
- (void)fadeInAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.alpha = 0;

    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];

    UIView *sourceView = [self.sourceTransition transitionSourceView];
    [containerView addSubview:sourceView];

    [fromVC beginAppearanceTransition:NO animated:YES];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         toVC.view.alpha = 1;
                         sourceView.frame = [self.destinationTransition transitionDestinationViewFrame];
                         sourceView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                         [UIView animateWithDuration:0.45
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              sourceView.transform = CGAffineTransformIdentity;
                                          }
                                          completion:^(BOOL finished) {

//                                              sourceView.alpha = 0;
                                              if ([self.destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
                                                  [self.destinationTransition respondsToSelector:@selector(customTransitionAnimator:didCompleteTransition:animatingSourceView:)]) {
                                                  [self.destinationTransition customTransitionAnimator:self didCompleteTransition:![transitionContext transitionWasCancelled] animatingSourceView:sourceView];
                                              }

//                                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

                                              //[sourceView removeFromSuperview];
                                              [fromVC endAppearanceTransition];
                                          }];
                     }];
}

@end
