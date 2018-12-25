//
//  DNVideoItemBaseFrameModel.m
//  DNVideoPlayer_Example
//
//  Created by Madjensen on 2018/12/24.
//  Copyright © 2018 563620078@qq.com. All rights reserved.
//

#import "DNVideoItemBaseFrameModel.h"

@implementation DNVideoItemBaseFrameModel

- (instancetype)initWithModel:(DNVideoListItemModel *)model
{
    if (self = [super init]) {
        self.model = model;
        self.hasBottomLine = YES;
    }
    return self;
}

@end
