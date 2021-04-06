//
//  TestLaunchUtility.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/5/21.
//

#import "TestLaunchUtility.h"
#import "TestLaunchWindow.h"

@implementation TestLaunchUtility

+ (UIWindow *)appKeyWindow {
    // First, check UIApplication.keyWindow
    TestLaunchWindow *window = (id)UIApplication.sharedApplication.keyWindow;
    if (window) {
        if ([window isKindOfClass:[TestLaunchWindow class]]) {
            return window.previousKeyWindow;
        }
        
        return window;
    }
    
    // As of iOS 13, UIApplication.keyWindow does not return nil,
    // so this is more of a safeguard against it returning nil in the future.
    //
    // Also, these are obviously not all FLEXWindows; FLEXWindow is used
    // so we can call window.previousKeyWindow without an ugly cast
    for (TestLaunchWindow *window in UIApplication.sharedApplication.windows) {
        if (window.isKeyWindow) {
            if ([window isKindOfClass:[TestLaunchWindow class]]) {
                return window.previousKeyWindow;
            }
            
            return window;
        }
    }
    
    return nil;
}

+ (UIWindowScene *)activeScene {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        // Look for an active UIWindowScene
        if (scene.activationState == UISceneActivationStateForegroundActive &&
            [scene isKindOfClass:[UIWindowScene class]]) {
            return (UIWindowScene *)scene;
        }
    }
    
    return nil;
}

@end
