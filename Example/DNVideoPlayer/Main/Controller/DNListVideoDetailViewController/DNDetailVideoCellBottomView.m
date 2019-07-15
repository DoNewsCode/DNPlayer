//
//  DNDetailVideoCellBottomView.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/27.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNDetailVideoCellBottomView.h"
#import <DNCommonKit/UIView+Layout.h>

#define marginNormal 15

@interface DNDetailVideoCellBottomView ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation DNDetailVideoCellBottomView

+ (instancetype)dnDetailVideoCellBottomView
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.tagsLabel];
    [self addSubview:self.zanBtn];
    [self addSubview:self.commentBtn];
    [self addSubview:self.collectBtn];
    [self addSubview:self.shareBtn];

    [self setSubViewsFrame];
}

- (void)setSubViewsFrame
{
    self.headerImageView.ct_top = marginNormal;
    self.headerImageView.ct_left = marginNormal;
    self.headerImageView.ct_size = CGSizeMake(30, 30);

    self.nameLabel.ct_top = 20;
    self.nameLabel.ct_left = CGRectGetMaxX(self.headerImageView.frame)+10;
    self.nameLabel.ct_size = CGSizeMake(50, 20);


    self.tagsLabel.ct_size = CGSizeMake(SCREEN_WIDTH-2*marginNormal - 30, 20);
    self.tagsLabel.ct_right = SCREEN_WIDTH - marginNormal;
    self.tagsLabel.ct_top = 22;


    self.zanBtn.ct_top = CGRectGetMaxY(self.headerImageView.frame)+ marginNormal;
    self.zanBtn.ct_left = marginNormal;
    self.zanBtn.ct_size = CGSizeMake(20, 20);


    self.commentBtn.ct_left = 125;
    self.commentBtn.ct_top = self.zanBtn.ct_top;
    self.commentBtn.ct_size = CGSizeMake(20, 20);

    self.collectBtn.ct_left = 236;
    self.collectBtn.ct_top = self.commentBtn.ct_top;
    self.collectBtn.ct_size = CGSizeMake(20, 20);

    self.shareBtn.ct_top = self.collectBtn.ct_top;
    self.shareBtn.ct_size = CGSizeMake(20, 20);
    self.shareBtn.ct_right = SCREEN_WIDTH - marginNormal;

}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.backgroundColor = [UIColor redColor];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)tagsLabel
{
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc]init];
        _tagsLabel.textColor = [UIColor blueColor];
        _tagsLabel.textAlignment = NSTextAlignmentCenter;
        _tagsLabel.numberOfLines = 0;
        _tagsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _tagsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tagsLabel;
}

- (UIButton *)zanBtn
{
    if (!_zanBtn) {
        _zanBtn  = [[UIButton alloc] init];
        _zanBtn.backgroundColor = [UIColor redColor];
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:5.0f];
        [_zanBtn setTitle:@"123" forState:UIControlStateNormal];
        [_zanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zanBtn addTarget:self action:@selector(zanbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _zanBtn.imageView.image = [UIImage imageNamed:@""];
    }
    return _zanBtn;
}

- (UIButton *)commentBtn
{
    if (!_commentBtn) {
        _commentBtn  = [[UIButton alloc] init];
        _commentBtn.backgroundColor = [UIColor redColor];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:5.0f];
        [_commentBtn setTitle:@"2223" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.imageView.image = [UIImage imageNamed:@""];
    }
    return _commentBtn;
}

- (UIButton *)collectBtn
{
    if (!_collectBtn) {
        _collectBtn  = [[UIButton alloc] init];
        _collectBtn.backgroundColor = [UIColor redColor];
        _collectBtn.titleLabel.font = [UIFont systemFontOfSize:5.0f];
        [_collectBtn addTarget:self action:@selector(collectBtnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _collectBtn.imageView.image = [UIImage imageNamed:@""];
    }
    return _collectBtn;
}

@end
