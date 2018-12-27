//
//  DNVideoListItemFrameModel.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/24.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoListItemFrameModel.h"
#import "DNVideoListTableViewItemCell.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>
#import <DNCommonKit/UIView+Layout.h>
@interface DNVideoListItemFrameModel ()
@property (nonatomic, assign) CGFloat itemCellHeight; // cell预缓存的行高
@property (nonatomic, assign) CGFloat itemCellSelectHeight;
@property (nonatomic, strong) DNVideoListTableViewItemCell *cell;
@end

@implementation DNVideoListItemFrameModel


- (instancetype)initWithModel:(DNVideoListItemModel *)model {
    if (self = [super initWithModel:model]) {

        self.isSelected = NO;
        self.itemCellHeight = (ScreenWidth * 9 / 16)+60;
        self.itemCellSelectHeight = (ScreenWidth * 9 / 16)+60+51;
        self.cellItemHeight = self.itemCellHeight;
    }
    return self;
}

- (void)layout:(DNVideoListTableViewItemCell *)view
{
    self.cell = view;
    [self setData:view]; //赋值

    view.videoPlaceHolderView.ct_top = 0;
    view.videoPlaceHolderView.ct_left = 0;
    view.videoPlaceHolderView.ct_size = CGSizeMake(ScreenWidth, ScreenWidth * 9 /16);

    view.bottomView.ct_top = CGRectGetMaxY(view.videoPlaceHolderView.frame);
    view.bottomView.ct_width = ScreenWidth;
    view.bottomView.ct_left = 0;
//
    if (self.isSelected) {
        view.bottomView.ct_height = 60+51;
    }else{
        view.bottomView.ct_height = 60;
    }

    view.bottomView.frameModel = self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.cell.bottomView.frameModel = self;

    if (_isSelected) {

        self.cellItemHeight = self.itemCellSelectHeight;
        self.cell.bottomView.ct_height = 60+51;
    }else{

        self.cellItemHeight = self.itemCellHeight;
        self.cell.bottomView.ct_height = 60;
    }

}


- (void)setData:(DNVideoListTableViewItemCell *)cell
{

}

- (CGSize)itemSize
{
    if (self.isSelected) {
        return CGSizeMake(ScreenWidth, self.itemCellSelectHeight);
    }else{
        return CGSizeMake(ScreenWidth, self.itemCellHeight);
    }
}



@end
