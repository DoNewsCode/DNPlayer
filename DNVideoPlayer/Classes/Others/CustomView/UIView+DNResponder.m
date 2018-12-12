//
//  UIView+DNResponder.m
//  A9VG
//
//  Created by 张健康 on 2018/9/14.
//  Copyright © 2018年 DoNews. All rights reserved.
//

#import "UIView+DNResponder.h"

@implementation UIView (DNResponder)
- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
    
}
@end
