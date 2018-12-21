//
//  DNPlayerAutoPlayManagerConfig.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DNPlayerAutoplayDelegate;

typedef NS_ENUM(NSUInteger, DNAutoplayScrollAnimationType) {
    DNAutoplayScrollAnimationTypeNone,
    DNAutoplayScrollAnimationTypeTop,
    DNAutoplayScrollAnimationTypeMiddle,
};

@interface DNPlayerAutoPlayManagerConfig : NSObject

+ (instancetype)configWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                            autoplayDelegate:(id<DNPlayerAutoplayDelegate>)autoplayDelegate;

/// 滚动的动画类型
/// default is .Middle;
@property (nonatomic) DNAutoplayScrollAnimationType animationType;

@property (nonatomic, readonly) NSInteger playerSuperviewTag;
@property (nonatomic, weak, nullable, readonly) id<DNPlayerAutoplayDelegate> autoplayDelegate;

@end


@protocol DNPlayerAutoplayDelegate <NSObject>
- (void)dn_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
