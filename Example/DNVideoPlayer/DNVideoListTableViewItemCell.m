//
//  DNVideoListTableViewItemCell.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoListTableViewItemCell.h"
#import "DNVideoPlayerView.h"

@interface DNVideoListTableViewItemCell ()


@end


@implementation DNVideoListTableViewItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
    }
    return self;
}


- (void)creatSubViews
{
    self.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.placeHolderView];
    self.placeHolderView.frame = self.contentView.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeHolderView.frame = self.contentView.bounds;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

}



- (UIView *)placeHolderView
{
    if (!_placeHolderView) {
        _placeHolderView = [[UIView alloc]init];
        _placeHolderView.backgroundColor = MRandomColor;
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn addTarget:self action:@selector(PlayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        playBtn.backgroundColor = [UIColor blueColor];
        [_placeHolderView addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self->_placeHolderView);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    return _placeHolderView;
}

- (void)PlayBtnClickAction:(UIButton *)sender
{
    if (self.playBtnClickBlock) {
        self.playBtnClickBlock(sender);
    }
}

@end
