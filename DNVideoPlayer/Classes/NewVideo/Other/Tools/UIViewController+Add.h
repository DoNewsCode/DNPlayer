//
//  UIViewController+Add.h
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//  UIViewController分类（）

#import <UIKit/UIKit.h>

@interface UIViewController (Add)

+ (UIViewController *)ca_currentTopViewController;

- (CGFloat)ca_TabbarHeight;
@end
