//
//  UitilClass.h
//  FaceAuthDemo
//
//  Created by tsign on 2019/3/26.
//  Copyright © 2019 tsign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//NS_ASSUME_NONNULL_BEGIN

@interface UitilClass : NSObject
+ (void)creatAlertControllerAlert:(NSString *)megStr target:(UIViewController *)vc handle:(void (^)(void))handleBlock;
@end

//NS_ASSUME_NONNULL_END
