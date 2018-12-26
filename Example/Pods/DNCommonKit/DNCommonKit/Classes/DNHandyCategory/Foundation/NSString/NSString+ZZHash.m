//
//  NSString+ZZHash.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSString+ZZHash.h"
#import "NSData+ZZHash.h"

@implementation NSString (ZZHash)

- (NSData *)zz_MD5
{
    NSData *inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [inputData zz_MD5];
}

- (NSString *)zz_MD5String
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [inputData zz_MD5String];
}

@end
