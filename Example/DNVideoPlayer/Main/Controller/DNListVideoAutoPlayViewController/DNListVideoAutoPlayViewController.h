//
//  DNListVideoAutoPlayViewController.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/17.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DNVideoPlayer/DNVideoPlayerView.h>
#import <DNVideoPlayer/UIScrollView+DNListVideoPlayerAutoPlay.h>
#import <DNVideoPlayer/DNCustomAnimator.h>

#import "DNVideoListItemFrameModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DNListVideoAutoPlayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DNPlayerAutoplayDelegate,DNVideoPlayerViewDelegate,DNCustomTransitionAnimating>


@property (nonatomic, strong) NSArray <DNVideoListItemFrameModel *> *videoFrameModels;
@property (nonatomic, strong) UITableView *videoListTableView;
/// 记录当前播放的 Cell indexPath
@property (nonatomic, readonly, strong) NSIndexPath *markTempIndexPath;

@end

NS_ASSUME_NONNULL_END
