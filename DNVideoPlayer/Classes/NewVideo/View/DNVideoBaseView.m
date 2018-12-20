//
//  DNVideoBaseView.m
//  DNVideoPlayer
//
//  Created by Madjensen on 2018/12/20.
//

#import "DNVideoBaseView.h"

@implementation DNVideoBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatBaseConfige];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatBaseConfige];
    }
    return self;
}

- (void)creatBaseConfige
{
    
}

- (NSBundle *)resourceBundle {
    if (_resourceBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        _resourceBundle =  [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DNVideoPlayer" ofType:@"bundle"]];
    }
    return _resourceBundle;
}


@end
