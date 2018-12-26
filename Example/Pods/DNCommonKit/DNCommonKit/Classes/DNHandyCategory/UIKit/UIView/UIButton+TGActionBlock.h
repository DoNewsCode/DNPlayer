//
//  UIButton+TGActionBlock.h
//  TGBus
//
//  Created by donews on 2018/9/5.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(void);

@interface UIButton (TGActionBlock)

- (void)dn_handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

@end
