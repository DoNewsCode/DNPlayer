//
//  DNCustomAnimatorBaseViewController.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/19.
//

#import <UIKit/UIKit.h>
#import "DNCustomAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNCustomAnimatorBaseViewController : UIViewController<UIViewControllerTransitioningDelegate,DNCustomTransitionAnimating>

///** present 转场风格 */
@property (nonatomic, assign) DNCustomPresentStyle presentStyle;
/** dismiss 转场风格 */
@property (nonatomic, assign) DNCustomDismissStyle dismissStyle;

@end

NS_ASSUME_NONNULL_END
