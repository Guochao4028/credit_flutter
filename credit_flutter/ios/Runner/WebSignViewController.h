//
//  WebSignViewController.h
//  Runner
//
//  Created by 郭超 on 2023/3/23.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebSignViewController : UIViewController
@property (copy, nonatomic) NSString *realnameUrl;
- (void)reloadUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
