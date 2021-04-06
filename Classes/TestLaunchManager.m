//
//  TestLaunchManager.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 3/30/21.
//

#import <UIKit/UIKit.h>
#import "TestLaunchManager.h"
#import "TestLaunchWindow.h"
#import "TestLaunchExplorerViewController.h"

@interface TestLaunchManager () <TestLaunchWindowEventDelegate>

@property (nonatomic) TestLaunchWindow *explorerWindow;
@property (nonatomic) TestLaunchExplorerViewController *explorerViewController;

@end

@implementation TestLaunchManager : NSObject

+ (instancetype)sharedManager {
    static TestLaunchManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    return sharedManager;
}

- (void) doSomething {
    NSLog(@"Hello from my framework");
}

- (void)showExplorer {
    UIWindow *tl_window = self.explorerWindow;
    tl_window.hidden = NO;
    
    // Only look for a new scene if we don't have one
    if (!tl_window.windowScene) {
        //tl_window.windowScene = FLEXUtility.activeScene;
    }
}

- (TestLaunchWindow *) explorerWindow {
    if (NULL == _explorerWindow) {
        _explorerWindow = [[TestLaunchWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _explorerWindow.rootViewController = self.explorerViewController;
        _explorerWindow.eventDelegate = self;
    }
    
    return _explorerWindow;
}

- (TestLaunchExplorerViewController *) explorerViewController {
    if (NULL == _explorerViewController) {
        _explorerViewController = [[TestLaunchExplorerViewController alloc] init];
        // _explorerViewController.delegate = self;
    }

    return _explorerViewController;
}

#pragma mark - TestLaunchWindowEventDelegate

- (BOOL)shouldHandleTouchAtPoint:(CGPoint)pointInWindow {
    // Ask the explorer view controller
    return [self.explorerViewController shouldReceiveTouchAtWindowPoint:pointInWindow];
}

- (BOOL)canBecomeKeyWindow {
    // Only when the explorer view controller wants it because
    // it needs to accept key input & affect the status bar.
    // return self.explorerViewController.wantsWindowToBecomeKey;
    return YES;
}


@end
