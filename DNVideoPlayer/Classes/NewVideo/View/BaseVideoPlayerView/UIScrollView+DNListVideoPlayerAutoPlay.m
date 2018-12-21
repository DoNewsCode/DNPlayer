//
//  UIScrollView+DNListVideoPlayerAutoPlay.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import "UIScrollView+DNListVideoPlayerAutoPlay.h"
#import "NSObject+DNObserverHelper.h"

#import "DNIsAppearedHelper.h"
#import <objc/runtime.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UIScrollViewDelegate_ListViewAutoplayDNAdd
@protocol UIScrollViewDelegate_ListViewAutoplayDNAdd <UIScrollViewDelegate>

- (void)dn_scrollViewDidEndDragging:(__kindof UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)dn_scrollViewDidEndDecelerating:(__kindof UIScrollView *)scrollView;

@end

/// took over
static bool dn_isTookOver(Class cls);
static void dn_setIsTookOver(Class cls);
static void dn_tookOverMethod(Class cls, struct objc_method_description *des, SEL tookOverSEL, IMP tookOverIMP);
static void dn_scrollViewDidEndDragging(id<UIScrollViewDelegate_ListViewAutoplayDNAdd> delegate, SEL _cmd, __kindof UIScrollView *scrollView, bool willDecelerate);
static void dn_scrollViewDidEndDecelerating(id<UIScrollViewDelegate_ListViewAutoplayDNAdd> delegate, SEL _cmd, __kindof UIScrollView *scrollView);

/// autoplay
static void dn_scrollViewConsiderPlayNewAsset(__kindof __kindof UIScrollView *scrollView);
static void dn_tableViewConsiderPlayNextAsset(UITableView *tableView);
static void dn_collectionViewConsiderPlayNextAsset(UICollectionView *collectionView);


#pragma mark - _DNScrollViewDelegateObserver
@interface _DNScrollViewDelegateObserver: NSObject
+ (void)observeScrollView:(__kindof UIScrollView *)scrollView delegateChangeExeBlock:(void(^)(void))block;
- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView valueChangeExeBlock:(void(^)(_DNScrollViewDelegateObserver *observer))block;
@property (nonatomic, copy) void(^valueChangeExeBlock)(_DNScrollViewDelegateObserver *observer);

@end


@implementation _DNScrollViewDelegateObserver
+ (void)observeScrollView:(__kindof UIScrollView *)scrollView delegateChangeExeBlock:(void(^)(void))block {
    if ( objc_getAssociatedObject(scrollView, _cmd) != nil ) return;
    _DNScrollViewDelegateObserver *observer = [[_DNScrollViewDelegateObserver alloc] initWithScrollView:scrollView valueChangeExeBlock:^(_DNScrollViewDelegateObserver * _Nonnull observer) {
        if ( block ) block();
    }];
    objc_setAssociatedObject(scrollView, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
static NSString *delegateKey = @"delegate";
- (instancetype)initWithScrollView:(__kindof UIScrollView *)scrollView valueChangeExeBlock:(void (^)(_DNScrollViewDelegateObserver * _Nonnull))block {
    self = [super init];
    if ( !self ) return nil;
    _valueChangeExeBlock = block;
    [scrollView dn_addObserver:self forKeyPath:delegateKey context:&delegateKey];
    return self;
}
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change context:(nullable void *)context
{
    if ( context == &delegateKey ) {
        if ( change[NSKeyValueChangeOldKey] == change[NSKeyValueChangeNewKey] ) return;
        if ( _valueChangeExeBlock ) _valueChangeExeBlock(self);
    }
}

@end



@implementation UIScrollView (DNPlayerCurrentPlayingIndexPath)
- (void)setDn_currentPlayingIndexPath:(nullable NSIndexPath *)dn_currentPlayingIndexPath {
    objc_setAssociatedObject(self, @selector(dn_currentPlayingIndexPath), dn_currentPlayingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSIndexPath *)dn_currentPlayingIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)dn_needPlayNextAsset {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 查询当前显示的cell中(dn_currentPlayingIndexPath之后的), 是否存在播放器父视图
        if ( [self isKindOfClass:[UITableView class]] ) {
            dn_tableViewConsiderPlayNextAsset((id)self);
        }
        else if ( [self isKindOfClass:[UICollectionView class]] ) {
            dn_collectionViewConsiderPlayNextAsset((id)self);
        }
    });
}
@end



