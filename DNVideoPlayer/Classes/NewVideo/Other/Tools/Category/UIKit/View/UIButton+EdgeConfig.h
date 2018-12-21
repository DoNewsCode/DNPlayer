//
//  UIButton+EdgeConfig.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/21.
//

#import <UIKit/UIKit.h>

/// 图片方向选择
typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (EdgeConfig)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)ca_layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                           imageTitleSpace:(CGFloat)space;


/// 设置按钮扩大响应区域的范围
- (void)ca_setEnlargeEdge:(CGFloat)size;

/**
 * @brief 详细设置按钮扩大响应区域的范围
 * @param top         按钮上方扩展的范围
 * @param right       按钮右方扩展的范围
 * @param bottom      按钮下方扩展的范围
 * @param left        按钮左方扩展的范围
 */
- (void)ca_setEnlargeEdgeWithTop:(CGFloat)top
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom
                            left:(CGFloat)left;



@end

NS_ASSUME_NONNULL_END
