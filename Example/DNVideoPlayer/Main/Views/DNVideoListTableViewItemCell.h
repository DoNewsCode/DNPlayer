//
//  DNVideoListTableViewItemCell.h
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/13.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^ItemCellPlayBtnClickBlock)(id sender);

@interface DNVideoListTableViewItemCell : UITableViewCell

@property (nonatomic, strong) UIView *placeHolderView;
@property (nonatomic, copy) ItemCellPlayBtnClickBlock playBtnClickBlock;



+ (DNVideoListTableViewItemCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
