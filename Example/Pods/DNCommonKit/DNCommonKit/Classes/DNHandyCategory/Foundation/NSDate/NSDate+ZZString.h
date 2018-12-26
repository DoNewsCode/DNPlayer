//
//  NSDate+ZZString.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZZString)

/// 将NSData对象按照yyyy_MM_dd_HH_mm_ss字符串显示
- (NSString *)zz_stringWithyyyy_MM_dd_HH_mm_ss;
/// 将NSData对象按照yyyy_MM_dd字符串显示
- (NSString *)zz_stringWithyyyy_MM_dd;
/// 返回yyyy_MM_dd格式的Date
- (NSDate *)zz_dateWithyyyy_MM_dd;

/** 是否为今年 */
- (BOOL)zz_isThisYear;
/** 是否为明天 */
- (BOOL)zz_isTomorrow;
/** 是否为后天 */
- (BOOL)zz_isDayAfterTomorrow;
/** 是否为3-30天后 */
- (BOOL)zz_isThreeToThirtyDay;
/** 是否为今天 */
- (BOOL)zz_isToday;
/** 是否为昨天 */
- (BOOL)zz_isYesterday;
/** 是否为前天 */
- (BOOL)zz_isBeforeYesterday;
/** 是否为3-9天内 */
- (BOOL)zz_isThreeToNineDay;
/** 距离现在一个小时以内 */
- (BOOL)zz_isInAnHour;
/** 距今日的时间天数 */
- (NSInteger)zz_daysBeforToday;
/** 同一年中距本月的月份差 */
- (NSInteger)zz_mouthBeforMouth;
/** 获得与当前时间的差距*/
- (NSDateComponents *)zz_deltaWithNow;

@end
