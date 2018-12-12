//
//  DNAdPlayToEndView.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/11.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import "DNAdPlayToEndView.h"
#import "DNPlayerTypeDef.h"
@interface DNAdPlayToEndView ()
/// 背景图片.(默认加蒙层)
@property (nonatomic, strong) UIImageView *backGroundImageView;
/// 重新播放按钮
@property (nonatomic, strong) UIButton *replayBtn;
/// 广告头像;(若没有则显示纯色背景图+广告主第一个汉字展示)
@property (nonatomic, strong) UIImageView *logoBgImg;
@property (nonatomic, strong) UILabel *logoNameLabel;
/// 头像下方详情label
@property (nonatomic, strong) UILabel *detailLabel;
/// 查看详情按钮
@property (nonatomic, strong) UIButton *detailBtn;

@end

@implementation DNAdPlayToEndView

+ (instancetype)dnAdPlayToEndView
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化子视图
        [self creatSubViews];
        //设置布局
        [self makeSubViewsConstraints];
    }
    return self;
}

- (void)creatSubViews
{
    [self addSubview:self.backGroundImageView];
    [self addSubview:self.logoBgImg];
    [self addSubview:self.logoNameLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.detailBtn];
    [self addSubview:self.replayBtn];

}


- (void)makeSubViewsConstraints
{
    @weakify(self)
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.leading.trailing.bottom.equalTo(self);
    }];

    [self.logoBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self).offset(44);
        make.width.height.mas_equalTo(45);
        make.centerX.equalTo(self);
    }];

    [self.logoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(44);
        make.width.height.mas_equalTo(45);
        make.centerX.equalTo(self);
    }];

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.logoBgImg.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.centerX.equalTo(self.logoBgImg);
    }];

    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.detailLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.centerX.equalTo(self.detailLabel);
    }];

    [self.replayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];

}

- (void)detailButtonClicked:(UIButton *)sender
{
    if (self.detailBtnClickBlock) {
        self.detailBtnClickBlock(sender);
    }
}

- (void)replayBtnClicked:(UIButton *)sender
{
    if (self.replayBtnClickBlock) {
        self.replayBtnClickBlock(sender);
    }
}


- (UIImageView *)backGroundImageView
{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc] init];
        _backGroundImageView.backgroundColor = MRandomColor;
        UIView *masView = [[UIView alloc]init];
        masView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_backGroundImageView addSubview:masView];
        [masView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self->_backGroundImageView);

        }];
    }
    return _backGroundImageView;
}

- (UIButton *)replayBtn
{
    if (!_replayBtn) {
        _replayBtn  = [[UIButton alloc] init];
        _replayBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:91/255.0 blue:5/255.0 alpha:1.0];
        _replayBtn.layer.cornerRadius = 4;
        _replayBtn.clipsToBounds = YES;
        _replayBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_replayBtn setTitle:@"重播" forState:UIControlStateNormal];
        [_replayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_replayBtn addTarget:self action:@selector(replayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replayBtn;
}

- (UILabel *)logoNameLabel
{
    if (!_logoNameLabel) {
        _logoNameLabel = [[UILabel alloc]init];
        _logoNameLabel.textColor = [UIColor whiteColor];
        _logoNameLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:91/255.0 blue:5/255.0 alpha:1.0];
        _logoNameLabel.textAlignment = NSTextAlignmentCenter;
        _logoNameLabel.font = [UIFont systemFontOfSize:25];
        _logoNameLabel.text = @"拼";
        _logoNameLabel.layer.cornerRadius = 45/2;
        _logoNameLabel.clipsToBounds = YES;
    }
    return _logoNameLabel;
}

- (UIImageView *)logoBgImg
{
    if (!_logoBgImg) {
        _logoBgImg = [[UIImageView alloc] init];
        _logoBgImg.backgroundColor = MRandomColor;
        _logoBgImg.layer.cornerRadius = 45/2;
        _logoBgImg.clipsToBounds = YES;
    }
    return _logoBgImg;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.backgroundColor = MRandomColor;
        _detailLabel.text = @"广告主名称";
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

- (UIButton *)detailBtn
{
    if (!_detailBtn) {
        _detailBtn  = [[UIButton alloc] init];
        _detailBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:91/255.0 blue:5/255.0 alpha:1.0];
        _detailBtn.layer.cornerRadius = 4;
        _detailBtn.clipsToBounds = YES;
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBtn;
}

@end
