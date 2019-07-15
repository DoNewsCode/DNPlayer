//
//  DNListVideoDetailTableViewCell.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/26.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNVideoFrameModelProtocol.h"
#import <DNVideoPlayer/DNVideoPlaceHolderView.h>
#import "DNDetailVideoCellBottomView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ItemCellPlayBtnClickBlock)(id sender);

@interface DNListVideoDetailTableViewCell : UITableViewCell
<DNVideoFrameModelProtocol>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DNDetailVideoCellBottomView *bottomView;

@property (nonatomic, strong) DNVideoPlaceHolderView *videoPlaceHolderView;

@property (nonatomic, copy) ItemCellPlayBtnClickBlock playBtnClickBlock;



+ (DNListVideoDetailTableViewCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
