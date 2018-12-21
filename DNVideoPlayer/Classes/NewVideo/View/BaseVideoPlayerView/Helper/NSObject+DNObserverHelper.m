//
//  NSObject+DNObserverHelper.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/14.
//

#import "NSObject+DNObserverHelper.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNObserverHelper: NSObject
@property (nonatomic, readonly) const char *key; // lazy load
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, unsafe_unretained) id observer;
@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, weak) DNObserverHelper *factor;
@end

@implementation DNObserverHelper {
    char *_key;
}
- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _key = NULL;
    return self;
}
- (const char *)key {
    if ( _key ) return _key;
    NSString *keyStr = [NSString stringWithFormat:@"sanjiang:%lu", (unsigned long)[self hash]];
    _key = malloc(keyStr.length * sizeof(char) + 1);
    strcpy(_key, keyStr.UTF8String);
    return _key;
}
- (void)dealloc {
    if ( _key ) free(_key);
    if ( _factor ) {
        [_target removeObserver:_observer forKeyPath:_keyPath];
    }
}

@end


@implementation NSObject (DNObserverHelper)

- (void)dn_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    [self dn_addObserver:observer forKeyPath:keyPath context:NULL];
}

- (void)dn_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    NSParameterAssert(observer);
    NSParameterAssert(keyPath);

    if ( !observer || !keyPath ) return;

    NSString *hashstr = [NSString stringWithFormat:@"%lu-%@", (unsigned long)[observer hash], keyPath];

    if ( [[self dn_observerhashSet] containsObject:hashstr] ) return;
    else [[self dn_observerhashSet] addObject:hashstr];

    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:context];

    DNObserverHelper *helper = [DNObserverHelper new];
    DNObserverHelper *sub = [DNObserverHelper new];

    sub.target = helper.target = self;
    sub.observer = helper.observer = observer;
    sub.keyPath = helper.keyPath = keyPath;

    helper.factor = sub;
    sub.factor = helper;

    objc_setAssociatedObject(self, helper.key, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(observer, helper.key, sub, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableSet<NSString *> *)dn_observerhashSet {
    NSMutableSet<NSString *> *set = objc_getAssociatedObject(self, _cmd);
    if ( set ) return set;
    set = [NSMutableSet set];
    objc_setAssociatedObject(self, _cmd, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return set;
}
@end
NS_ASSUME_NONNULL_END
