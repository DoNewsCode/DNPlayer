//
//  UIColor+Hex.h
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//  UIColor分类（哈希值转换RGB）

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor *)ca_colorWithHex:(long)hexColor;

// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)ca_colorWithHex:(long)hexColor alpha:(float)opacity;

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *)ca_colorWithHexString: (NSString *)color;


@end
