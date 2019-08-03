//
//  DNPlayerTypeDef.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#ifndef DNPlayerTypeDef_h
#define DNPlayerTypeDef_h

typedef void(^PlayerPublicBlock)(id sender);

// 适配 iOS 11 重写 adjustsScrollViewInsets
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


//========= start ========
#ifndef weakify

#if DEBUG

#if __has_feature(objc_arc)

#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;

#else

#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;

#endif

#else

#if __has_feature(objc_arc)

#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;

#else

#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;

#endif

#endif

#endif


#ifndef strongify

#if DEBUG

#if __has_feature(objc_arc)

#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;

#else

#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;

#endif

#else

#if __has_feature(objc_arc)

#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;

#else

#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;

#endif

#endif
#endif
//========= end ========


//随机颜色
#define MRandomColor  [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]

//判断机型
#define iphoneSE    [UIScreen mainScreen].bounds.size.height == 568
#define iPhoneX     [UIScreen mainScreen].bounds.size.height >= 812

/// 判断后的系统状态栏高度 (默认用这个就可以)
#define STATUS_BAR_HEIGHT (isHaveStatuBarH ? STATUS_BAR_H_System : STATUS_BAR_H_Decide)
/// 适配后选择相应机型的状态栏高度
#define STATUS_BAR_H_Decide (iPhoneX ? 44.00 : 20.00)
/// 顶部导航栏高度
#define NAV_BAR_Y (STATUS_BAR_H_Decide + 44)

/// 自定义导航栏高度
#define CUSTOM_NAV_BAR_HEIGHT 44


/// 系统状态栏高度
#define STATUS_BAR_H_System [UIApplication sharedApplication].statusBarFrame.size.height
/// 是否有系统状态栏
#define isHaveStatuBarH STATUS_BAR_H_System != 0
///状态栏高度

/// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
/// 屏幕宽度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

#import "DNVideoPlayerTools.h"
#import "DNPlayerConst.h"


#import "UIView+DNVideoPlayerAdd.h"
#import "DNPlayModel.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>
#import <Masonry/Masonry.h>
#import "UIImage+PlaceImageAdd.h"
#import <DNCommonKit/UIColor+CTHex.h>
#import <DNCommonKit/NSObject+CTUIViewController.h>
#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>

#endif /* DNPlayerTypeDef_h */

