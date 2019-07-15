//
//  DNListVideoDetailTableViewCell.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/26.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNListVideoDetailTableViewCell.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>


@interface DNListVideoDetailTableViewCell ()


@end

@implementation DNListVideoDetailTableViewCell

+ (DNListVideoDetailTableViewCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *DNListVideoDetailTableViewCellID = [NSString stringWithFormat:@"DNListVideoDetailTableViewCellID-%ld-%ld",indexPath.section,indexPath.row];

    DNListVideoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DNListVideoDetailTableViewCellID];
    if ( !cell ) cell = [[DNListVideoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DNListVideoDetailTableViewCellID];
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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.videoPlaceHolderView];
    [self.contentView addSubview:self.bottomView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (DNVideoPlaceHolderView *)videoPlaceHolderView
{
    if (!_videoPlaceHolderView) {
        _videoPlaceHolderView = [[DNVideoPlaceHolderView alloc]init];
//        _videoPlaceHolderView.backgroundColor = MRandomColor;
        _videoPlaceHolderView.contentMode = UIViewContentModeScaleAspectFit;
        _videoPlaceHolderView.userInteractionEnabled = YES;
        _videoPlaceHolderView.tag = 10001;
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor greenColor];
        _titleLabel.text = @"视频详情列表页ItemCell标题视频详情列表页ItemCell标题视频详情列表页ItemCell标题";
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _titleLabel;
}

- (DNDetailVideoCellBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [DNDetailVideoCellBottomView dnDetailVideoCellBottomView];
        _bottomView.backgroundColor = [UIColor purpleColor];
    }
    return _bottomView;
}


- (void)setLayout:(id<DNVideoFrameModelProtocol>)layoutModel
{
    [layoutModel layout:self];
}

@end
