//
//  NSArray+ZZGuard.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/23.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSArray+ZZGuard.h"

@implementation NSArray (ZZGuard)

- (id)zz_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

@end


@implementation NSMutableArray (ZZGuard)

- (void)zz_addObject:(id)anObject {
    if (!anObject) { return;}
    [self addObject:anObject];
}

- (void)zz_addObjects:(NSArray *)objects {
    if (!objects) { return;}
    [self addObjectsFromArray:objects];
}

- (void)zz_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)zz_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

- (id)zz_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self zz_removeFirstObject];
    }
    return obj;
}

- (id)zz_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self zz_removeLastObject];
    }
    return obj;
}

- (void)zz_prependObject:(id)anObject {
    if (anObject) {
        [self insertObject:anObject atIndex:0];
    }
}

- (void)zz_prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)zz_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)zz_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self zz_insertObject:obj atIndex:i++];
    }
}

- (void)zz_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)zz_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

/**
 移除数组元素
 */
- (void)zz_removeObject:(NSObject *)object{
    
    if (object) {
        
        [self removeObject:object];
        
    }
    
}


/**
 移除数组索引元素
 */
- (void)zz_removeObjectAtIndex:(NSUInteger)index{
    
    if (self.count>index) {
        
        [self removeObjectAtIndex:index];
        
    }
    
}




@end
