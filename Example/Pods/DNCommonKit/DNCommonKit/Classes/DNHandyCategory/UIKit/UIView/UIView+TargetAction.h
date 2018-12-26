//
//  UIView+TargetAction.h
//  TGBus
//
//  Created by donews on 2018/8/8.
//  Copyright © 2018年 Jamie. All rights reserved.
//  给UIView视图添加点击手势

#import <UIKit/UIKit.h>

typedef void(^TouchCallBackBlock)(void);

@interface UIView (TargetAction)

@property (nonatomic, copy) TouchCallBackBlock touchCallBackBlock;

///  Block 形式给UIView视图添加点击手势
- (void)tg_addActionWithblock:(TouchCallBackBlock)block;
///  Target-Action 形式给UIView视图添加点击手势
- (void)tg_addTarget:(id)target action:(SEL)action;

@end
