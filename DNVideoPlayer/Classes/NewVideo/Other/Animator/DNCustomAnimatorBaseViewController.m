//
//  DNCustomAnimatorBaseViewController.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/19.
//

#import "DNCustomAnimatorBaseViewController.h"
#import "DNPlayerTypeDef.h"
#import "DNCustomPresentAnimator.h"
#import "DNCustomDismissAnimator.h"

@interface DNCustomAnimatorBaseViewController ()

@end

@implementation DNCustomAnimatorBaseViewController
- (instancetype)init {
    if (self = [super init]) {
        self.transitioningDelegate = self;                          // 设置自己为转场代理
        self.modalPresentationStyle = UIModalPresentationCustom;    // 自定义转场模式
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}


#pragma mark - UIViewControllerTransitioningDelegate Methods
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{

    id <DNCustomTransitionAnimating,DNCustomTransitionDelegate> sourceTransition = (id<DNCustomTransitionAnimating,DNCustomTransitionDelegate>)source;

    id <DNCustomTransitionAnimating,DNCustomTransitionDelegate> destinationTransition = (id<DNCustomTransitionAnimating,DNCustomTransitionDelegate>)presented;

    if ([sourceTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)]) {

        DNCustomPresentAnimator *customPresentAnimator = [DNCustomPresentAnimator new];
        customPresentAnimator.presentStyle = self.presentStyle;
        customPresentAnimator.sourceTransition = sourceTransition;
        customPresentAnimator.destinationTransition = destinationTransition;
        return customPresentAnimator;
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{

    id <DNCustomTransitionAnimating,DNCustomTransitionDelegate> sourceTransition = (id<DNCustomTransitionAnimating,DNCustomTransitionDelegate>)dismissed;

    id <DNCustomTransitionAnimating,DNCustomTransitionDelegate> destinationTransition = (id<DNCustomTransitionAnimating,DNCustomTransitionDelegate>)self;

    if ([sourceTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)]) {

        DNCustomDismissAnimator *customDismissAnimator = [DNCustomDismissAnimator new];
        customDismissAnimator.dismissStyle = self.dismissStyle;
        customDismissAnimator.sourceTransition = sourceTransition;
        customDismissAnimator.destinationTransition = destinationTransition;
        return customDismissAnimator;
    }
    
    return nil;
}

@end
