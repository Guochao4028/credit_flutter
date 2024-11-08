//
//  RealnameHelper.h
//  RealnameDemo
//
//  Created by hotchook on 2018/11/9.
//  Copyright © 2018年 timevale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealnameDelegate.h"

@interface RealnameHelper : NSObject

+ (URL_HANDLE_RESULT)handleRealnameURL:(NSURL *)url delegate:(id<RealnameDelegate>)delegate;

@end
