//
//  DNBottomWebMainView.h
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/11.
//  Copyright © 2018 Madjensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define VideoMaxHeight ABS((ScreenWidth * 9 / 16) + TGStatuBarHeight)
#define ScrollMaxOffSet (VideoMaxHeight - TGNavHeight)

NS_ASSUME_NONNULL_BEGIN

@interface DNBottomWebMainView : UIView


+ (instancetype)bottomWebMainViewWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
