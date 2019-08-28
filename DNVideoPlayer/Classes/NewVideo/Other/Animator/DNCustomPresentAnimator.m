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
    
    fromVC.navigationController.navigationBar.hidden = NO;
    
    //    [self.snapShotView removeFromSuperview];
    //    self.snapShotView = [fromVC.navigationController.view snapshotViewAfterScreenUpdates:YES];
    //    self.snapShotView.tag = 888999;
    //    [[toVC.navigationController.view superview] insertSubview:self.snapShotView belowSubview:toVC.navigationController.view];
    
    //    [containerView addSubview:self.snapShotView];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    UIView *sourceView = [self.sourceTransition transitionSourceView];
    [containerView addSubview:sourceView];
    
    
    CGRect initialFrame = [self.sourceTransition transitionDestinationViewFrame];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    
    toVC.view.center = CGPointMake(initialFrame.origin.x + initialFrame.size.width/2, initialFrame.origin.y + initialFrame.size.height/2);
    toVC.view.transform = CGAffineTransformMakeScale(initialFrame.size.width/finalFrame.size.width, initialFrame.size.height/finalFrame.size.height);
    
    
    [fromVC beginAppearanceTransition:NO animated:YES];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         toVC.view.alpha = 1;
                         toVC.view.center = CGPointMake(finalFrame.origin.x + finalFrame.size.width/2, finalFrame.origin.y + finalFrame.size.height/2);
                         toVC.view.transform = CGAffineTransformMakeScale(1, 1);
                         
                         if ([self.destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
                             [self.destinationTransition respondsToSelector:@selector(customTransitionAnimator:didCompleteTransition:animatingSourceView:)]) {
                             [self.destinationTransition customTransitionAnimator:self didCompleteTransition:![transitionContext transitionWasCancelled] animatingSourceView:sourceView];
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         [transitionContext completeTransition:YES];
                         [fromVC endAppearanceTransition];
                     }];
}



//
//#pragma mark - Private Methods
//- (void)fadeInAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
//
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    toVC.view.alpha = 0;
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
//
//    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         toVC.view.alpha = 1;
//                         sourceView.frame = [self.destinationTransition transitionDestinationViewFrame];
//                         sourceView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                     }
//                     completion:^(BOOL finished) {
//                         [transitionContext completeTransition:YES];
//                         [UIView animateWithDuration:0.45
//                                               delay:0
//                                             options:UIViewAnimationOptionCurveEaseOut
//                                          animations:^{
//                                              sourceView.transform = CGAffineTransformIdentity;
//                                          }
//                                          completion:^(BOOL finished) {
//
////                                              sourceView.alpha = 0;
//                                              if ([self.destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
//                                                  [self.destinationTransition respondsToSelector:@selector(customTransitionAnimator:didCompleteTransition:animatingSourceView:)]) {
//                                                  [self.destinationTransition customTransitionAnimator:self didCompleteTransition:![transitionContext transitionWasCancelled] animatingSourceView:sourceView];
//                                              }
//
////                                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//
//                                              //[sourceView removeFromSuperview];
//                                              [fromVC endAppearanceTransition];
//                                          }];
//                     }];
//}

@end
