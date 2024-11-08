//
//  RealnameDelegate.h
//  RealnameDemo
//
//  Created by hotchook on 2018/11/9.
//  Copyright © 2018年 timevale. All rights reserved.
//

#ifndef RealnameDelegate_h
#define RealnameDelegate_h

#import "Constants.h"

@protocol RealnameDelegate

@optional
// 跳转到支付宝
- (void)realnameJumptoAlipay;

// 腾讯人脸识别回调
- (void)realnameZhimaCallback:(NSString *)callbackUrl;

// 实名认证结果返回
- (void)realnameResult:(REALNAME_RESULT)result;

// 签署结果返回
- (void)signResult:(BOOL)result;

@end

#endif /* RealnameDelegate_h */
