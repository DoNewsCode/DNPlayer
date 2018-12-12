//
//  UIImage+DNUtils.h
//  A9VG
//
//  Created by 张健康 on 2018/11/30.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DNUtils)
//压缩图片数据
- (NSData *)resetSizeImageMaxSize:(NSInteger)maxSize;

//获取压缩的图片
- (UIImage *)getRestImageWithMaxSize:(NSInteger)maxSize;
@end

NS_ASSUME_NONNULL_END
