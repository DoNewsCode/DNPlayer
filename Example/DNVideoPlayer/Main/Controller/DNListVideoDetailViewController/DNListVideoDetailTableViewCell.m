//
//  DNListVideoDetailTableViewCell.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/26.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNListVideoDetailTableViewCell.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>

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
    [self.contentView addSubview:self.videoPlaceHolderView];
//    [self.contentView addSubview:self.bottomView];
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


- (void)setLayout:(id<DNVideoFrameModelProtocol>)layoutModel
{
    [layoutModel layout:self];
}

@end
