//
//  DNVideoListTableViewItemCell.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoListTableViewItemCell.h"
//#import "DNVideoPlayerView.h"
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
    [self.contentView addSubview:self.placeHolderView];
    self.placeHolderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

- (UIImageView *)placeHolderView
{
    if (!_placeHolderView) {
        _placeHolderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"abc.jpeg"]];
//        _placeHolderView.backgroundColor = MRandomColor;
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn addTarget:self action:@selector(PlayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        playBtn.backgroundColor = [UIColor blueColor];
        [_placeHolderView addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self->_placeHolderView);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        _placeHolderView.contentMode = UIViewContentModeScaleAspectFit;
        _placeHolderView.userInteractionEnabled = YES;
        _placeHolderView.tag = 101;
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
