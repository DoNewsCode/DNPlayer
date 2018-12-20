//
//  DNVideoPlaceHolderView.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/20.
//

#import "DNVideoBaseView.h"

typedef void(^PlaceHolderPublicBlock)(id sender);

NS_ASSUME_NONNULL_BEGIN


@interface DNVideoPlaceHolderView : DNVideoBaseView

+ (instancetype)dnVideoPlaceHolderViewWithFrame:(CGRect)frame;

@property (nonatomic, copy) PlaceHolderPublicBlock placeHolderPlayBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
