//
//  DNVideoCellBottomView.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/24.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoCellBottomView.h"
#import "DNVideoListItemFrameModel.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>

#define Margin 15
#define SelectedHeight 60+50
#define ImageIconWH 30
#define TopView_WH 60
#define BottomView_WH 50
#define AnimateDuration 0.35
/// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
/// 屏幕宽度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

//四个View
#pragma mark - 左侧标签视图
//1.标签视图
@implementation DNLeftTagLabelsView

+ (instancetype)dnLeftTagLabelsView
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

@end

#pragma mark - 左侧分享视图
//2.分享视图
@implementation DNLeftShareView

+ (instancetype)dnLeftShareView
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self addSubview:self.shareLabel];
        [self addSubview:self.shareToWechatTimeLine];
        [self addSubview:self.shareToWechatSession];

        [self setSubViewsFrame];

    }
    return self;
}

- (void)setSubViewsFrame
{
    self.shareLabel.top = Margin;
    self.shareLabel.left = 0;
    self.shareLabel.size = CGSizeMake(47, 21);
//    self.shareLabel.centerY = self.centerY;

    self.shareToWechatTimeLine.top = Margin;
    self.shareToWechatTimeLine.left = CGRectGetMaxX(self.shareLabel.frame) + 15;
    self.shareToWechatTimeLine.size = CGSizeMake(23, 21);
//    self.shareToWechatTimeLine.centerY = self.shareLabel.centerY;

    self.shareToWechatSession.top = Margin;
    self.shareToWechatSession.left = CGRectGetMaxX(self.shareToWechatTimeLine.frame) + Margin;
    self.shareToWechatSession.size = CGSizeMake(23, 21);
//    self.shareToWechatSession.centerY = self.shareLabel.centerY;
}


- (UILabel *)shareLabel
{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc]init];
        _shareLabel.text = @"分享到";
//        _shareLabel.backgroundColor = MRandomColor;
        _shareLabel.textColor = [UIColor blackColor];
        _shareLabel.font = [UIFont systemFontOfSize:15];
    }
    return _shareLabel;
}

- (UIButton *)shareToWechatSession
{
    if (!_shareToWechatSession) {
        _shareToWechatSession = [[UIButton alloc]init];
//        _shareToWechatSession.backgroundColor = MRandomColor;
        _shareToWechatSession.adjustsImageWhenHighlighted = NO;
        [_shareToWechatSession setImage:[UIImage imageNamed:@"bottomView_WechatSesstion_icon"] forState:UIControlStateNormal];
    }
    return _shareToWechatSession;
}

- (UIButton *)shareToWechatTimeLine
{
    if (!_shareToWechatTimeLine) {
        _shareToWechatTimeLine = [[UIButton alloc]init];
//        _shareToWechatTimeLine.backgroundColor = MRandomColor;
        _shareToWechatTimeLine.adjustsImageWhenHighlighted = NO;
        [_shareToWechatTimeLine setImage:[UIImage imageNamed:@"bottomView_WechatTimeLine_icon"] forState:UIControlStateNormal];
    }
    return _shareToWechatTimeLine;
}


@end

#pragma mark - 左侧作者头像名称视图
//3.作者头像名称视图
@implementation DNLeftAuthorView

+ (instancetype)dnLeftAuthorView
{
    return [[self alloc]init];;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLabel];

        [self setSubViewsFrame];
    }
    return self;
}

- (void)setSubViewsFrame
{
    self.headerImageView.top = Margin;
    self.headerImageView.left = 0;
    self.headerImageView.size = CGSizeMake(30, 30);

    self.nameLabel.top = Margin+5;
    self.nameLabel.left = CGRectGetMaxX(self.headerImageView.frame)+10;
//    self.nameLabel.centerY = self.headerImageView.centerY;
    self.nameLabel.size = CGSizeMake(100, 21);

}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.backgroundColor = MRandomColor;
        _headerImageView.layer.cornerRadius = 15;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.text = @"发布者名称";
    }
    return _nameLabel;
}

@end

#pragma mark - 右侧收藏,评论,分享弹窗视图
//4.收藏,评论,分享弹窗视图
@implementation DNRightCollectView

+ (instancetype)dnRightCollectView
{
    return [[self alloc]init];;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.shareButton];
        [self addSubview:self.commentButton];
        [self addSubview:self.collectButton];

        [self setUpSubViewsFrame];
    }
    return self;
}

- (void)setUpSubViewsFrame
{
    self.shareButton.top = Margin;
    self.shareButton.size = CGSizeMake(20, 20);

    self.commentButton.top = self.shareButton.top;
    self.commentButton.size = CGSizeMake(20, 20);

    self.collectButton.top = self.commentButton.top;
    self.collectButton.size = CGSizeMake(20, 20);

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.shareButton.right = self.width;
    self.commentButton.right = self.width - (20 + Margin*2);
    self.collectButton.right = self.width - (20 + Margin*2) - (20 + Margin*2);

}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton  = [[UIButton alloc] init];
//        _shareButton.backgroundColor = [UIColor redColor];
//        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setImage:[UIImage imageNamed:@"bottomView_share_icon"] forState:UIControlStateNormal];
    }
    return _shareButton;
}

