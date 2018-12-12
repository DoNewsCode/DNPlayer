//
//  DNPlayModel.h
//  DoNews
//
//  Created by Madjensen on 2018/8/16.
//  Copyright © 2018 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    filepath = "/data/shareimg_oss/new_video/2018/08/12/36c446ed136f006ab290b48012e849ec.mp4";
//    filesize = 10641757;
//    videourl = "https://niuerdata.g.com.cn/data/shareimg_oss/new_video/2018/08/12/36c446ed136f006ab290b48012e849ec.mp4";
//}
@interface DNPlayModel : NSObject

@property (nonatomic, copy) NSString *filepath;
@property (nonatomic, copy) NSString *videourl;
//播放地址
@property (nonatomic, strong) NSNumber *filesize;

@end
