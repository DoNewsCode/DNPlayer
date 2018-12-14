//
//  DNIsAppearedHelper.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__kindof UIView *sj_getTarget(UIScrollView *scrollView, NSIndexPath *viewAtIndexPath, NSInteger viewTag);

extern bool sj_isAppeared1(NSInteger viewTag, NSIndexPath *viewAtIndexPath, UIScrollView *scrollView);

extern bool sj_isAppeared2(UIView *_Nullable childView, UIScrollView *_Nullable scrollView);


NS_ASSUME_NONNULL_END
