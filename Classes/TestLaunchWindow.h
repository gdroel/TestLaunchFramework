//
//  TestLaunchWindow.h
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TestLaunchWindowEventDelegate <NSObject>

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow;
- (BOOL)canBecomeKeyWindow;

@end

@interface TestLaunchWindow : UIWindow

@property (nonatomic, weak) id <TestLaunchWindowEventDelegate> eventDelegate;

@end

NS_ASSUME_NONNULL_END
