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

+ (NSArray<UIWindow *> *)allWindows {
    BOOL includeInternalWindows = YES;
    BOOL onlyVisibleWindows = NO;

    // Obfuscating selector allWindowsIncludingInternalWindows:onlyVisibleWindows:
    NSArray<NSString *> *allWindowsComponents = @[
        @"al", @"lWindo", @"wsIncl", @"udingInt", @"ernalWin", @"dows:o", @"nlyVisi", @"bleWin", @"dows:"
    ];
    SEL allWindowsSelector = NSSelectorFromString([allWindowsComponents componentsJoinedByString:@""]);

    NSMethodSignature *methodSignature = [[UIWindow class] methodSignatureForSelector:allWindowsSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];

    invocation.target = [UIWindow class];
    invocation.selector = allWindowsSelector;
    [invocation setArgument:&includeInternalWindows atIndex:2];
    [invocation setArgument:&onlyVisibleWindows atIndex:3];
    [invocation invoke];

    __unsafe_unretained NSArray<UIWindow *> *windows = nil;
    [invocation getReturnValue:&windows];
    return windows;
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
