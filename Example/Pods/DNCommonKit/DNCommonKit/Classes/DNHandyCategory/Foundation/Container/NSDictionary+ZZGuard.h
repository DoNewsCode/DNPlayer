//
//  NSDictionary+ZZGuard.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/23.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZZGuard)

/**
判断字典里对应key的值是否存在
 
 @param key The key.
 */
- (BOOL)zz_containsObjectForKey:(id)key;

@end


@interface NSMutableDictionary (ZZGuard)


/**
 向字典插入元素

 @param anObject 要插入数组的value
 @param aKey 对应的key
 如果anObject为nil 则不执行插入
 */
- (void)zz_addObject:(id)anObject forKey:(id<NSCopying>)aKey;

/**
 删除字典中key对应的value

 @param aKey The key
 如果key对应的vlaue不存在 则不执行删除操作
 */
- (void)zz_removeObjectForKey:(id)aKey;

@end
