//
//  DNVideoFrameModelProtocol.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/24.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DNVideoFrameModelProtocol <NSObject>
- (instancetype)initWithModel:(NSObject *)model;
/// cell 需要实现的方法
- (void)setLayout:(id<DNVideoFrameModelProtocol>)layoutModel;
/// FrameModel 需要实现的方法
- (void)layout:(UIView *)view;
- (void)layout:(UIView *)view data:(NSObject *)data;

/// 总高度
- (CGFloat)totalHeight;

- (CGSize)itemSize;

@end

NS_ASSUME_NONNULL_END
