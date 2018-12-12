//
//  DNPlayerRotationManagerProtocol.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/5.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DNPlayerRotationManagerProtocol;

/**
 视图方向
 - Orientation_Portrait:       竖屏
 - Orientation_LandscapeLeft:  全屏, Home键在右侧
 - Orientation_LandscapeRight: 全屏, Home键在左侧
 */
typedef NS_ENUM(NSUInteger, DNOrientation) {
    DNOrientation_Portrait,
    DNOrientation_LandscapeLeft,  // UIDeviceOrientationLandscapeLeft
    DNOrientation_LandscapeRight, // UIDeviceOrientationLandscapeRight
};

/**
 自动旋转支持的方向
 - DNAutoRotateSupportedOrientation_Portrait:       竖屏
 - DNAutoRotateSupportedOrientation_LandscapeLeft:  支持全屏, Home键在右侧
 - DNAutoRotateSupportedOrientation_LandscapeRight: 支持全屏, Home键在左侧
 - DNAutoRotateSupportedOrientation_All:            全部方向
 */
typedef NS_ENUM(NSUInteger, DNAutoRotateSupportedOrientation) {
    DNAutoRotateSupportedOrientation_Portrait = 1 << 0,
    DNAutoRotateSupportedOrientation_LandscapeLeft = 1 << 1,  // UIDeviceOrientationLandscapeLeft
    DNAutoRotateSupportedOrientation_LandscapeRight = 1 << 2, // UIDeviceOrientationLandscapeRight
    DNAutoRotateSupportedOrientation_All = DNAutoRotateSupportedOrientation_Portrait | DNAutoRotateSupportedOrientation_LandscapeLeft | DNAutoRotateSupportedOrientation_LandscapeRight,
};


NS_ASSUME_NONNULL_BEGIN

@protocol DNPlayerRotationManagerDelegate<NSObject>

/// 将要旋转
- (void)rotationManager:(id<DNPlayerRotationManagerProtocol>)manager willRotateView:(BOOL)isFullscreen;
/// 完成旋转
- (void)rotationManager:(id<DNPlayerRotationManagerProtocol>)manager didRotateView:(BOOL)isFullscreen;

@end


@protocol DNPlayerRotationManagerProtocol <NSObject>


@property (nonatomic, weak, nullable) id<DNPlayerRotationManagerDelegate> delegate;

/// 是否禁止自动旋转
/// - 该属性只会禁止自动旋转, 当调用 rotate 等方法还是可以旋转的
/// - 默认为 false
@property (nonatomic) BOOL disableAutorotation;

/// 自动旋转时, 所支持的方法
/// - 默认为 .all
@property (nonatomic) DNAutoRotateSupportedOrientation autorotationSupportedOrientation;

/// 动画持续的时间
/// - 默认是 0.4
@property (nonatomic) NSTimeInterval duration;

/// 当前的方向
@property (nonatomic, readonly) DNOrientation currentOrientation;

/// 是否全屏
/// - landscapeRight 或者 landscapeLeft 即为全屏
@property (nonatomic, readonly) BOOL isFullscreen;

/// 是否正在旋转
@property (nonatomic, readonly) BOOL transitioning;

/// 旋转
- (void)rotate;

/// 旋转到指定方向
- (void)rotate:(DNOrientation)orientation animated:(BOOL)animated;

/// 旋转到指定方向
- (void)rotate:(DNOrientation)orientation animated:(BOOL)animated completionHandler:(nullable void(^)(id<DNPlayerRotationManagerProtocol> mgr))completionHandler;


@property (nonatomic, weak, nullable) UIView *superview;
@property (nonatomic, weak, nullable) UIView *target;
/// The block invoked when orientation will changed, if return YES, auto rotate will be triggered
@property (nonatomic, copy, nullable) BOOL(^rotationCondition)(id <DNPlayerRotationManagerProtocol> mgr);


@end

NS_ASSUME_NONNULL_END
