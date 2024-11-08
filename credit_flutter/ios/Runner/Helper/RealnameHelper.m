//
//  RealnameHelper.m
//  RealnameDemo
//
//  Created by hotchook on 2018/11/9.
//  Copyright © 2018年 timevale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealnameHelper.h"
#import "UrlEncodeHelper.h"
#import "Constants.h"

@implementation RealnameHelper

+ (URL_HANDLE_RESULT)handleRealnameURL:(NSURL *)url delegate:(id<RealnameDelegate>)delegate {
    // 获取完整url并进行UTF-8转码
    NSString *requestUrl = [url.absoluteString stringByRemovingPercentEncoding];
    if ([url.host isEqualToString:@"zmcustprod.zmxy.com.cn"]) { // 跳转芝麻认证
        if (delegate && [(NSObject *) delegate respondsToSelector:@selector(realnameJumptoAlipay)]) {
            [delegate realnameJumptoAlipay];
        }
        NSString *requestEncodeUrl = [UrlEncodeHelper URLEncodedString:requestUrl];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JUMP_TO_ALIPAY, requestEncodeUrl]] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", JUMP_TO_ALIPAY, requestEncodeUrl]]];
        }
        return URL_HANDLE_RESULT_CANCEL;
    } else if ([url.scheme isEqualToString:@"alipays"]) { // 跳转到支付宝
        if ([url.host isEqualToString:@"platformapi"]) {
            NSRange range = [requestUrl rangeOfString:@"?"];
            if (range.location == NSNotFound) { //
                if (delegate && [(NSObject *) delegate respondsToSelector:@selector(realnameResult:)]) {
                    [delegate realnameResult:REALNAME_RESULT_CANCEL];
                }
            } else { // 有结果 ，跳支付宝app
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }

    } else if ([requestUrl hasPrefix:@"jsbridge://signCallback"] || [requestUrl hasPrefix:SIGN_CALLBACK]) { // h5 签署返回结果处理
        // 签署返回结果样例 jsbridge://signCallback?signResult=true
        // 带跳转的 esign://demo/signBack?tsignDes=%E7%AD%BE%E7%BD%B2%E6%88%90%E5%8A%9F&tsignType=SIGN&tsignCode=0
        NSRange range = [requestUrl rangeOfString:@"?"];
        if (range.location == NSNotFound) { // 暂不认证
            if (delegate && [(NSObject *) delegate respondsToSelector:@selector(realnameResult:)]) {
                [delegate realnameResult:REALNAME_RESULT_CANCEL];
            }
        } else { // 有结果
            NSString *strParam = [requestUrl substringFromIndex:range.location + range.length];
            NSArray *params = [strParam componentsSeparatedByString:@"&"];
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            for (NSString *param in params) {
                NSArray *paramItems = [param componentsSeparatedByString:@"="];
                if (paramItems.count != 2) {
                    continue;
                }
                [paramDic setObject:paramItems[1] forKey:paramItems[0]];
            }
            BOOL status = [paramDic[@"signResult"] boolValue];
            if (!status && paramDic[@"tsignCode"]) {
                if ([paramDic[@"tsignCode"] intValue] == 0) {
                    status = true;
                }
            }
            if (delegate && [(NSObject *) delegate respondsToSelector:@selector(signResult:)]) {
                [delegate signResult:status];
            }
        }
        return URL_HANDLE_RESULT_CANCEL;
    } else if ([requestUrl hasPrefix:CALLBACK_SCHEME] || [requestUrl hasPrefix:@"js://tsignRealBack"] || [requestUrl hasPrefix:@"js://signCallBack"]) { // h5 实名返回结果处理
        // 实名认证的入参跟 接口传值 redirectUrl 相关
        // redirectUrl = esign://demo/realBack   读秒后触发的回调 esign://demo/realBack&serviceId=854677892133554052&verifycode=4a52e2af0d0abfb7b285c4f05b5af133&status=true&passed=true
        // redirectUrl = js://tsignRealBack?esignAppScheme=esign://demo/realBack 读秒后触发的回调 js://tsignRealBack?esignAppScheme=esign://demo/realBack&serviceId=854677892133554052&verifycode=4a52e2af0d0abfb7b285c4f05b5af133&status=true&passed=true
        if ([requestUrl containsString:REAL_RESULT_WEB_CLOSE_JS_FUNCTION]) { // 实名回来
            NSRange range = [requestUrl rangeOfString:REAL_RESULT_WEB_CLOSE_JS_FUNCTION];
            NSString *strParam = [requestUrl substringFromIndex:range.location + range.length];
            NSArray *params = [strParam componentsSeparatedByString:@"&"];
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            for (NSString *param in params) {
                NSArray *paramItems = [param componentsSeparatedByString:@"="];
                if (paramItems.count != 2) {
                    continue;
                }
                [paramDic setObject:paramItems[1] forKey:paramItems[0]];
            }
            BOOL status = [paramDic[@"passed"] boolValue];
            if (delegate && [(NSObject *) delegate respondsToSelector:@selector(realnameResult:)]) {
                [delegate realnameResult:(status ? REALNAME_RESULT_SUCCESS : REALNAME_RESULT_FAILED)];
            }
        }
        return URL_HANDLE_RESULT_CANCEL;
    }
    
    return URL_HANDLE_RESULT_ALLOW;
}

@end
