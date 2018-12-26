//
//  UIView+DNVideoPlayerAdd.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DNVideoPlayerAdd)

- (void)dn_fadeIn;

- (void)dn_fadeOut;

- (void)dn_fadeInAndCompletion:(void(^)(UIView *view))block;

- (void)dn_fadeOutAndCompletion:(void(^)(UIView *view))block;

@end

NS_ASSUME_NONNULL_END
