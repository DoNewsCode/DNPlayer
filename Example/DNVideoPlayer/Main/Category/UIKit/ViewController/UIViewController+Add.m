//
//  UIViewController+Add.m
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import "UIViewController+Add.h"

@implementation UIViewController (Add)
- (CGFloat)ca_TabbarHeight
{
    //Tabbar高度
    return self.tabBarController.tabBar.bounds.size.height;
}

+ (UIViewController *)ca_currentTopViewController
{

    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (YES){
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([topController isKindOfClass:[UITabBarController class]]) {
            topController = ((UITabBarController*)topController).selectedViewController;
        }
        if ([topController isKindOfClass:[UINavigationController class]]) {
            topController = ((UINavigationController*)topController).visibleViewController;
        }
        if (topController.presentedViewController) {
            topController = topController.presentedViewController;
        } else {
            break;
        }
    }
    return topController;
}


@end
