//
//  DNIsAppearedHelper.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import "DNIsAppearedHelper.h"

NS_ASSUME_NONNULL_BEGIN

__kindof UIView *dn_getTarget(UIScrollView *scrollView, NSIndexPath *viewAtIndexPath, NSInteger viewTag) {
    UIView *target = nil;
    if ( [scrollView isKindOfClass:[UITableView class]] ) {
        UITableViewCell *cell = [(UITableView *)scrollView cellForRowAtIndexPath:viewAtIndexPath];
        target = [cell viewWithTag:viewTag];
    }
    else if ( [scrollView isKindOfClass:[UICollectionView class]] ) {
        UICollectionViewCell *cell = [(UICollectionView *)scrollView cellForItemAtIndexPath:viewAtIndexPath];
        target = [cell viewWithTag:viewTag];
    }
    return target;
}

bool dn_isAppeared1(NSInteger viewTag, NSIndexPath *viewAtIndexPath, UIScrollView *scrollView) {
    return dn_isAppeared2(dn_getTarget(scrollView, viewAtIndexPath, viewTag), scrollView);
}

extern bool dn_isAppeared2(UIView *_Nullable childView, UIScrollView *_Nullable scrollView) {
    if ( !childView ) return false;
    if ( !scrollView ) return false;
    if ( !scrollView.window ) return false;
    CGRect rect = [childView.superview convertRect:childView.frame toView:scrollView];
    CGRect rect_max = (CGRect){scrollView.contentOffset, scrollView.frame.size};
    CGRect inset = CGRectIntersection(rect, rect_max);
    if ( CGRectIsEmpty(inset) ) return false;
    return !CGRectIsNull(inset);
}
NS_ASSUME_NONNULL_END
