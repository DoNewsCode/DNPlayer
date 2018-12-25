//
//  DNVideoItemBaseFrameModel.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/24.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNVideoFrameModelProtocol.h"
#import "DNVideoListItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNVideoItemBaseFrameModel : NSObject <DNVideoFrameModelProtocol>

@property (nonatomic, strong) DNVideoListItemModel *model;
@property (nonatomic, assign) BOOL hasBottomLine; // 是否有底线

@end

NS_ASSUME_NONNULL_END
