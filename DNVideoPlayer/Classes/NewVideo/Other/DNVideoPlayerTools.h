//
//  DNVideoPlayerTools.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/9/13.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *功能：错误提示内容，显示在界面中间的错误内容；用于用户自定义错误
 */
static NSString *  ALIYUNVODVIEW_PLAYFINISH ;//= @"Watch again, please click replay";
static NSString *  ALIYUNVODVIEW_NETWORKTIMEOUT;// = @"The current network is not good. Please click replay later";
static NSString *  ALIYUNVODVIEW_NETWORKUNREACHABLE ;//= @"No network connection, check the network, click replay";
static NSString *  ALIYUNVODVIEW_LOADINGDATAERROR ;//= @"Video loading error, please click replay";
static NSString *  ALIYUNVODVIEW_USEMOBILENETWORK ;//= @"For mobile networks, click play";


@interface DNVideoPlayerTools : NSObject

//根据s-》hh:mm:ss
+ (NSString *)timeformatFromSeconds:(NSInteger)seconds;
/// 时间转换 mm:ss
+ (NSString *)timeFormate:(NSTimeInterval)time;

////获取所有已知清晰度泪飙
//+ (NSArray<NSString *> *)allQualities;

//播放完成描述
+ (void)setPlayFinishTips:(NSString *)des;

+ (NSString *)playFinishTips;

//网络超时
+ (void)setNetworkTimeoutTips:(NSString *)des;

+ (NSString *)networkTimeoutTips;

//无网络状态
+ (void)setNetworkUnreachableTips:(NSString *)des;

+ (NSString *)networkUnreachableTips;

//加载数据错误
+ (void)setLoadingDataErrorTips:(NSString *)des;

+ (NSString*)loadingDataErrorTips;

//网络切换
+ (void)setSwitchToMobileNetworkTips:(NSString *)des;

+ (NSString *)switchToMobileNetworkTips;


@end
