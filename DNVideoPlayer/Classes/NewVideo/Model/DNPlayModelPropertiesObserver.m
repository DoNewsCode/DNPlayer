//
//  DNPlayModelPropertiesObserver.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/17.
//

#import "DNPlayModelPropertiesObserver.h"
#import "DNIsAppearedHelper.h"
#import "NSObject+DNObserverHelper.h"
#import <objc/message.h>

@interface DNPlayModelPropertiesObserver()
@property (nonatomic, strong, readonly) id <DNPlayModel> playModel;
@property (nonatomic) CGPoint beforeOffset;
@property (nonatomic) BOOL isAppeared;
@end

@implementation DNPlayModelPropertiesObserver

- (instancetype)initWithPlayModel:(__kindof DNPlayModel *)playModel {
    NSParameterAssert(playModel);
    self = [super init];
    if ( !self ) return nil;
    _playModel = playModel;
    if ( [playModel isMemberOfClass:[DNPlayModel class]] ) {
        _isAppeared = YES;
    }
    else {
        [self _observeProperties];
    }
    return self;
}

- (void)_observeProperties {
    if ( [_playModel isKindOfClass:[DNUITableViewCellPlayModel class]] ) {
        DNUITableViewCellPlayModel *playModel = _playModel;
        _isAppeared = [self _isAppearedInTheScrollingView:playModel.tableView];
        [self _observeScrollView:playModel.tableView];
        _beforeOffset = playModel.tableView.contentOffset;
    }
}

static NSString *kContentOffset = @"contentOffset";
static NSString *kState = @"state";
- (void)_observeScrollView:(UIScrollView *)scrollView {
    if ( !scrollView ) return;
    if ( ![scrollView isKindOfClass:[UIScrollView class]] ) return;
    [scrollView dn_addObserver:self forKeyPath:kContentOffset context:&kContentOffset];
    [scrollView.panGestureRecognizer dn_addObserver:self forKeyPath:kState context:&kState];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(nullable void *)context {
    if ( &kContentOffset == context ) {
        [self _scrollViewDidScroll:object];
    }
    else if ( &kState == context ) {
        [self _panGestureStateDidChange:object];
    }
}

- (void)_panGestureStateDidChange:(UIPanGestureRecognizer *)pan {
    if ( !pan ) return;
    UIGestureRecognizerState state = pan.state;
    BOOL isTableView = NO;
    BOOL isCollectionView = NO;
    switch ( state ) {
        case UIGestureRecognizerStateChanged: return;
        case UIGestureRecognizerStatePossible: return;
        case UIGestureRecognizerStateBegan: {
            if ( [pan.view isKindOfClass:[UITableView class]] )
            {
                _isTouchedTablView = YES;
                isTableView = YES;
            }
            else if ( [pan.view isKindOfClass:[UICollectionView class]] ) {
                _isTouchedCollectionView = YES;
                isCollectionView = YES;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            if ( [pan.view isKindOfClass:[UITableView class]] ) {
                _isTouchedTablView = NO;
                isTableView = YES;
            }
            else if ( [pan.view isKindOfClass:[UICollectionView class]] ) {
                _isTouchedCollectionView = NO;
                isCollectionView = YES;
            }
        }
            break;
    }

    if ( isTableView ) {
        if ( [self.delegate respondsToSelector:@selector(observer:userTouchedTableView:)] ) {
            [self.delegate observer:self userTouchedTableView:_isTouchedTablView];
        }
    }
    else if ( isCollectionView ) {
        if ( [self.delegate respondsToSelector:@selector(observer:userTouchedCollectionView:)] ) {
            [self.delegate observer:self userTouchedCollectionView:_isTouchedCollectionView];
        }
    }
}

- (BOOL)_isAppearedInTheScrollingView:(UIScrollView *)scrollView {
    return dn_isAppeared2(_playModel.playerSuperview, scrollView);
}

- (void)_scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( !scrollView ) return;
    if ( CGPointEqualToPoint(_beforeOffset, scrollView.contentOffset) ) return;
    self.isAppeared = [self _isAppearedInTheScrollingView:scrollView];
    _beforeOffset = scrollView.contentOffset;
}

- (void)setIsAppeared:(BOOL)isAppeared {
    if ( isAppeared == _isAppeared )
    {
        return;
    }
    _isAppeared = isAppeared;
    if ( isAppeared ) {
        if ( [self.delegate respondsToSelector:@selector(playerWillAppearForObserver:superview:)] ) {
            [self.delegate playerWillAppearForObserver:self superview:_playModel.playerSuperview];
        }
    }
    else {
        if ( [self.delegate respondsToSelector:@selector(playerWillDisappearForObserver:)] ) {
            [self.delegate playerWillDisappearForObserver:self];
        }
    }
}

- (BOOL)isPlayInTableView {
    return _playModel.isPlayInTableView;
}

- (BOOL)isPlayInCollectionView {
    return _playModel.isPlayInCollectionView;
}

@end
