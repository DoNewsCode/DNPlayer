//
//  NSData+ZZHash.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSData+ZZHash.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSData (ZZHash)

- (NSData *)zz_MD5
{
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (unsigned int)[self length], outputData);
    NSData *result = [NSData dataWithBytes:outputData length:CC_MD5_DIGEST_LENGTH];
    return result;
}

- (NSString *)zz_MD5String
{
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (unsigned int)[self length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}


@end
