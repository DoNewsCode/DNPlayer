//
//  UIImage+PlaceImageAdd.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/20.
//

#import "UIImage+PlaceImageAdd.h"

@implementation UIImage (PlaceImageAdd)

+ (UIImage *)imageWithImageName:(NSString *)imageName inBundle:(nullable NSBundle *)bundle
{
    UIImage *image = [[UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
