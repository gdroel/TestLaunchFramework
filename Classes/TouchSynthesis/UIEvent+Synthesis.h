//
//  UIEvent+Synthesis.h
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIEvent (Synthesis)

+ (UIEvent *)makeWith:(UITouch *)touch;

@end

NS_ASSUME_NONNULL_END
