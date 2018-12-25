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
#define SelectedHeight 100
#define ImageIconWH 30
#define RightBtnWH 50
#define AnimateDuration 0.35
/// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
/// 屏幕宽度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

//四个View
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

    }
    return self;
}

@end

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

    }
    return self;
}

@end

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

    }
    return self;
}

@end


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

//    [self setUpSubViewsFrame];
}

- (void)bottomViewTapAction:(UITapGestureRecognizer *)gesture
{
    NSLog(@"单击事件");
    if (self.bottomViewTapActionBlock) {
        self.bottomViewTapActionBlock(gesture);
    }
}

- (void)setFrameModel:(DNVideoListItemFrameModel *)frameModel
{
    _frameModel = frameModel;

    self.leftTagsView.frame = CGRectMake(Margin, -(RightBtnWH/2), 100, RightBtnWH);

    self.centerLineView.frame = CGRectMake(Margin, SelectedHeight/2 - 0.5f, ScreenWidth - 2*Margin, 0.5f);
    CGFloat authorView_Y = SelectedHeight/4 - (ImageIconWH/2);
    self.leftAuthorView.frame = CGRectMake(Margin, authorView_Y, ImageIconWH, ImageIconWH);

    CGFloat rightView_W = 2*Margin + 3*RightBtnWH;
    self.rightCollectView.frame = CGRectMake(ScreenWidth-rightView_W-Margin, 0, rightView_W, RightBtnWH);

    self.leftShareView.frame = CGRectMake(Margin, SelectedHeight, 100, RightBtnWH);

    self.leftTagsView.alpha = 0;
    self.leftAuthorView.alpha = 1;
    self.leftShareView.alpha = 0;


    CGFloat RightCollectView_SelectCenterY = SelectedHeight/2 + SelectedHeight/4;

    if (_frameModel.isSelected) {

        @weakify(self)
        [UIView animateWithDuration:AnimateDuration animations:^{
            @strongify(self)
            self.leftTagsView.alpha = 1;
            self.leftTagsView.centerY = SelectedHeight/2 - SelectedHeight/4;
            self.rightCollectView.centerY = RightCollectView_SelectCenterY;
            self.leftAuthorView.centerY = RightCollectView_SelectCenterY;
            self.leftAuthorView.alpha = 0;
            self.leftShareView.alpha = 1;


        }completion:^(BOOL finished) {


            [UIView animateWithDuration:AnimateDuration animations:^{
                @strongify(self)
                self.leftShareView.centerY = self.leftAuthorView.centerY;

            }];

        }];

    }else{

        self.leftAuthorView.top = authorView_Y;

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
        _leftShareView.backgroundColor = [UIColor greenColor];
    }
    return _leftShareView;
}

- (DNLeftAuthorView *)leftAuthorView
{
    if (!_leftAuthorView) {
        _leftAuthorView = [DNLeftAuthorView dnLeftAuthorView];
        _leftAuthorView.backgroundColor = [UIColor blueColor];
    }
    return _leftAuthorView;
}

- (DNRightCollectView *)rightCollectView
{
    if (!_rightCollectView) {
        _rightCollectView = [DNRightCollectView dnRightCollectView];
        _rightCollectView.backgroundColor = [UIColor orangeColor];
    }
    return _rightCollectView;
}

- (UIView *)centerLineView
{
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc]init];
        _centerLineView.backgroundColor = [UIColor redColor];
    }
    return _centerLineView;
}

@end
