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
    [self setData:view]; //赋值

    view.videoPlaceHolderView.top = 0;
    view.videoPlaceHolderView.left = 0;
    view.videoPlaceHolderView.size = CGSizeMake(ScreenWidth, ScreenWidth * 9 /16);


//    @weakify(self)
    [view.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.leading.trailing.offset(0);
        make.height.mas_equalTo(50);
    }];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        self.cellItemHeight = self.itemCellSelectHeight;
    }else{
        self.cellItemHeight = self.itemCellHeight;
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
