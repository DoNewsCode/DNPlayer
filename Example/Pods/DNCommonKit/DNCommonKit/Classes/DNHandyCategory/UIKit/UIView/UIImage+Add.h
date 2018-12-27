//
//  UIImage+Add.h
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//  UIImage分类（获取图片生成单一颜色图片）

#import <UIKit/UIKit.h>

@interface UIImage (Add)


/** 从bundle中获取图片 */
+ (instancetype)ca_imageName:(NSString *)imageName inBundle:(NSString *)bundle;
/** 当图片被压缩拉伸时裁切图片 */
+ (instancetype)ca_imageClip:(UIImage *)image;
/** 单一的颜色生成图片 */
+ (instancetype)ca_imageWithColor:(UIColor*)color;
/** 返回特定尺寸的UImag/image参数为原图片，size为要设定的图片大小 */
+ (UIImage*)ca_resizeImageToSize:(CGSize)size
                     sizeOfImage:(UIImage*)image;


@end
