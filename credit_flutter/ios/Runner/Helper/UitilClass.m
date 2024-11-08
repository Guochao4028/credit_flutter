//
//  UitilClass.m
//  FaceAuthDemo
//
//  Created by tsign on 2019/3/26.
//  Copyright © 2019 tsign. All rights reserved.
//

#import "UitilClass.h"

@implementation UitilClass

+ (void)creatAlertControllerAlert:(NSString *)megStr target:(UIViewController *)vc handle:(void (^)(void))handleBlock {
    //跟上面的流程差不多，记得要把preferredStyle换成UIAlertControllerStyleAlert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:megStr preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //NSLog(@"点击了确定按钮！");
        if (handleBlock) {
            handleBlock();
        }
    }];
    
    [alert addAction:action1];
    
    [vc presentViewController:alert animated:YES completion:nil];
    
}
@end
