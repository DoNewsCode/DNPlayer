//
//  UIView+Shadow.h
//  TGBus
//
//  Created by donews on 2018/8/3.
//  Copyright © 2018年 Jamie. All rights reserved.
//  设置控件的阴影 & 渐变等

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TGShadowPathSide) {

    TGShadowPathSideLeft, // 左边
    TGShadowPathSideRight, // 右边
    TGShadowPathSideTop, // 上边
    TGShadowPathSideBottom, // 下边
    TGShadowPathSideNoTop, // 除了上边
    TGShadowPathSideAllSide // 四边
};

typedef NS_ENUM(NSUInteger, TGGradienteDirection) {
    TGGradienteDirectionDefault, // 默认垂直
    TGGradienteDirectionVertical, // 垂直
    TGGradienteDirectionHorizontal, // 水平
};



@interface UIView (Shadow)

/*
 * shadowColor 阴影颜色
 *
 * shadowOpacity 阴影透明度，默认0
 *
 * shadowRadius  阴影半径，默认3
 *
 * shadowPathSide 设置哪一侧的阴影，
 
 * shadowPathWidth 阴影的宽度，
 */
- (void)tg_shadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(TGShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

- (void)tg_shadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffSet:(CGSize)shadowOffSet;

- (void)tg_shadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffSet:(CGSize)shadowOffSet;
/// 返回渐变的layer 传入startColor 和 endColor
+ (CAGradientLayer *)tg_gradientLayerWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor direction:(TGGradienteDirection)direction;
/// 返回渐变的layer 传入颜色数组 和 渐变范围数组
+ (CAGradientLayer *)tg_gradientLayerWithFrame:(CGRect)frame colors:(NSArray *)colors locations:(NSArray *)locations direction:(TGGradienteDirection)direction;

@end
