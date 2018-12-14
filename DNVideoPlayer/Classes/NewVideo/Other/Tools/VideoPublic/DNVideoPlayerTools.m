//
//  DNVideoPlayerTools.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/9/13.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import "DNVideoPlayerTools.h"


@implementation DNVideoPlayerTools

+ (NSString *)timeFormate:(NSTimeInterval)time
{

    int sec = round(time);

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [formatter setTimeZone:GTMzone];

    NSString *timeStr = nil;
    if (sec < 60)
    {
        if (sec < 10)
        {
            timeStr = [NSString stringWithFormat:@"0%d",sec];
        }
        else
        {
            timeStr = [NSString stringWithFormat:@"%d",sec];
        }
        timeStr = [NSString stringWithFormat:@"00:%@",timeStr];
    }
    else if (sec < 3600)
    {
        [formatter setDateFormat:@"mm:ss"];
        timeStr = [formatter stringFromDate:date];
        timeStr = [NSString stringWithFormat:@"%@",timeStr];
    }
    else
    {
        [formatter setDateFormat:@"mm:ss"];
        timeStr = [formatter stringFromDate:date];
    }
    return timeStr;
}

+ (NSString *)timeformatFromSeconds:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", (long) seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long) (seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", (long) seconds % 60];
    //format of time
    NSString *format_time = nil;
    if (seconds / 3600 <= 0) {
        format_time = [NSString stringWithFormat:@"00:%@:%@", str_minute, str_second];
    } else {
        format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    }
    return format_time;
}


//"fd_definition" = "流畅";
//"ld_definition" = "标清";
//"sd_definition" = "高清";
//"hd_definition" = "超清";
//"2k_definition" = "2K";
//"4k_definition" = "4K";
//"od_definition" = "OD";
//获取所有已知清晰度泪飙
//+ (NSArray<NSString *> *)allQualities {
//    NSBundle *resourceBundle = [[self class] languageBundle];
//    return @[NSLocalizedStringFromTableInBundle(@"VOD_FD", nil, resourceBundle, nil),
//             NSLocalizedStringFromTableInBundle(@"VOD_LD", nil, resourceBundle, nil),
//             NSLocalizedStringFromTableInBundle(@"VOD_SD", nil, resourceBundle, nil),
//             NSLocalizedStringFromTableInBundle(@"VOD_HD", nil, resourceBundle, nil),
//             NSLocalizedStringFromTableInBundle(@"VOD_2K", nil, resourceBundle, nil),
//             NSLocalizedStringFromTableInBundle(@"VOD_4K", nil, resourceBundle, nil),
//             NSLocalizedStringFromTableInBundle(@"VOD_OD", nil, resourceBundle, nil),
//             ];
//}

+ (void)setPlayFinishTips:(NSString *)des{
    ALIYUNVODVIEW_PLAYFINISH = des;
}

+ (NSString *)playFinishTips{
    return ALIYUNVODVIEW_PLAYFINISH;
}

+ (void)setNetworkTimeoutTips:(NSString *)des{
    ALIYUNVODVIEW_NETWORKTIMEOUT = des;
}

+ (NSString *)networkTimeoutTips{
    return ALIYUNVODVIEW_NETWORKTIMEOUT;
}

+ (void)setNetworkUnreachableTips:(NSString *)des{
    ALIYUNVODVIEW_NETWORKUNREACHABLE = des;
}

+ (NSString *)networkUnreachableTips{
    return ALIYUNVODVIEW_NETWORKUNREACHABLE;
}

+ (void)setLoadingDataErrorTips:(NSString *)des{
    ALIYUNVODVIEW_LOADINGDATAERROR = des;
}

+ (NSString*)loadingDataErrorTips{
    return ALIYUNVODVIEW_LOADINGDATAERROR;
}

+ (void)setSwitchToMobileNetworkTips:(NSString *)des{
    ALIYUNVODVIEW_USEMOBILENETWORK = des;
}
+ (NSString *)switchToMobileNetworkTips{
    return ALIYUNVODVIEW_USEMOBILENETWORK;
}

@end
