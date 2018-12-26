//
//  UIImageView+TGCache.h
//  TGBus
//
//  Created by donews on 2018/7/27.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include( <SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

@interface UIImageView (TGCache)

- (void)dn_setImageWithURL:(NSURL *)url;
- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options;
- (void)dn_setImageWithURL:(NSURL *)url completed:(void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completed;
- (void)dn_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage*)placeholderImage completed:(void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completed;
- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options completed:(void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completed;

@end
