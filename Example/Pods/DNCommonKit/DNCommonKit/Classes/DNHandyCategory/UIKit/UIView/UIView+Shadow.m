//
//  UIView+Shadow.m
//  TGBus
//
//  Created by donews on 2018/8/3.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

-(void)tg_shadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(TGShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth{
    
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius =  shadowRadius;
    self.layer.shadowOffset = CGSizeZero;
    CGRect shadowRect;
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat originW = self.bounds.size.width;
    CGFloat originH = self.bounds.size.height;
    
    switch (shadowPathSide) {
        case TGShadowPathSideTop:
            shadowRect = CGRectMake(originX, originY - shadowPathWidth/2, originW,  shadowPathWidth);
            break;
        case TGShadowPathSideBottom:
            shadowRect  = CGRectMake(originX, originH -shadowPathWidth/2, originW, shadowPathWidth);
            break;
            
        case TGShadowPathSideLeft:
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;
            
        case TGShadowPathSideRight:
            shadowRect  = CGRectMake(originW - shadowPathWidth/2, originY, shadowPathWidth, originH);
            break;
        case TGShadowPathSideNoTop:
            shadowRect  = CGRectMake(originX -shadowPathWidth/2, originY +1, originW +shadowPathWidth,originH + shadowPathWidth/2 );
            break;
        case TGShadowPathSideAllSide:
            shadowRect  = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW +  shadowPathWidth, originH + shadowPathWidth);
            break;
            
    }
    
    UIBezierPath *path =[UIBezierPath bezierPathWithRect:shadowRect];
    self.layer.shadowPath = path.CGPath;
    
}

- (void)tg_shadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffSet:(CGSize)shadowOffSet {
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius =  shadowRadius;
    self.layer.shadowOffset = shadowOffSet;
}

- (void)tg_shadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowOffSet:(CGSize)shadowOffSet {
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowOffset = shadowOffSet;
}

+ (CAGradientLayer *)tg_gradientLayerWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor direction:(TGGradienteDirection)direction{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;  // 设置显示的frame
    if (startColor && endColor) {
        gradientLayer.colors = @[(id)startColor.CGColor,
                                 (id)endColor.CGColor,
                                 ];  // 设置渐变颜色
        gradientLayer.locations = @[@0.0,@1.0];
        if (direction == TGGradienteDirectionHorizontal) {
            gradientLayer.startPoint = CGPointMake(0, .5);
            gradientLayer.endPoint = CGPointMake(1, .5);
        }
    }
    return gradientLayer;
}

+ (CAGradientLayer *)tg_gradientLayerWithFrame:(CGRect)frame colors:(NSArray *)colors locations:(NSArray *)locations direction:(TGGradienteDirection)direction{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;  // 设置显示的frame
    gradientLayer.colors = colors;// 设置渐变颜色
    gradientLayer.locations = locations;
    if (direction == TGGradienteDirectionHorizontal) {
        gradientLayer.startPoint = CGPointMake(0, .5);
        gradientLayer.endPoint = CGPointMake(1, .5);
    }
    return gradientLayer;
}


@end
