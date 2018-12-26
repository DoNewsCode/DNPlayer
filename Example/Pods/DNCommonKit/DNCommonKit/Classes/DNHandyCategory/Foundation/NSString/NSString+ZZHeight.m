//
//  NSString+ZZHeight.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSString+ZZHeight.h"

#define PLACEFODERSTRING (NSString *)@"占位"

@implementation NSString (ZZHeight)

- (CGFloat)zz_heightWithFont:(UIFont *)font width:(CGFloat)width{
    return    [self zz_heightWithFont:font width:width maxHeight:CGFLOAT_MAX];
}
    
- (CGFloat)zz_heightWithFont:(UIFont *)font width:(CGFloat)width maxHeight:(CGFloat)maxHeight {
    
    CGSize constrainSize = CGSizeMake(width, maxHeight);
    CGRect rect = [self boundingRectWithSize:constrainSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.height;

}

- (CGFloat)zz_widthWith:(UIFont *)font height:(CGFloat)height {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat width = [self sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT,height) lineBreakMode:NSLineBreakByCharWrapping].width;
#pragma clang diagnostic pop
    return width;
}
    
- (CGFloat)zz_widthWithFont:(UIFont *)font {
    return [self zz_widthWith:font height:20];
}

- (CGSize)stringSizeWithFont:(UIFont *)font size:(CGSize)size
{
    NSDictionary *dic = @{NSFontAttributeName:font};
    return  [self boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:dic
                               context:nil].size;
}
    
- (BOOL)zz_isSingleLineForLabel:(UILabel *)label {
    if ([self stringSizeWithFont:label.font size:CGSizeMake(label.frame.size.width, MAXFLOAT)].height > [PLACEFODERSTRING stringSizeWithFont:label.font size:CGSizeMake(label.frame.size.width, MAXFLOAT)].height) {
        return NO;
    }
    return YES;
}
    


@end
