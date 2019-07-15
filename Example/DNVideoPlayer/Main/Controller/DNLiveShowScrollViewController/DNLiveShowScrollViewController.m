//
//  DNLiveShowScrollViewController.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2019/1/7.
//  Copyright © 2019 563620078@qq.com. All rights reserved.
//

#import "DNLiveShowScrollViewController.h"
#import "DNVideoDetailViewController.h"
#import "DNPlaceControlView.h"
#import "DNListVideoDetailTableViewCell.h"
#import "DNListVideoDetailCellFrameModel.h"
#import <DNVideoPlayer/DNVideoPlayerView.h>
@interface DNLiveShowScrollViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *videoFrameModels;
@property (nonatomic, strong) UITableView *scrollTableView;
// 创建三个控制视图，用于滑动切换
//@property (nonatomic, strong) DNPlaceControlView *topView;   // 顶部视图
//@property (nonatomic, strong) DNPlaceControlView *ctrView;   // 中间视图
//@property (nonatomic, strong) DNPlaceControlView *btmView;   // 底部视图
// 当前播放内容的索引
@property (nonatomic, assign) NSInteger currentVideoIndex;

@end

@implementation DNLiveShowScrollViewController

- (void)dealloc
{
    NSLog(@"%@释放了",[self class]);
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.scrollTableView];
    self.scrollTableView.frame = self.view.bounds;

//    [self.view addSubview:self.scrollView];
//    self.scrollView.frame = self.view.bounds;

//    CGFloat controlW = CGRectGetWidth(self.scrollView.frame);
//    CGFloat controlH = CGRectGetHeight(self.scrollView.frame);
//
//    self.topView.frame   = CGRectMake(0, 0, controlW, controlH);
//    self.ctrView.frame   = CGRectMake(0, controlH, controlW, controlH);
//    self.btmView.frame   = CGRectMake(0, 2 * controlH, controlW, controlH);


//    [self setModels:arr index:0];


}

- (UITableView *)scrollTableView
{
    if (!_scrollTableView) {
        _scrollTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];

        _scrollTableView.estimatedRowHeight = 0;
        _scrollTableView.estimatedSectionHeaderHeight = 0;
        _scrollTableView.estimatedSectionFooterHeight = 0;

        [_scrollTableView setPagingEnabled:YES];
        [_scrollTableView setAlwaysBounceVertical:YES];
        [_scrollTableView setDelaysContentTouches:NO];

        _scrollTableView.backgroundColor = [UIColor blackColor];
        _scrollTableView.delegate = self;
        _scrollTableView.dataSource = self;

        [_scrollTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DNVideoListTableViewItemCell"];

    }
    return _scrollTableView;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---------willDisplayCell");
    DNVideoDetailViewController *detailVc = [[DNVideoDetailViewController alloc]init];
//    [cell.contentView addSubview:detailVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = self.scrollTableView.contentOffset.y;
    NSInteger currentPage = floor(0.5 + offset/ScreenHeight);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
    UITableViewCell *currentCell = [self.scrollTableView cellForRowAtIndexPath:indexPath];

    if (currentPage != _currentVideoIndex) {
        DNVideoDetailViewController *detailVc = [[DNVideoDetailViewController alloc]init];
//        [self zz_pushViewController:detailVc animated:NO];
        [currentCell.contentView insertSubview:detailVc.view atIndex:0];
        [self setCurrentVideoIndex:currentPage];
//        [self myTaskShortVideoCount];
    }
}


//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"---------didEndDisplayingCell---------");
//    DNVideoDetailViewController *detailVc = [[DNVideoDetailViewController alloc]init];
//    [cell.contentView addSubview:detailVc.view];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoFrameModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    DNListVideoDetailCellFrameModel *frameModel= self.videoFrameModels[indexPath.row];

//    DNListVideoDetailTableViewCell *cell = [DNListVideoDetailTableViewCell cellWithTableView:tableView indexPath:indexPath];
//    cell.backgroundColor = MRandomColor;
//
//    [cell setLayout:frameModel];

    NSString *DNListVideoDetailTableViewCellID = [NSString stringWithFormat:@"DNListVideoDetailTableViewCellID-%ld-%ld",indexPath.section,indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DNListVideoDetailTableViewCellID];
    if ( !cell ) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DNListVideoDetailTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    cell.backgroundColor = MRandomColor;

    return cell;

}

