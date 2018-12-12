
//
//  UIImage+DNUtils.m
//  A9VG
//
//  Created by 张健康 on 2018/11/30.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import "UIImage+DNUtils.h"

@implementation UIImage (DNUtils)
//压缩图片数据
- (NSData *)resetSizeImageMaxSize:(NSInteger)maxSize{
    //先调整分辨率
    CGSize newSize = CGSizeMake(self.size.width, self.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(self.size.width / tempWidth, self.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(self.size.width / tempHeight, self.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}

//获取压缩的图片
- (UIImage *)getRestImageWithMaxSize:(NSInteger)maxSize{
    NSData *imageData = [self resetSizeImageMaxSize:maxSize];
    
    return [UIImage imageWithData:imageData];
}
@end
