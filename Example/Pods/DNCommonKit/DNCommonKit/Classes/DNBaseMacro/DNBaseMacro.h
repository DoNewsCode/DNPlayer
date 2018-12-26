//
//  DNBaseMacro.h
//  Pods
//
//  Created by donews on 2018/9/10.
//  项目里一些基本的宏

#ifndef DNBaseMacro_h
#define DNBaseMacro_h


#define YYAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define YYCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define YYAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define YYCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define YYAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define YYCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")


//----------------
//   Base Setting
//----------------
#define UIColorRandom ([UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1])

#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

#define kHPercentage(a) (SCREEN_HEIGHT*((a)/667.00))
#define kWPercentage(a) (SCREEN_WIDTH *((a)/375.00))


//-------------
//   基本适配
//-------------

//判断机型
#define iphone4                         [UIScreen mainScreen].bounds.size.height==480
#define iphone5                         [UIScreen mainScreen].bounds.size.height==568
#define iphone6                         [UIScreen mainScreen].bounds.size.height==667
#define iphone6p                        [UIScreen mainScreen].bounds.size.height==736
#define iphonePlush                     [UIScreen mainScreen].bounds.size.width==414
#define iPhoneX                         [UIScreen mainScreen].bounds.size.height==812

// 适配iOS 11 & iPhoneX
#define TGStatuBarHeight  (iPhoneX ? 44.00 : 20.00)
#define TGNavHeight       (TGStatuBarHeight + 44)
#define TGTabbarHeight    (iPhoneX ? 83 : 49)
#define TGPageScrollHeight  44.0

//顶导航+状态栏高度
#define kNAVSTATE_H (self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height)

// 适配 iOS 11 重写 adjustsScrollViewInsets
#define adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)



/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//----------
//  线程操作
//----------

//线程执行方法
#define Foreground_Begin  dispatch_async(dispatch_get_main_queue(), ^{
#define Foreground_End    });

#define Background_Begin  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
@autoreleasepool {
#define Background_End          }\
});


#endif /* DNBaseMacro_h */