@implementation UIScrollView (DNListVideoPlayerAutoPlay)

- (void)setDn_enabledAutoplay:(BOOL)dn_enabledAutoplay {
    objc_setAssociatedObject(self, @selector(dn_enabledAutoplay), @(dn_enabledAutoplay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)dn_enabledAutoplay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDn_autoplayConfig:(nullable DNPlayerAutoPlayManagerConfig *)dn_autoplayConfig {
    objc_setAssociatedObject(self, @selector(dn_autoplayConfig), dn_autoplayConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable DNPlayerAutoPlayManagerConfig *)dn_autoplayConfig {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)dn_enableAutoplayWithConfig:(DNPlayerAutoPlayManagerConfig *)autoplayConfig {

    self.dn_enabledAutoplay = YES;
    self.dn_autoplayConfig = autoplayConfig;

    if ( self.delegate ) { [self _dn_tookOver]; }

    __weak typeof(self) _self = self;
    [_DNScrollViewDelegateObserver observeScrollView:self delegateChangeExeBlock:^{
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.delegate ) [self _dn_tookOver];
    }];
}

- (void)dn_disenableAutoplay {
    self.dn_enabledAutoplay = NO;
    self.dn_autoplayConfig = nil;
}

#pragma mark -
- (void)_dn_tookOver {
    if ( [self isMemberOfClass:[UIScrollView class]] ) return;
    Class delegate_cls = [self.delegate class];
    if ( dn_isTookOver(delegate_cls) ) return; dn_setIsTookOver(delegate_cls);
    Protocol *protocol = @protocol(UIScrollViewDelegate);
    struct objc_method_description des = protocol_getMethodDescription(protocol, @selector(scrollViewDidEndDragging:willDecelerate:), NO, YES);
    dn_tookOverMethod(delegate_cls, &des, @selector(dn_scrollViewDidEndDragging:willDecelerate:), (IMP)dn_scrollViewDidEndDragging);

    des = protocol_getMethodDescription(protocol, @selector(scrollViewDidEndDecelerating:), NO, YES);
    dn_tookOverMethod(delegate_cls, &des, @selector(dn_scrollViewDidEndDecelerating:), (IMP)dn_scrollViewDidEndDecelerating);
}

@end

#pragma mark - 一些声明
static const char *tookOverKey = "tookOverKey";
static bool dn_isTookOver(Class cls) {
    return [objc_getAssociatedObject(cls, tookOverKey) boolValue];
}

static void dn_setIsTookOver(Class cls) {
    objc_setAssociatedObject(cls, tookOverKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void dn_none() { /* nothing */ }

static void dn_tookOverMethod(Class cls, struct objc_method_description *des, SEL tookOverSEL, IMP tookOverIMP) {
    Method origin = class_getInstanceMethod(cls, des->name);
    if ( !origin ) { class_addMethod(cls, des->name, (IMP)dn_none, des->types); origin = class_getInstanceMethod(cls, des->name); }
    class_addMethod(cls, tookOverSEL, tookOverIMP, des->types);
    Method t = class_getInstanceMethod(cls, tookOverSEL);
    method_exchangeImplementations(origin, t);
}

static void dn_tableViewConsiderPlayNewAsset(UITableView *tableView);
static void dn_collectionViewConsiderPlayNewAsset(UICollectionView *collectionView);
static void dn_exeAnima(__kindof UIScrollView *scrollView, NSIndexPath *indexPath, DNAutoplayScrollAnimationType animationType);

static void dn_scrollViewDidEndDragging(id<UIScrollViewDelegate_ListViewAutoplayDNAdd> delegate, SEL _cmd, __kindof UIScrollView *scrollView, bool willDecelerate) {
    [delegate dn_scrollViewDidEndDragging:scrollView willDecelerate:willDecelerate];
    if ( willDecelerate ) return;
    dn_scrollViewConsiderPlayNewAsset(scrollView);
}

static void dn_scrollViewDidEndDecelerating(id<UIScrollViewDelegate_ListViewAutoplayDNAdd> delegate, SEL _cmd, __kindof UIScrollView *scrollView) {
    [delegate dn_scrollViewDidEndDecelerating:scrollView];
    dn_scrollViewConsiderPlayNewAsset(scrollView);
}

static void dn_scrollViewConsiderPlayNewAsset(__kindof __kindof UIScrollView *scrollView) {
    if ( !scrollView.dn_enabledAutoplay ) return;
    if ( ![scrollView dn_autoplayConfig].autoplayDelegate ) return;
    if ( [scrollView isKindOfClass:[UITableView class]] ) dn_tableViewConsiderPlayNewAsset(scrollView);
    else if ( [scrollView isKindOfClass:[UICollectionView class]] ) dn_collectionViewConsiderPlayNewAsset(scrollView);
}

static void dn_tableViewConsiderPlayNewAsset(UITableView *tableView) {
    NSArray<UITableViewCell *> *visibleCells = tableView.visibleCells;
    if ( visibleCells.count == 0 ) return;

    DNPlayerAutoPlayManagerConfig *config = [tableView dn_autoplayConfig];

    NSIndexPath *currentPlayingIndexPath = tableView.dn_currentPlayingIndexPath;
    if ( currentPlayingIndexPath &&
        dn_isAppeared1(config.playerSuperviewTag, currentPlayingIndexPath, tableView) ) return;

    CGFloat midLine = 0;
    if (@available(iOS 11.0, *)) {
        midLine = floor((CGRectGetHeight(tableView.frame) - tableView.adjustedContentInset.top) * 0.5);
    } else {
        midLine = floor((CGRectGetHeight(tableView.frame) - tableView.contentInset.top) * 0.5);
    }

    NSInteger count = visibleCells.count;
    NSInteger half = (NSInteger)(count * 0.5);
    NSArray<UITableViewCell *> *half_l = [visibleCells subarrayWithRange:NSMakeRange(0, half)];
    NSArray<UITableViewCell *> *half_r = [visibleCells subarrayWithRange:NSMakeRange(half, count - half)];

    __block UITableViewCell *cell_l = nil;
    __block UIView *half_l_view = nil;
    [half_l enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *superview = [obj viewWithTag:config.playerSuperviewTag];
        if ( !superview ) return;
        *stop = YES;
        cell_l = obj;
        half_l_view = superview;
    }];

    __block UITableViewCell *cell_r = nil;
    __block UIView *half_r_view = nil;
    [half_r enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *superview = [obj viewWithTag:config.playerSuperviewTag];
        if ( !superview ) return;
        *stop = YES;
        cell_r = obj;
        half_r_view = superview;
    }];

    if ( !half_l_view && !half_r_view ) return;

    NSIndexPath *nextIndexPath = nil;
    if ( half_l_view && !half_r_view ) {
        nextIndexPath = [tableView indexPathForCell:cell_l];
    }
    else if ( half_r_view && !half_l_view ) {
        nextIndexPath = [tableView indexPathForCell:cell_r];
    }
    else {
        CGRect half_l_rect = [half_l_view.superview convertRect:half_l_view.frame toView:tableView.superview];
        CGRect half_r_rect = [half_r_view.superview convertRect:half_r_view.frame toView:tableView.superview];

        if (ABS(CGRectGetMaxY(half_l_rect) - midLine) < ABS(CGRectGetMinY(half_r_rect) - midLine) ) {
            nextIndexPath = [tableView indexPathForCell:cell_l];
        }
        else {
            nextIndexPath = [tableView indexPathForCell:cell_r];
        }
    }
    [config.autoplayDelegate dn_playerNeedPlayNewAssetAtIndexPath:nextIndexPath];
}

static void dn_collectionViewConsiderPlayNewAsset(UICollectionView *collectionView) {
    NSArray<UICollectionViewCell *> *visibleCells = [collectionView.visibleCells sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[collectionView indexPathForCell:obj1] compare:[collectionView indexPathForCell:obj2]];
    }];
    if ( visibleCells.count == 0 ) return;

    DNPlayerAutoPlayManagerConfig *config = [collectionView dn_autoplayConfig];

    NSIndexPath *currentPlayingIndexPath = collectionView.dn_currentPlayingIndexPath;
    if (currentPlayingIndexPath &&
        dn_isAppeared1(config.playerSuperviewTag, currentPlayingIndexPath, collectionView) ) return;

    CGFloat midLine = 0;
    if (@available(iOS 11.0, *)) {
        midLine = floor((CGRectGetHeight(collectionView.frame) - collectionView.adjustedContentInset.top) * 0.5);
    } else {
        midLine = floor((CGRectGetHeight(collectionView.frame) - collectionView.contentInset.top) * 0.5);
    }

    NSInteger count = visibleCells.count;
    NSInteger half = (NSInteger)(count * 0.5);
    NSArray<UICollectionViewCell *> *half_l = [visibleCells subarrayWithRange:NSMakeRange(0, half)];
    NSArray<UICollectionViewCell *> *half_r = [visibleCells subarrayWithRange:NSMakeRange(half, count - half)];

    __block UICollectionViewCell *cell_l = nil;
    __block UIView *half_l_view = nil;
    [half_l enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *superview = [obj viewWithTag:config.playerSuperviewTag];
        if ( !superview ) return;
        *stop = YES;
        cell_l = obj;
        half_l_view = superview;
    }];

    __block UICollectionViewCell *cell_r = nil;
    __block UIView *half_r_view = nil;
    [half_r enumerateObjectsUsingBlock:^(UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *superview = [obj viewWithTag:config.playerSuperviewTag];
        if ( !superview ) return;
        *stop = YES;
        cell_r = obj;
        half_r_view = superview;
    }];

    if ( !half_l_view && !half_r_view ) return;

    NSIndexPath *nextIndexPath = nil;
    if ( half_l_view && !half_r_view ) {
        nextIndexPath = [collectionView indexPathForCell:cell_l];
    }
    else if ( half_r_view && !half_l_view ) {
        nextIndexPath = [collectionView indexPathForCell:cell_r];
    }
    else {
        CGRect half_l_rect = [half_l_view.superview convertRect:half_l_view.frame toView:collectionView.superview];
        CGRect half_r_rect = [half_r_view.superview convertRect:half_r_view.frame toView:collectionView.superview];

        if ( ABS(CGRectGetMaxY(half_l_rect) - midLine) < ABS(CGRectGetMinY(half_r_rect) - midLine) ) {
            nextIndexPath = [collectionView indexPathForCell:cell_l];
        }
        else {
            nextIndexPath = [collectionView indexPathForCell:cell_r];
        }
    }

    [config.autoplayDelegate dn_playerNeedPlayNewAssetAtIndexPath:nextIndexPath];
}

