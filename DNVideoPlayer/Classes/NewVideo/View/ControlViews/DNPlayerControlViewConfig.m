//
//  DNPlayerControlViewConfig.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/21.
//

#import "DNPlayerControlViewConfig.h"

@implementation DNPlayerControlViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化
        self.isShowBackBtn = NO;
        self.isShowBottomProgressView = YES;
        self.isAnimateShowContainerView = YES;
        self.isShowSystemActivityLoadingView = YES;
        
    }
    return self;
}

@end
