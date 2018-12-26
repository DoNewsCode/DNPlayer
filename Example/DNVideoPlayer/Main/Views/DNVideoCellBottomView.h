//
//  DNVideoCellBottomView.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/24.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNVideoListItemFrameModel;
NS_ASSUME_NONNULL_BEGIN

//四个View
//1.标签视图
@interface DNLeftTagLabelsView : UIView

+ (instancetype)dnLeftTagLabelsView;

@end

//2.分享视图
@interface DNLeftShareView : UIView
@property (nonatomic,strong) UILabel *shareLabel;//分享到
/// 微信朋友圈
@property (nonatomic,strong) UIButton *shareToWechatTimeLine;
/// 微信好友
@property (nonatomic,strong) UIButton *shareToWechatSession;
//@property (nonatomic,strong) UILabel *adLabel;//广告标识
//@property (nonatomic,strong) UILabel *adTitleLabel;//广告标识
+ (instancetype)dnLeftShareView;
@end

//3.作者头像名称视图
@interface DNLeftAuthorView : UIView
/// 发布人头像
@property (nonatomic,strong) UIImageView *headerImageView;
/// 发布人名称
@property (nonatomic,strong) UILabel *nameLabel;

+ (instancetype)dnLeftAuthorView;
@end

//4.收藏,评论,分享弹窗视图
@interface DNRightCollectView : UIView
/// 分享按钮
@property (nonatomic,strong) UIButton *shareButton;
/// 评论按钮
@property (nonatomic,strong) UIButton *commentButton;
/// 收藏按钮
@property (nonatomic,strong) UIButton *collectButton;

+ (instancetype)dnRightCollectView;
@end



typedef void(^BottomViewPublicBlock)(id sender);
@interface DNVideoCellBottomView : UIView
/// 左侧标签视图
@property (nonatomic, strong) DNLeftTagLabelsView *leftTagsView;
/// 左侧作者视图
@property (nonatomic, strong) DNLeftAuthorView *leftAuthorView;
/// 左侧分享视图
@property (nonatomic, strong) DNLeftShareView *leftShareView;
/// 右侧分享收藏视图
@property (nonatomic, strong) DNRightCollectView *rightCollectView;
/// 中间分隔线
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) DNVideoListItemFrameModel *frameModel;

/// 点击事件
@property (nonatomic, copy) BottomViewPublicBlock bottomViewTapActionBlock;
@property (nonatomic, copy) BottomViewPublicBlock headerImageTapActionBlock;

+ (instancetype)dnVideoCellBottomView;
@end

NS_ASSUME_NONNULL_END
