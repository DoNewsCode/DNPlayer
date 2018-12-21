//
//  DNPlayerControlViewConfig.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/21.
//

#import <Foundation/Foundation.h>
#import "DNPlayerTypeDef.h"
/// 播放器控制层类型 点播 直播
typedef NS_ENUM(int, PlayerControlViewType) {
    PlayerControlViewType_Vod = 0,  /// 点播
    PlayerControlViewType_Live      /// 直播
};

NS_ASSUME_NONNULL_BEGIN

@interface DNPlayerControlViewConfig : NSObject

@property (nonatomic, assign) PlayerControlViewType controlViewType;
/// 是否展示返回按钮
@property (nonatomic, assign) BOOL isShowBackBtn;

@end

NS_ASSUME_NONNULL_END