/// 执行动画
static void dn_exeAnima(__kindof UIScrollView *scrollView, NSIndexPath *indexPath, DNAutoplayScrollAnimationType animationType) {
    switch ( animationType ) {
        case DNAutoplayScrollAnimationTypeNone: break;
        case DNAutoplayScrollAnimationTypeTop: {
            @try{
                if ([scrollView isKindOfClass:[UITableView class]] ) {
                    [UIView animateWithDuration:0.6 animations:^{
                        [(UITableView *)scrollView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    }];
                }
                else if ( [scrollView isKindOfClass:[UICollectionView class]] ) {
                    [(UICollectionView *)scrollView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                }
            }@catch(NSException *__unused ex) {}
        }
            break;
        case DNAutoplayScrollAnimationTypeMiddle: {
            @try{
                if ( [scrollView isKindOfClass:[UITableView class]] ) {
                    [UIView animateWithDuration:0.6 animations:^{
                        [(UITableView *)scrollView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }];
                }
                else if ( [scrollView isKindOfClass:[UICollectionView class]] ) {
                    [(UICollectionView *)scrollView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
                }
            }@catch(NSException *__unused ex) {}
        }
            break;
    }
}

static void dn_tableViewConsiderPlayNextAsset(UITableView *tableView) {
    NSArray<NSIndexPath *> *visibleIndexPaths = tableView.indexPathsForVisibleRows;
    if ( visibleIndexPaths.count == 0 ) return;
    if ( [visibleIndexPaths.lastObject compare:tableView.dn_currentPlayingIndexPath] == NSOrderedSame ) return;
    NSInteger cut = tableView.dn_currentPlayingIndexPath ? [visibleIndexPaths indexOfObject:tableView.dn_currentPlayingIndexPath] + 1  : 0;
    NSArray<NSIndexPath *> *subIndexPaths = [visibleIndexPaths subarrayWithRange:NSMakeRange(cut, visibleIndexPaths.count - cut)];
    if ( subIndexPaths.count == 0 ) return;
    __block NSIndexPath *nextIndexPath = nil;
    NSInteger superviewTag = [tableView dn_autoplayConfig].playerSuperviewTag;
    [subIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *superview = [[tableView cellForRowAtIndexPath:obj] viewWithTag:superviewTag];
        if ( !superview ) return;
        *stop = YES;
        nextIndexPath = obj;
    }];
    if ( !nextIndexPath ) return;

    [[tableView dn_autoplayConfig].autoplayDelegate dn_playerNeedPlayNewAssetAtIndexPath:nextIndexPath];
    dn_exeAnima(tableView, nextIndexPath, [tableView dn_autoplayConfig].animationType);
}

static void dn_collectionViewConsiderPlayNextAsset(UICollectionView *collectionView) {
    NSArray<NSIndexPath *> *visibleIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    if ( visibleIndexPaths.count == 0 ) return;
    if ( [visibleIndexPaths.lastObject compare:collectionView.dn_currentPlayingIndexPath] == NSOrderedSame ) return;
    NSInteger cut = collectionView.dn_currentPlayingIndexPath ? [visibleIndexPaths indexOfObject:collectionView.dn_currentPlayingIndexPath] + 1 : 0;
    NSArray<NSIndexPath *> *subIndexPaths = [visibleIndexPaths subarrayWithRange:NSMakeRange(cut, visibleIndexPaths.count - cut)];
    if ( subIndexPaths.count == 0 ) return;
    __block NSIndexPath *nextIndexPath = nil;
    NSInteger superviewTag = [collectionView dn_autoplayConfig].playerSuperviewTag;
    [subIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *superview = [[collectionView cellForItemAtIndexPath:obj] viewWithTag:superviewTag];
        if ( !superview ) return;
        *stop = YES;
        nextIndexPath = obj;
    }];
    if ( !nextIndexPath ) return;

    [[collectionView dn_autoplayConfig].autoplayDelegate dn_playerNeedPlayNewAssetAtIndexPath:nextIndexPath];
    dn_exeAnima(collectionView, nextIndexPath, [collectionView dn_autoplayConfig].animationType);
}



NS_ASSUME_NONNULL_END
