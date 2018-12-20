//
//  DNVideoListTableViewItemCell.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoListTableViewItemCell.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>

@interface DNVideoListTableViewItemCell ()


@end


@implementation DNVideoListTableViewItemCell

+ (DNVideoListTableViewItemCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *DNVideoListTableViewItemCellID = [NSString stringWithFormat:@"DNVideoListTableViewItemCell-%ld-%ld",indexPath.section,indexPath.row];

    DNVideoListTableViewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:DNVideoListTableViewItemCellID];
    if ( !cell ) cell = [[DNVideoListTableViewItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DNVideoListTableViewItemCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = MRandomColor;
        [self creatSubViews];
    }
    return self;
}


- (void)creatSubViews
{
    [self.contentView addSubview:self.videoPlaceHolderView];
    [self.contentView addSubview:self.bottomView];
    @weakify(self)
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.leading.trailing.offset(0);
        make.height.mas_equalTo(50);
    }];
//    self.videoPlaceHolderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.videoPlaceHolderView.top = 0;
    self.videoPlaceHolderView.left = 0;
    self.videoPlaceHolderView.size = CGSizeMake(ScreenWidth, ScreenWidth * 9 /16);
//    [self.videoPlaceHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.top.mas_equalTo(0);
//        make.leading.trailing.offset(0);
//        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenWidth * 9 /16));
//    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = MRandomColor;
    }
    return _bottomView;
}

- (DNVideoPlaceHolderView *)videoPlaceHolderView
{
    if (!_videoPlaceHolderView) {
        _videoPlaceHolderView = [[DNVideoPlaceHolderView alloc]init];
        _videoPlaceHolderView.backgroundColor = MRandomColor;
        _videoPlaceHolderView.contentMode = UIViewContentModeScaleAspectFit;
        _videoPlaceHolderView.userInteractionEnabled = YES;
        _videoPlaceHolderView.tag = 101;
        @weakify(self)
        [_videoPlaceHolderView setPlaceHolderPlayBtnClickBlock:^(id sender) {
            @strongify(self)
            if (self.playBtnClickBlock) {
                self.playBtnClickBlock(sender);
            }
        }];
    }
    return _videoPlaceHolderView;
}


@end
