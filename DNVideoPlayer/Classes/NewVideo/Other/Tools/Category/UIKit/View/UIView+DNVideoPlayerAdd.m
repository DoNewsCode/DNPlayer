//
//  UIView+DNVideoPlayerAdd.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/17.
//

#import "UIView+DNVideoPlayerAdd.h"

@implementation UIView (DNVideoPlayerAdd)

- (void)dn_fadeIn {
    [self dn_fadeInAndCompletion:nil];
}

- (void)dn_fadeOut {
    [self dn_fadeOutAndCompletion:nil];
}

- (void)dn_fadeInAndCompletion:(void(^)(UIView *view))block {
    self.alpha = 0.001;
    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if ( block ) block(self);
    }];
}

- (void)dn_fadeOutAndCompletion:(void(^)(UIView *view))block {
    self.alpha = 1;
    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 0.001;
    } completion:^(BOOL finished) {
        if ( block ) block(self);
    }];
}
@end
