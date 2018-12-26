//
//  NSDictionary+ZZGuard.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/23.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSDictionary+ZZGuard.h"

@implementation NSDictionary (ZZGuard)

- (BOOL)zz_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

@end

@implementation NSMutableDictionary (ZZGuard)

- (void)zz_addObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) { return;}
    [self setObject:anObject forKey:aKey];
}

- (void)zz_removeObjectForKey:(id)aKey {
    if ([self zz_containsObjectForKey:aKey]) {
        [self removeObjectForKey:aKey];
    }
}

@end
