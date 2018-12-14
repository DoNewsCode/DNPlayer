//
//  DNPlayerTypeDef.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#ifndef DNPlayerTypeDef_h
#define DNPlayerTypeDef_h

/// 播放器控制层类型 点播 直播
typedef NS_ENUM(int, PlayerControlViewType) {
    PlayerControlViewType_Vod = 0,  /// 点播
    PlayerControlViewType_Live      /// 直播
};


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

#define iPhoneX                         [UIScreen mainScreen].bounds.size.height >= 812
#define STATUSBAR_H [UIApplication sharedApplication].statusBarFrame.size.height
#define TGStatuBarHeight  (iPhoneX ? 44.00 : 20.00)
#define TGNavHeight       (TGStatuBarHeight + 44)
///状态栏高度
//#define TGStatuBarH [UIApplication sharedApplication].statusBarFrame.size.height

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#import "DNVideoPlayerTools.h"
#import "UIView+JAExtForPageScroll.h"
#import "DNPlayerConst.h"
#import "UIViewController+Add.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>
#import <Masonry/Masonry.h>
#import "DNPlayModel.h"

#endif /* DNPlayerTypeDef_h */

