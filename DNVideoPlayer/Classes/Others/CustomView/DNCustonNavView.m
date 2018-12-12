//
//  DNCustonNavView.m
//  A9VG
//
//  Created by 张健康 on 2018/10/30.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import "DNCustonNavView.h"

#import "UIView+DNResponder.h"
#import "DNPlayerTypeDef.h"

@implementation DNCustonNavView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder: aDecoder]) {
        [self setUp];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [contentView setFrame:CGRectMake(0, STATUSBAR_H, ScreenWidth, 44)];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Common_arrow_back.png"] forState:UIControlStateNormal];
    [button sizeToFit];
    [contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(12));
        make.centerY.equalTo(contentView);
        make.width.equalTo(@(28));
        make.height.equalTo(@(44));
    }];
    
//    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setNaviTitle:(NSString *)title{
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    titleLabel.textColor= [UIColor blackColor];//[DNColorManager sharedInstance].textSt2;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    self.titleLabel = titleLabel;
}

- (void)setAlpha:(CGFloat)alpha
{
    self.titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
    [self setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:alpha]];
    [self.contentView setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:alpha]];
}

@end
