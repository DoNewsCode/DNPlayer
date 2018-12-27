//
//  NSDate+String.m
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import "NSDate+ZZString.h"

@implementation NSDate (String)


- (NSString *)ca_stringWithyyyy_MM_dd_HH_mm_ss {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:self];
}

- (NSString *)ca_stringWithyyyy_MM_dd {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)ca_dateWithyyyy_MM_dd {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [self ca_stringWithyyyy_MM_dd];
    return [dateFormatter dateFromString:string];
}


- (BOOL)ca_isThisYear {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
}

- (BOOL)ca_isToday{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];// 获得当前时间的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];// 获得self的年月日
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

- (BOOL)ca_isYesterday {
    return  ([self ca_daysBeforToday] == 1);
}

- (BOOL)ca_isBeforeYesterday {
    return  ([self ca_daysBeforToday] == 2);
}

- (BOOL)ca_isThreeToNineDay {
    
    NSUInteger day = [self ca_daysBeforToday];
    return (day <= 9 && day >= 3);
}

- (BOOL)ca_isInAnHour {
    
    NSTimeInterval lasttimeInterval = [self timeIntervalSince1970];
    NSTimeInterval NowtimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval DistanceTime = NowtimeInterval -lasttimeInterval;
    
    if (DistanceTime < 60.0 * 60.0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)ca_daysBeforToday {
    
    NSDate *nowDate = [[NSDate date] ca_dateWithyyyy_MM_dd];  // 例如 2014-05-01
    NSDate *selfDate = [self ca_dateWithyyyy_MM_dd]; // 例如 2014-04-30
    NSCalendar *calendar = [NSCalendar currentCalendar];// 获得差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day;
}


- (NSInteger)ca_mouthBeforMouth {
    
    NSDate *nowDate = [[NSDate date] ca_dateWithyyyy_MM_dd];  // 例如 2014-05-01
    NSDate *selfDate = [self ca_dateWithyyyy_MM_dd]; // 例如 2014-04-30
    NSCalendar *calendar = [NSCalendar currentCalendar];// 获得差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitMonth fromDate:selfDate toDate:nowDate options:0];
    return cmps.month;
}

- (BOOL)ca_isTomorrow {
    return ([self ca_daysBeforToday] == -1);
}

- (BOOL)ca_isDayAfterTomorrow {
    return ([self ca_daysBeforToday] == -2);
}

- (BOOL)ca_isThreeToThirtyDay {
    NSUInteger day = [self ca_daysBeforToday];
    return (day <= -3 && day >= -30);
}

- (NSDateComponents *)ca_deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
