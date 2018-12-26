//
//  UIImageView+TGCache.m
//  TGBus
//
//  Created by donews on 2018/7/27.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import "UIImageView+TGCache.h"
#import "UIImage+ZZAdd.h"

@implementation UIImageView (TGCache)

- (void)dn_setImageWithURL:(NSURL *)url {
    [self dn_setImageWithURL:url completed:nil];
}

- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    [self dn_setImageWithURL:url placeholderImage:placeholderImage completed:nil];
}

- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options {
    [self dn_setImageWithURL:url placeholderImage:placeholderImage options:options completed:nil];
}

- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options width:(CGFloat)width {
    
    [self dn_setImageWithURL:url placeholderImage:placeholderImage options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL) {
        
        if (options == SDWebImageAvoidAutoSetImage) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *tempImage = [UIImage zz_imageClip:image];//[UIImage zz_imageClip:image]; // 后台线程剪裁图片
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = tempImage;
                    [self setNeedsLayout];
                });
            });
        }
    }];
}

- (void)dn_setImageWithURL:(NSURL *)url completed:(void (^)(UIImage * _Nullable, NSError * _Nullable, NSURL * _Nullable))completed {
    
    [self sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completed) {
            completed(image, error, imageURL);
        }
    }];

}

- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completed:(void (^)(UIImage * _Nullable, NSError * _Nullable, NSURL * _Nullable))completed {
    
    [self dn_setImageWithURL:url placeholderImage:placeholderImage options:(SDWebImageRetryFailed) completed:completed];
}

- (void)dn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options completed:(void (^)(UIImage * _Nullable, NSError * _Nullable, NSURL * _Nullable))completed {
    
    [self sd_setImageWithURL:url placeholderImage:placeholderImage options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (options == SDWebImageAvoidAutoSetImage) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *tempImage = [UIImage zz_imageClip:image]; // 后台线程剪裁图片
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = tempImage;
                    [self setNeedsLayout];
                });
            });
        }

        if (completed) {
            completed(image, error, imageURL);
        }
    }];
}

@end
