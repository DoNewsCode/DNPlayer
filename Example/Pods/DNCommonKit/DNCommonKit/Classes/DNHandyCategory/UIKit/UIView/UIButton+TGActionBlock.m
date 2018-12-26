//
//  UIButton+TGActionBlock.m
//  TGBus
//
//  Created by donews on 2018/9/5.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import "UIButton+TGActionBlock.h"
#import <objc/runtime.h>

static char overviewKey;

@implementation UIButton (TGActionBlock)

- (void)dn_handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(__callActionBlock:) forControlEvents:event];
}


- (void)__callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end
