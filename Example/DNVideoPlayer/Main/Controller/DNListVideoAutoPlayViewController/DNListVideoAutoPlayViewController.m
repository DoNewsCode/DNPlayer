//
//  DNListVideoAutoPlayViewController.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/17.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNListVideoAutoPlayViewController.h"

@interface DNListVideoAutoPlayViewController ()

@end

@implementation DNListVideoAutoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)configPlayMode
{
    [self.videoListTableView sj_enableAutoplayWithConfig:[DNPlayerAutoPlayManagerConfig configWithPlayerSuperviewTag:101 autoplayDelegate:self]];
    [self.videoListTableView sj_needPlayNextAsset];
}


@end
