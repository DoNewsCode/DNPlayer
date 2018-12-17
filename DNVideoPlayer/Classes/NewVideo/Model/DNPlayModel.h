//
//  DNPlayModel.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    filepath = "/data/shareimg_oss/new_video/2018/08/12/36c446ed136f006ab290b48012e849ec.mp4";
//    filesize = 10641757;
//    videourl = "https://niuerdata.g.com.cn/data/shareimg_oss/new_video/2018/08/12/36c446ed136f006ab290b48012e849ec.mp4";
//}
NS_ASSUME_NONNULL_BEGIN
@protocol DNPlayModelViewProtocol<NSObject>
/// 相关视图的Tag
@property (nonatomic) NSInteger tag;
@end

@protocol DNPlayModel<NSObject>
- (BOOL)isPlayInTableView;
- (BOOL)isPlayInCollectionView;
- (nullable UIView *)playerSuperview;
@end

@interface DNPlayModel : NSObject<DNPlayModel>

//播放地址
@property (nonatomic, strong) NSNumber *filesize;
@property (nonatomic, copy) NSString *filepath;
@property (nonatomic, copy) NSString *videourl;

- (instancetype)init;

+ (instancetype)UITableViewCellPlayModelWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                                                   atIndexPath:(__strong NSIndexPath *)indexPath
                                                     tableView:(__weak UITableView *)tableView;



@end

/// 视图层级
/// - UITableView
///     - UITableViewCell
///         - player super view
///             - player
@interface DNUITableViewCellPlayModel: DNPlayModel

- (instancetype)initWithPlayerSuperview:(__unused UIView<DNPlayModelViewProtocol> *)playerSuperview
                            atIndexPath:(__strong NSIndexPath *)indexPath
                              tableView:(__weak UITableView *)tableView;

@property (nonatomic, readonly) NSInteger playerSuperviewTag;
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, weak, readonly) UITableView *tableView;

- (instancetype)initWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                               atIndexPath:(__strong NSIndexPath *)indexPath
                                 tableView:(__weak UITableView *)tableView;
@end
NS_ASSUME_NONNULL_END
