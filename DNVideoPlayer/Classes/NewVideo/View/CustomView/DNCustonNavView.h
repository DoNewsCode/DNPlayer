//
//  DNCustonNavView.h
//  A9VG
//
//  Created by 张健康 on 2018/10/30.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNCustonNavView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setNaviTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
