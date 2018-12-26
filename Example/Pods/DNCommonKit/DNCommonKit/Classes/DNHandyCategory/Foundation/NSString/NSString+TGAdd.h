//
//  NSString+TGAdd.h
//  TGBus
//
//  Created by donews on 2018/8/10.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TGAdd)

/// 评论数超过999 返回字符串 1000->1k 1001->1万 1100->1.1k 1200->1.2k...
+ (instancetype)tg_commentCountStringWithCount:(NSUInteger)count;

@end
