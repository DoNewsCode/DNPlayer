//
//  NSString+ZZDate.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZZDate)

/** RFC3339时间格式创建NSDate */
- (NSDate *)zz_dateFromRFC3339;
/** 时间戳转date */
- (NSDate *)zz_dateFromTimeInterval;
/** 将过去时间戳转换成具体的时间描述 */
- (NSString *)zz_fromTimeStampToDetailDesc;
/** 将未来时间戳转换成具体的时间描述 */
- (NSString *)zz_fromTimeStampToFutureDetailDesc;


//-------------
// Class Method
//-------------
/** 获取当前时间的时间戳 */
+ (NSString *)zz_timeStampForNow ;
/** 传入秒数返回 HH:mm:ss 格式字符串 */
+ (NSString *)zz_stringHMSWithSecond:(NSUInteger)second;
/// 传入时间戳字符串 返回 yyyy-MM-dd
+ (NSString *)zz_getDateStringWithTimeInterval:(NSString *)timeInterStr;

@end
