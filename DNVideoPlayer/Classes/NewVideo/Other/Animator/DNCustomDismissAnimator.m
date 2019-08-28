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
            return 0.45;
    }
}


- (void)fadeOutAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    UIView *sourceView = [self.sourceTransition transitionSourceView];
    [containerView addSubview:sourceView];
    
    [fromVC beginAppearanceTransition:NO animated:YES];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    CGFloat scaleRatio;
    CGRect finalFrame;
    finalFrame = [self.destinationTransition transitionDestinationViewFrame];
    
    sourceView.frame = finalFrame;
    scaleRatio = fromVC.view.frame.size.width/sourceView.frame.size.width;
    
    
    fromVC.view.alpha = 1.0f;
    sourceView.center = fromVC.view.center;
    sourceView.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.alpha = 0;
                         sourceView.transform = CGAffineTransformIdentity;
                         sourceView.frame = [self.destinationTransition transitionDestinationViewFrame];
                     }
                     completion:^(BOOL finished) {
                         
                         
                         [transitionContext finishInteractiveTransition];
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
                                              
                                              
                                          }];
                     }];
}


//- (void)fadeOutAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
////    toVC.view.alpha = 0;
//
//    UIView *containerView = [transitionContext containerView];
//
//    [containerView addSubview:fromVC.view];
//    [containerView addSubview:toVC.view];
//
//    UIView *sourceView = [self.sourceTransition transitionSourceView];
//    [containerView addSubview:sourceView];
//
//    [fromVC beginAppearanceTransition:NO animated:YES];
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         fromVC.view.alpha = 0;
//                         sourceView.frame = [self.destinationTransition transitionDestinationViewFrame];
//                     }
//                     completion:^(BOOL finished) {
//                         [transitionContext completeTransition:YES];
//                         [UIView animateWithDuration:0.45
//                                               delay:0
//                                             options:UIViewAnimationOptionCurveEaseOut
//                                          animations:^{
////                                              sourceView.alpha = 0;
//                                          }
//                                          completion:^(BOOL finished) {
//                                              if ([self.destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
//                                                  [self.destinationTransition respondsToSelector:@selector(customTransitionAnimator:didCompleteTransition:animatingSourceView:)]) {
//
//                                                  [self.destinationTransition customTransitionAnimator:self didCompleteTransition:![transitionContext transitionWasCancelled] animatingSourceView:sourceView];
//                                              }
//                                          }];
//                     }];
//}

@end
