//
//  TestLaunchExplorerViewController.h
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestLaunchExplorerViewController<UIGestureRecognizerDelegate> : UIViewController

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates;

@end

NS_ASSUME_NONNULL_END
