//
//  DNBottomWebMainView.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/11.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import "DNBottomWebMainView.h"
#import "DNVideoPlayerView.h"
#import "DNCustonNavView.h"


@interface DNBottomWebMainView ()<DNVideoPlayerViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>

@property (strong, nonatomic) DNCustonNavView *navigationView;
@property (nonatomic, strong) DNVideoPlayerView *videoPlayer;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation DNBottomWebMainView

- (void)dealloc
{
    NSLog(@"%@释放了",[self class]);
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.videoPlayer restPlayer];//清空播放器

}

+ (instancetype)bottomWebMainViewWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews
{
    [self configPlayerView];

    [self configBottomView];

    [self configCustomNav];

    [self insertSubview:self.videoPlayer.containerView belowSubview:self.navigationView];


}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (point.y <= VideoMaxHeight && self.scrollView.contentOffset.y <= VideoMaxHeight) {
//
//        if (self.videoPlayer.player.isPlaying) {
////            NSLog(@"self.videoPlayer.containerView*******hitTest");
//            return [self.videoPlayer.containerView hitTest:point withEvent:event];
//        }else{
////            NSLog(@"self.scrollView1111111*******hitTest");
//            return [self.scrollView hitTest:point withEvent:event];
//        }
//
//
//        //self.videoPlayer.containerView;
//    }else{
//        NSLog(@"self.scrollView222222222*******hitTest");
//        return [self.scrollView hitTest:point withEvent:event];
//
//        //self.scrollView;
//
//    }
//}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat offSetY = roundf(self.webView.scrollView.contentOffset.y);
        NSLog(@"self.webView.scrollView====%f",offSetY);
        if (offSetY < 0 ) {
            self.scrollView.scrollEnabled = YES;
            self.webView.scrollView.scrollEnabled = NO;
        }
    }
}

- (void)configPlayerView
{
    ///初始化播放器
    self.videoPlayer = [DNVideoPlayerView dnVideoPlayerViewWithDelegate:self];
    ///添加播放器容器视图
    [self addSubview:self.videoPlayer.containerView];
    [self.videoPlayer.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(STATUSBAR_H);
        make.leading.trailing.offset(0);
        make.height.equalTo(self.videoPlayer.containerView.mas_width).multipliedBy(9 / 16.0f);
    }];


    DNPlayModel *playModel = [[DNPlayModel alloc]init];
    playModel.videourl = [NSString stringWithFormat:@"http:\/\/tb-video.bdstatic.com\/videocp\/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4"];

    [self.videoPlayer playVideoWithPlayModel:playModel completeBlock:nil];

}

// scrollViewWillEndDragging，这个方法内判断一下，contentOffset.y 值，如果超过多少值，那么自动回调一个 block，可实现下拉刷新
//松手时触发
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offSet = roundf(scrollView.contentOffset.y);
    if ( offSet >= ScrollMaxOffSet/2) {
        //直接滚动上去
        [scrollView setContentOffset:CGPointMake(0, ScrollMaxOffSet) animated:YES];
        self.videoPlayer.rotationManager.disableAutorotation = YES;
    }else{
        //直接滚下去
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.videoPlayer.rotationManager.disableAutorotation = NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSet = roundf(scrollView.contentOffset.y);
    NSLog(@"%f",self.webView.top);
    NSLog(@"scrollView.contentOffset.y===%f",offSet);
    CGFloat alpha = offSet / ScrollMaxOffSet;
// ****************** 暂时这么处理 ****************** //
    if (offSet > 0) {
        [self insertSubview:self.videoPlayer.containerView belowSubview:self.scrollView];
    }
    if (offSet == 0) {
        [self insertSubview:self.videoPlayer.containerView belowSubview:self.navigationView];
    }
// ****************** 暂时这么处理 ****************** //

//    NSLog(@"alpha==%f",alpha);
    [self.navigationView setAlpha:alpha];
    if (offSet >= ScrollMaxOffSet) {
        [scrollView setContentOffset:CGPointMake(0, ScrollMaxOffSet)];
        self.scrollView.scrollEnabled = NO;
        self.webView.scrollView.scrollEnabled = YES;
    }

    if (offSet >= ScrollMaxOffSet/2) {
        //滑动大于一半暂停播放器
        [self.videoPlayer playerPause];
        //状态栏改变为黑色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        //状态栏改为白色
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        if (!self.videoPlayer.player.isPlaying) {
            [self.videoPlayer playerPlay];
        }
    }


}

- (void)configBottomView
{
    UIScrollView *view = [[UIScrollView alloc]init];
    view.frame = self.bounds;
    view.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+VideoMaxHeight);
    view.backgroundColor = [UIColor clearColor];
    view.delegate = self;
    [self addSubview:view];
    self.scrollView = view;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.scrollView addSubview:self.webView];
    self.webView.frame = CGRectMake(0, VideoMaxHeight, ScreenWidth, ScreenHeight);
    [self.webView loadRequest:request];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.scrollEnabled = NO;

}

- (void)configCustomNav
{
    //自定义顶导航
    DNCustonNavView *nav = [[DNCustonNavView alloc] init];
    [nav setFrame:CGRectMake(0, 0, ScreenWidth, STATUSBAR_H)];
    [self addSubview:nav];
    self.navigationView = nav;
    [self.navigationView setAlpha:0];
}


- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
    }
    return _webView;
}

@end