- (UIButton *)collectButton
{
    if (!_collectButton) {
        _collectButton  = [[UIButton alloc] init];
//        _collectButton.backgroundColor = [UIColor redColor];
        //        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_collectButton setImage:[UIImage imageNamed:@"bottomView_collect_icon"] forState:UIControlStateNormal];
    }
    return _collectButton;
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton  = [[UIButton alloc] init];
//        _commentButton.backgroundColor = [UIColor redColor];
        //        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setImage:[UIImage imageNamed:@"bottomView_reply_icon"] forState:UIControlStateNormal];
    }
    return _commentButton;
}




@end


#pragma mark - 底部主视图
@implementation DNVideoCellBottomView

+ (instancetype)dnVideoCellBottomView
{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatSubViews];
        //添加点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)creatSubViews
{
    [self addSubview:self.leftTagsView];
    [self addSubview:self.leftAuthorView];
    [self addSubview:self.leftShareView];
    [self addSubview:self.centerLineView];
    [self addSubview:self.rightCollectView];

    //添加点击事件
    //添加点击事件
    UITapGestureRecognizer *tapHeaderImagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageTapAction:)];
    [self.leftAuthorView.headerImageView addGestureRecognizer:tapHeaderImagGesture];
}

- (void)headerImageTapAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"headerImageTapActionBlock--单击事件");
    if (self.headerImageTapActionBlock) {
        self.headerImageTapActionBlock(gesture);
    }
}

- (void)bottomViewTapAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"bottomViewTapActionBlock--单击事件");
    if (self.bottomViewTapActionBlock) {
        self.bottomViewTapActionBlock(gesture);
    }
}

- (void)setFrameModel:(DNVideoListItemFrameModel *)frameModel
{
    _frameModel = frameModel;

    self.leftTagsView.frame = CGRectMake(Margin, -(TopView_WH/2), 100, TopView_WH);

    self.centerLineView.frame = CGRectMake(Margin, TopView_WH, ScreenWidth - 2*Margin, 0.5f);
//    CGFloat authorView_Y = SelectedHeight/4 - (ImageIconWH/2);
    self.leftAuthorView.frame = CGRectMake(Margin, 0, 150, TopView_WH);

    CGFloat rightView_W = 2*Margin + 150;
    self.rightCollectView.frame = CGRectMake(ScreenWidth-rightView_W-Margin, 5, rightView_W, BottomView_WH);

    self.leftShareView.frame = CGRectMake(Margin, SelectedHeight, 130, 51);

    self.leftTagsView.alpha = 0;
    self.leftShareView.alpha = 0;
    self.centerLineView.alpha = 0;
    self.leftAuthorView.alpha = 1;

    CGFloat RightCollectView_SelectCenterY = BottomView_WH/2 + TopView_WH;

    if (_frameModel.isSelected) {

        @weakify(self)
        [UIView animateWithDuration:AnimateDuration animations:^{
            @strongify(self)
            self.leftTagsView.alpha = 1;
            self.leftAuthorView.alpha = 0;
            self.leftShareView.alpha = 1;
            self.centerLineView.alpha = 1;

            self.leftTagsView.centerY = TopView_WH/2;
            self.rightCollectView.centerY = RightCollectView_SelectCenterY;
            self.leftAuthorView.centerY = RightCollectView_SelectCenterY;




        }completion:^(BOOL finished) {


            [UIView animateWithDuration:AnimateDuration animations:^{
                @strongify(self)
                self.leftShareView.centerY = self.leftAuthorView.centerY;

            }];

        }];

    }else{

        self.leftAuthorView.top = 0;

    }






}


#pragma mark - lazyload
- (DNLeftTagLabelsView *)leftTagsView
{
    if (!_leftTagsView) {
        _leftTagsView = [DNLeftTagLabelsView dnLeftTagLabelsView];
        _leftTagsView.backgroundColor = [UIColor purpleColor];
    }
    return _leftTagsView;
}

-(DNLeftShareView *)leftShareView
{
    if (!_leftShareView) {
        _leftShareView = [DNLeftShareView dnLeftShareView];
        _leftShareView.backgroundColor = [UIColor clearColor];
    }
    return _leftShareView;
}

- (DNLeftAuthorView *)leftAuthorView
{
    if (!_leftAuthorView) {
        _leftAuthorView = [DNLeftAuthorView dnLeftAuthorView];
        _leftAuthorView.backgroundColor = [UIColor clearColor];

    }
    return _leftAuthorView;
}

- (DNRightCollectView *)rightCollectView
{
    if (!_rightCollectView) {
        _rightCollectView = [DNRightCollectView dnRightCollectView];
        _rightCollectView.backgroundColor = [UIColor clearColor];
    }
    return _rightCollectView;
}

- (UIView *)centerLineView
{
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc]init];
        _centerLineView.backgroundColor = [UIColor grayColor];
    }
    return _centerLineView;
}

@end
