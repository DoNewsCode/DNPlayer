//
//  DNNavigationViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/19.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNNavigationViewController.h"
#import <DNVideoPlayer/DNCustomAnimator.h>
#import <DNVideoPlayer/DNCustomPresentAnimator.h>
#import <DNVideoPlayer/DNCustomDismissAnimator.h>

#import "DNViewController.h"

@interface DNNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation DNNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;

    DNViewController *controller = [[DNViewController alloc]init];
    [self pushViewController:controller animated:YES];
    // Do any additional setup after loading the view.
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{

    id <DNCustomTransitionAnimating, DNCustomTransitionDelegate> sourceTransition = (id<DNCustomTransitionAnimating, DNCustomTransitionDelegate>)fromVC;
    id <DNCustomTransitionAnimating, DNCustomTransitionDelegate> destinationTransition = (id<DNCustomTransitionAnimating, DNCustomTransitionDelegate>)toVC;


    if ([sourceTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(DNCustomTransitionAnimating)]) {

        if (operation == UINavigationControllerOperationPush) {

            DNCustomPresentAnimator *customPresentAnimator = [DNCustomPresentAnimator new];
            customPresentAnimator.presentStyle = DNCustomPresentStyleFadeIn;
            customPresentAnimator.sourceTransition = sourceTransition;
            customPresentAnimator.destinationTransition = destinationTransition;
            return customPresentAnimator;

        }else{

            DNCustomDismissAnimator *customDismissAnimator = [DNCustomDismissAnimator new];
            customDismissAnimator.dismissStyle = DNCustomDismissStyleFadeOut;
            customDismissAnimator.sourceTransition = sourceTransition;
            customDismissAnimator.destinationTransition = destinationTransition;
            return customDismissAnimator;
            
        }
    }
    return nil;
}
@end
