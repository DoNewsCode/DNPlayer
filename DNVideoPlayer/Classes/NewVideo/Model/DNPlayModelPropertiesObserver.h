//
//  DNPlayModelPropertiesObserver.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/17.
//

#import <UIKit/UIKit.h>
#import "DNPlayModel.h"

NS_ASSUME_NONNULL_BEGIN
@class DNPlayModelPropertiesObserver;

@protocol DNPlayModelPropertiesObserverDelegate <NSObject>
@optional
- (void)observer:(DNPlayModelPropertiesObserver *)observer userTouchedTableView:(BOOL)touched;
- (void)observer:(DNPlayModelPropertiesObserver *)observer userTouchedCollectionView:(BOOL)touched;
- (void)playerWillAppearForObserver:(DNPlayModelPropertiesObserver *)observer superview:(UIView *)superview;
- (void)playerWillDisappearForObserver:(DNPlayModelPropertiesObserver *)observer;
@end

@interface DNPlayModelPropertiesObserver : NSObject

- (instancetype)initWithPlayModel:(__kindof DNPlayModel *)playModel;

@property (nonatomic, weak, nullable) id <DNPlayModelPropertiesObserverDelegate> delegate;


@property (nonatomic, readonly) BOOL isAppeared;
@property (nonatomic, readonly) BOOL isTouchedTablView;
@property (nonatomic, readonly) BOOL isTouchedCollectionView;
@property (nonatomic, readonly) BOOL isPlayInTableView;
@property (nonatomic, readonly) BOOL isPlayInCollectionView;

@end

NS_ASSUME_NONNULL_END
