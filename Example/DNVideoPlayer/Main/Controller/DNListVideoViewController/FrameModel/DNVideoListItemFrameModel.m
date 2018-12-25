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

@interface DNVideoListItemFrameModel ()
@property (nonatomic, assign) CGFloat itemCellHeight; // cell预缓存的行高
@property (nonatomic, assign) CGFloat itemCellSelectHeight;
@property (nonatomic, strong) DNVideoListTableViewItemCell *cell;
@end

@implementation DNVideoListItemFrameModel


- (instancetype)initWithModel:(DNVideoListItemModel *)model {
    if (self = [super initWithModel:model]) {

        self.isSelected = NO;
        self.itemCellHeight = (ScreenWidth * 9 / 16)+50;
        self.itemCellSelectHeight = (ScreenWidth * 9 / 16)+50+50;
        self.cellItemHeight = self.itemCellHeight;
    }
    return self;
}

- (void)layout:(DNVideoListTableViewItemCell *)view
{
    self.cell = view;
    [self setData:view]; //赋值

    view.videoPlaceHolderView.top = 0;
    view.videoPlaceHolderView.left = 0;
    view.videoPlaceHolderView.size = CGSizeMake(ScreenWidth, ScreenWidth * 9 /16);

    view.bottomView.top = CGRectGetMaxY(view.videoPlaceHolderView.frame);
    view.bottomView.width = ScreenWidth;
    view.bottomView.left = 0;
//
    if (self.isSelected) {
        view.bottomView.height = 100;
    }else{
        view.bottomView.height = 50;
    }

    view.bottomView.frameModel = self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.cell.bottomView.frameModel = self;

    if (_isSelected) {

        self.cellItemHeight = self.itemCellSelectHeight;
        self.cell.bottomView.height = 100;
    }else{

        self.cellItemHeight = self.itemCellHeight;
        self.cell.bottomView.height = 50;
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
