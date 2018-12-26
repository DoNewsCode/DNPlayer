//
//  NSString+ZZHash.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZZHash)

- (NSData *)zz_MD5;
- (NSString *)zz_MD5String;

@end
