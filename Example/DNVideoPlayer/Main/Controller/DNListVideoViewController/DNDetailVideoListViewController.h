//
//  DNDetailVideoListViewController.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DNVideoPlayer/DNVideoPlayerView.h>
#import <DNVideoPlayer/UIScrollView+DNListVideoPlayerAutoPlay.h>
#import <DNVideoPlayer/DNCustomAnimator.h>
NS_ASSUME_NONNULL_BEGIN

@interface DNDetailVideoListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DNPlayerAutoplayDelegate,DNVideoPlayerViewDelegate,DNCustomTransitionAnimating>

@property (nonatomic, strong) UITableView *videoListTableView;
/// 设置播放模式
- (void)configPlayMode;
@end

NS_ASSUME_NONNULL_END
