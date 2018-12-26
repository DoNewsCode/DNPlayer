//
//  UIImage+PlaceImageAdd.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PlaceImageAdd)

+ (UIImage *)imageWithImageName:(NSString *)imageName inBundle:(nullable NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
