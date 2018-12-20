//
//  DNVideoPlaceHolderView.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/20.
//

#import "DNVideoPlaceHolderView.h"
#import "DNPlayerTypeDef.h"

@interface DNVideoPlaceHolderView ()
//1.垫底图片
@property (nonatomic, strong) UIImageView *bgVideoImageView;
//2.顶部标题
@property (nonatomic, strong) UILabel *titleLabel;
//3.顶部阴影层
@property (nonatomic, strong) UIImageView *maskImageView;
//4.视频播放按钮
@property (nonatomic, strong) UIButton *playBtn;
//5.视频时间显示label
@property (nonatomic, strong) UILabel *timeLabel;
@end


@implementation DNVideoPlaceHolderView

+ (instancetype)dnVideoPlaceHolderViewWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    //1.垫底图片
    [self addSubview:self.bgVideoImageView];
    //2.顶部标题
    [self addSubview:self.titleLabel];
    //3.顶部阴影层
    [self addSubview:self.maskImageView];
    //4.视频播放按钮
    [self addSubview:self.playBtn];
    //5.视频时间显示label
    [self addSubview:self.timeLabel];

    @weakify(self)
    [self.bgVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.leading.trailing.bottom.equalTo(self);
    }];

    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(45);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(45);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(48, 20));
    }];

    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (UIImageView *)bgVideoImageView
{
    if (!_bgVideoImageView) {
        _bgVideoImageView = [[UIImageView alloc] init];
        _bgVideoImageView.backgroundColor = MRandomColor;
    }
    return _bgVideoImageView;
}

- (UIImageView *)maskImageView
{
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] init];
        [_maskImageView setImage:[UIImage imageWithImageName:@"player_shadowTop_icon" inBundle:self.resourceBundle]];
    }
    return _maskImageView;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn  = [[UIButton alloc] init];
        [_playBtn addTarget:self action:@selector(playbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setImage:[UIImage imageWithImageName:@"placeHolder_PlayBtn_icon" inBundle:self.resourceBundle] forState:UIControlStateNormal];
    }
    return _playBtn;
}

- (void)playbuttonClicked:(id)sender
{
    if (self.placeHolderPlayBtnClickBlock) {
        self.placeHolderPlayBtnClickBlock(sender);
    }

}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:11.0];
        _timeLabel.layer.cornerRadius = 10;
        _timeLabel.backgroundColor = [UIColor blackColor];
    }
    return _timeLabel;
}



@end
