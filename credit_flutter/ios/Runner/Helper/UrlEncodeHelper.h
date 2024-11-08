//
//  UrlEncodeHelper.h
//  RealnameDemo
//
//  Created by hotchook on 2018/11/9.
//  Copyright © 2018年 timevale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlEncodeHelper : NSObject

+ (NSString *)URLEncodedString:(NSString *)str;
+ (NSString *)URLDecodedString:(NSString *)str;
+ (BOOL)isUrlAddress:(NSString*)url;
@end
