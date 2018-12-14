//
//  DNPlayerAutoPlayManagerConfig.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import "DNPlayerAutoPlayManagerConfig.h"

@implementation DNPlayerAutoPlayManagerConfig

+ (instancetype)configWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                            autoplayDelegate:(id<SJPlayerAutoplayDelegate>)autoplayDelegate {
    NSParameterAssert(playerSuperviewTag != 0);
    NSParameterAssert(autoplayDelegate != nil);

    DNPlayerAutoPlayManagerConfig *config = [DNPlayerAutoPlayManagerConfig new];
    config->_playerSuperviewTag = playerSuperviewTag;
    config->_autoplayDelegate = autoplayDelegate;
    config->_animationType = SJAutoplayScrollAnimationTypeTop;
    return config;
}

@end
