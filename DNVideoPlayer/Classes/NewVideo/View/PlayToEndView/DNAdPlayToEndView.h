//
//  DNAdPlayToEndView.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/11.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import "DNVideoBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EndViewPublicClickBlock)(id sender);

@interface DNAdPlayToEndView : DNVideoBaseView

@property (nonatomic, copy) EndViewPublicClickBlock detailBtnClickBlock;
@property (nonatomic, copy) EndViewPublicClickBlock replayBtnClickBlock;

+ (instancetype)dnAdPlayToEndView;

@end

NS_ASSUME_NONNULL_END
