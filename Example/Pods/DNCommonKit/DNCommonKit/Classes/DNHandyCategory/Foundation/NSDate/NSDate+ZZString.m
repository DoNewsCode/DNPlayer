//
//  NSDate+ZZString.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSDate+ZZString.h"

@implementation NSDate (ZZString)

- (NSString *)zz_stringWithyyyy_MM_dd_HH_mm_ss {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:self];
}

- (NSString *)zz_stringWithyyyy_MM_dd {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)zz_dateWithyyyy_MM_dd {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [self zz_stringWithyyyy_MM_dd];
    return [dateFormatter dateFromString:string];
}


- (BOOL)zz_isThisYear {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
}

- (BOOL)zz_isToday{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];// 获得当前时间的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];// 获得self的年月日
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

- (BOOL)zz_isYesterday {
    return  ([self zz_daysBeforToday] == 1);
}

- (BOOL)zz_isBeforeYesterday {
    return  ([self zz_daysBeforToday] == 2);
}

- (BOOL)zz_isThreeToNineDay {
    
    NSUInteger day = [self zz_daysBeforToday];
    return (day <= 9 && day >= 3);
}

- (BOOL)zz_isInAnHour {
    
    NSTimeInterval lasttimeInterval = [self timeIntervalSince1970];
    NSTimeInterval NowtimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval DistanceTime = NowtimeInterval -lasttimeInterval;
    
    if (DistanceTime < 60.0 * 60.0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)zz_daysBeforToday {
   
    NSDate *nowDate = [[NSDate date] zz_dateWithyyyy_MM_dd];  // 例如 2014-05-01
    NSDate *selfDate = [self zz_dateWithyyyy_MM_dd]; // 例如 2014-04-30    
    NSCalendar *calendar = [NSCalendar currentCalendar];// 获得差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day;
}


- (NSInteger)zz_mouthBeforMouth {
    
    NSDate *nowDate = [[NSDate date] zz_dateWithyyyy_MM_dd];  // 例如 2014-05-01
    NSDate *selfDate = [self zz_dateWithyyyy_MM_dd]; // 例如 2014-04-30
    NSCalendar *calendar = [NSCalendar currentCalendar];// 获得差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitMonth fromDate:selfDate toDate:nowDate options:0];
    return cmps.month;
}

- (BOOL)zz_isTomorrow {
    return ([self zz_daysBeforToday] == -1);
}

- (BOOL)zz_isDayAfterTomorrow {
    return ([self zz_daysBeforToday] == -2);
}

- (BOOL)zz_isThreeToThirtyDay {
    NSUInteger day = [self zz_daysBeforToday];
    return (day <= -3 && day >= -30);
}

- (NSDateComponents *)zz_deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
