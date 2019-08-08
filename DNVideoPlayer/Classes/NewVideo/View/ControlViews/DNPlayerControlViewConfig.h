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
/// 是否动画显示播放器(初始化播放器后 1.添加容器视图到主视图上.2.设置容器视图frame)
@property (nonatomic, assign) BOOL isAnimateShowContainerView;
/// 是否展示播放器原始控制层(默认展示)
@property (nonatomic, assign) BOOL isShowControlView;

#pragma mark 底部进度视图相关设置
/// 是否显示播放器底部进度视图
@property (nonatomic, assign) BOOL isShowBottomProgressView;
/// 自定义高度
@property (nonatomic, assign) CGFloat bottomProgressView_H;
/// 自定义进度播放颜色
@property (nonatomic, strong) UIColor *bottomProgressTintColor;
/// 自定义进度缓冲颜色
@property (nonatomic, strong) UIColor *bottomLoadingTintColor;



/// 是否显示系统的缓冲转圈视图 (默认展示.若需要自定义加载视图需要设置为NO并设置CustomLoadingView)
@property (nonatomic, assign) BOOL isShowSystemActivityLoadingView;
/// 自定义加载视图
@property (nonatomic, strong) UIImageView *customLoadingView;


@end

NS_ASSUME_NONNULL_END
