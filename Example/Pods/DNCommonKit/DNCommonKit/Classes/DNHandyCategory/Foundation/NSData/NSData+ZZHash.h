//
//  NSData+ZZHash.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZZHash)

/// 将NSData进行MD5加密返回NSData
- (NSData *)zz_MD5;
/// 将NSData进行MD5加密返回NSString
- (NSString *)zz_MD5String;

@end
