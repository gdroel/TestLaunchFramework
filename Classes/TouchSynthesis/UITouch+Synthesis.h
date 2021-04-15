//
//  UITouch+Synthesis.h
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITouch (Synthesis)

- (instancetype)initInView:(UIView *)view;
+ (void) dispatchTo:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