//
//- (void)setModels:(NSArray *)models index:(NSInteger)index
//{
//    [self.videos removeAllObjects];
//    [self.videos addObjectsFromArray:models];
//
////    self.index = index;
//    self.currentPlayIndex = index;
//
//    if (models.count == 0) return;
//
//    if (models.count == 1) {
//
//        [self.ctrView removeFromSuperview];
//        [self.btmView removeFromSuperview];
//
//        self.scrollView.contentSize = CGSizeMake(0, ScreenWidth);
//
////        self.topView.model = self.videos.firstObject;
//
////        [self playVideoFrom:self.topView];
//    }else if (models.count == 2) {
//        [self.btmView removeFromSuperview];
//
//        self.scrollView.contentSize = CGSizeMake(0, ScreenHeight * 2);
//
////        self.topView.model = self.videos.firstObject;
////        self.ctrView.model = self.videos.lastObject;
//
//        if (index == 1) {
//
//            self.scrollView.contentOffset = CGPointMake(0, ScreenHeight);
////            [self playVideoFrom:self.ctrView];
//
//        }else {
//
////            [self playVideoFrom:self.topView];
//
//        }
//
//    }else {
//        if (index == 0) {
//
//            // 如果是第一个，则显示上视图，且预加载中下视图
////            self.topView.model = self.videos[index];
////            self.ctrView.model = self.videos[index + 1];
////            self.btmView.model = self.videos[index + 2];
//            // 播放第一个
////            [self playVideoFrom:self.topView];
//            [self.topView pushLiveShowWithliveId];
//
//        }else if (index == models.count - 1) {
//            // 如果是最后一个，则显示最后视图，且预加载前两个
//
////            self.btmView.model = self.videos[index];
////            self.ctrView.model = self.videos[index - 1];
////            self.topView.model = self.videos[index - 2];
//
//            // 显示最后一个
//            self.scrollView.contentOffset = CGPointMake(0, ScreenHeight * 2);
//            // 播放最后一个
////            [self playVideoFrom:self.btmView];
//            [self.btmView pushLiveShowWithliveId];
//
//        }else { // 显示中间，播放中间，预加载上下
//
////            self.ctrView.model = self.videos[index];
////            self.topView.model = self.videos[index - 1];
////            self.btmView.model = self.videos[index + 1];
//
//            // 显示中间
//            self.scrollView.contentOffset = CGPointMake(0, ScreenHeight);
//
//            // 播放中间
////            [self playVideoFrom:self.ctrView];
//        }
//    }
//}
//
//
//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        _scrollView = [UIScrollView new];
//        _scrollView.pagingEnabled = YES;
//        _scrollView.backgroundColor = [UIColor redColor];
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.delegate = self;
//
//        [_scrollView addSubview:self.topView];
//        [_scrollView addSubview:self.ctrView];
//        [_scrollView addSubview:self.btmView];
//        _scrollView.contentSize = CGSizeMake(0,  ScreenHeight * 3);
//
//        if (@available(iOS 11.0, *)) {
//            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    return _scrollView;
//}
//
//- (DNPlaceControlView *)topView {
//    if (!_topView) {
//        _topView = [DNPlaceControlView new];
//        _topView.backgroundColor = [UIColor blueColor];
//    }
//    return _topView;
//}
//
//- (DNPlaceControlView *)ctrView {
//    if (!_ctrView) {
//        _ctrView = [DNPlaceControlView new];
//        _ctrView.backgroundColor = [UIColor orangeColor];
//    }
//    return _ctrView;
//}
//
//- (DNPlaceControlView *)btmView {
//    if (!_btmView) {
//        _btmView = [DNPlaceControlView new];
//        _btmView.backgroundColor = [UIColor purpleColor];
//    }
//    return _btmView;
//}
//
- (NSArray<DNListVideoDetailCellFrameModel *> *)videoFrameModels
{
    if (!_videoFrameModels) {
        NSMutableArray *marr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 20; i ++) {
            DNListVideoDetailCellFrameModel *frameModel = [[DNListVideoDetailCellFrameModel alloc]initWithModel:nil];
            [marr addObject:frameModel];
        }
        _videoFrameModels = marr.copy;
    }
    return _videoFrameModels;
}

- (BOOL)fd_prefersNavigationBarHidden
{
    return YES;
}


- (BOOL)shouldAutorotate
{
    return NO;
}


@end
