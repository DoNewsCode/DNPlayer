//
//  DNListVideoDetailCellFrameModel.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/27.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNListVideoDetailCellFrameModel.h"
#import <DNCommonKit/UIView+Layout.h>
#import "DNListVideoDetailTableViewCell.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>

@interface DNListVideoDetailCellFrameModel ()

@property (nonatomic, assign) CGFloat itemCellHeight; // cell预缓存的行高
@property (nonatomic, strong) DNListVideoDetailTableViewCell *cell;

@end

@implementation DNListVideoDetailCellFrameModel

- (instancetype)initWithModel:(DNVideoListItemModel *)model {
    if (self = [super initWithModel:model]) {

        self.itemCellHeight = (45+15) + (ScreenWidth * 9 / 16) + (107 - 30);
    }
    return self;
}

- (void)layout:(DNListVideoDetailTableViewCell *)view
{
    self.cell = view;
//    [self setData:view]; //赋值

    view.videoPlaceHolderView.ct_top = 0;
    view.videoPlaceHolderView.ct_left = 0;
    view.videoPlaceHolderView.ct_size = CGSizeMake(ScreenWidth, ScreenWidth * 9 /16);

//    view.bottomView.top = CGRectGetMaxY(view.videoPlaceHolderView.frame);
//    view.bottomView.width = ScreenWidth;
//    view.bottomView.left = 0;
//
//    view.bottomView.frameModel = self;
}

- (CGSize)itemSize
{
    return CGSizeMake(ScreenWidth, self.itemCellHeight);
}


@end
