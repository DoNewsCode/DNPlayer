//
//  DNCustomAnimator.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DNCustomAnimator;

NS_ASSUME_NONNULL_BEGIN

/** present style */
typedef NS_ENUM(NSInteger, DNCustomPresentStyle) {
    DNCustomPresentStyleFadeIn          // 渐入
};

/** dismiss style */
typedef NS_ENUM(NSInteger, DNCustomDismissStyle) {
    DNCustomDismissStyleFadeOut    // 渐出
};


@protocol DNCustomTransitionAnimating <NSObject>

@required
- (nonnull UIView *)transitionSourceView;

- (CGRect)transitionDestinationViewFrame;

@end

@protocol DNCustomTransitionDelegate <NSObject>
@optional

- (void)customTransitionAnimator:(nonnull DNCustomAnimator *)animator
         didCompleteTransition:(BOOL)didComplete
      animatingSourceView:(nonnull UIView *)sourceView;

@end

@interface DNCustomAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) DNCustomPresentStyle presentStyle;
@property (assign, nonatomic) DNCustomDismissStyle dismissStyle;



@property (nonatomic, weak, nullable) id <DNCustomTransitionAnimating,DNCustomTransitionDelegate> sourceTransition;
@property (nonatomic, weak, nullable) id <DNCustomTransitionAnimating,DNCustomTransitionDelegate> destinationTransition;



@end

NS_ASSUME_NONNULL_END
