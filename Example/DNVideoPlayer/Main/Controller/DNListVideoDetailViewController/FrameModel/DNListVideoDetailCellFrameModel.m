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

#define Title_H 15+45+15
#define VideoView_H (ScreenWidth * 9 / 16)
#define BottomView_H 15+30+10+20+15
@interface DNListVideoDetailCellFrameModel ()

@property (nonatomic, assign) CGFloat itemCellHeight; // cell预缓存的行高
@property (nonatomic, strong) DNListVideoDetailTableViewCell *cell;

@end

@implementation DNListVideoDetailCellFrameModel

- (instancetype)initWithModel:(DNVideoListItemModel *)model {
    if (self = [super initWithModel:model]) {

        self.itemCellHeight = Title_H + 15 + VideoView_H + BottomView_H;

    }
    return self;
}

- (void)layout:(DNListVideoDetailTableViewCell *)view
{
    self.cell = view;
//    [self setData:view]; //赋值

    view.titleLabel.ct_top = 0;
    view.titleLabel.ct_left = 0;
    view.titleLabel.ct_size = CGSizeMake(ScreenWidth, Title_H);

    view.videoPlaceHolderView.ct_top = CGRectGetMaxY(view.titleLabel.frame)+15;
    view.videoPlaceHolderView.ct_left = 0;
    view.videoPlaceHolderView.ct_size = CGSizeMake(ScreenWidth, VideoView_H);

    view.bottomView.ct_top = CGRectGetMaxY(view.videoPlaceHolderView.frame);
    view.bottomView.ct_left = 0;
    view.bottomView.ct_size = CGSizeMake(ScreenWidth, BottomView_H);


}

- (CGSize)itemSize
{
    return CGSizeMake(ScreenWidth, self.itemCellHeight);
}


@end
