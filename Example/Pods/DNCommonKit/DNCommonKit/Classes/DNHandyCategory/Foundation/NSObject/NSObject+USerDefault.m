//
//  NSObject+USerDefault.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/23.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSObject+USerDefault.h"

@implementation NSObject (USerDefault)

+ (void)zz_saveUserDefaultForKey:(NSString *)key value:(id)value {
    if (!value) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)zz_saveUserDefaultAndArchiveForKey:(NSString *)key value:(id)value {
    if (!value) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    if (!data) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)zz_getUserDefaultForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (id)zz_getUserDefaultAndUnarchiverForKey:(NSString *)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data) {
        return nil;
    }
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
}

+ (void)zz_removeUserDefaultForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
