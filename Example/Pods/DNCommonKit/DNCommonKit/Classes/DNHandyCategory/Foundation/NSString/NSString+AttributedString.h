//
//  NSString+AttributedString.h
//  TGBus
//
//  Created by donews on 2018/8/9.
//  Copyright © 2018年 Jamie. All rights reserved.
//  富文本字符串

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (AttributedString)

/// 只改变字体
- (NSMutableAttributedString *)tg_attributedStringWithFont:(UIFont *)font range:(NSRange)range;

@end
