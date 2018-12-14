//
//  NSObject+DNObserverHelper.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DNObserverHelper)

/// 添加观察者, 无需移除 (将会自动移除)
- (void)sj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

/// 添加观察者, 无需移除 (将会自动移除)
- (void)sj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;


@end

NS_ASSUME_NONNULL_END
