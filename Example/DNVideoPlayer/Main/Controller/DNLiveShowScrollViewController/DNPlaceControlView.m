//
//  DNPlaceControlView.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2019/1/7.
//  Copyright © 2019 563620078@qq.com. All rights reserved.
//

#import "DNPlaceControlView.h"
#import "DNVideoDetailViewController.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>

@interface DNPlaceControlView ()

@property (nonatomic, strong) DNVideoDetailViewController *desVc;

@end


@implementation DNPlaceControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{

}


- (void)pushLiveShowWithliveId
{
    self.desVc = [[DNVideoDetailViewController alloc]init];
//    [self zz_pushViewController:desVc animated:NO];
    [self addSubview:self.desVc.view];
}

- (void)popLiveShowVc
{
    [self.desVc.view removeFromSuperview];
}

@end
