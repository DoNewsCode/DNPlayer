//
//  DNVideoListItemFrameModel.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/24.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoItemBaseFrameModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface DNVideoListItemFrameModel : DNVideoItemBaseFrameModel

@property (nonatomic, assign) BOOL isSelected; // cell预缓存的行高
@property (nonatomic, assign) CGFloat cellItemHeight;
@end

NS_ASSUME_NONNULL_END
