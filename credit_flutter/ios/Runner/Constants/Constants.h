//
//  Constants.h
//  RealnameDemo
//
//  Created by hotchook on 2018/11/9.
//  Copyright © 2018年 timevale. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/*
 * 实名回调地址
 */
#define CALLBACK_SCHEME @"esign://hyc"
#define REALNAME_CALLBACK @"esign://hyc/realBack" //实名的回调跟 生成实名H5链接的入参redirectUrl相关
#define SIGN_CALLBACK @"esign://hyc/signBack" //签署的appScheme 入参



#define JUMP_TO_ALIPAY @"alipays://platformapi/startapp?appId=20000067&url="
#define SIGN_RESULT_WEB_CLOSE_JS_FUNCTION @"jsbridge://signCallback" // 签署H5回调的结果 会根据redirectUrl入参变化，需要同步
#define REAL_RESULT_WEB_CLOSE_JS_FUNCTION @"esign://demo/realBack" // 实名H5回调的结果 会根据redirectUrl入参变化，需要同步

typedef NS_ENUM(NSInteger, REALNAME_RESULT) {
    REALNAME_RESULT_CANCEL = 0,
    REALNAME_RESULT_FAILED = 1,
    REALNAME_RESULT_SUCCESS = 2,
};

typedef NS_ENUM(NSInteger, URL_HANDLE_RESULT) {
    URL_HANDLE_RESULT_NULL = 0,
    URL_HANDLE_RESULT_CANCEL = 1,
    URL_HANDLE_RESULT_ALLOW = 2,
};

#endif /* Constants_h */
