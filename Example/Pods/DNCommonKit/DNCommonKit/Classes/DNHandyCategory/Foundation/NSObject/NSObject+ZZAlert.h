//
//  NSObject+ZZAlert.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (ZZAlert)

/** 系统弹框 */
- (void)zz_showAlertWithTitle:(NSString *)title
                      message:(NSString *)message
              actionTitleList:(NSArray <NSString *> *)actionTitleList
                      handler:(void(^)(UIAlertAction * action, NSUInteger index))handler
                   completion:(void (^)(void))completion;

/** 系统弹框 */
- (void)zz_showAlertInputWithTitle:(NSString *)title
                           message:(NSString *)message
                   placeholderList:(NSArray <NSString *> *)placeholderList
                   actionTitleList:(NSArray <NSString *> *)actionTitleList
                           handler:(void(^)(UIAlertAction * action, UIAlertController * alertController, NSUInteger index))handler
                        completion:(void (^)(void))completion;

@end
