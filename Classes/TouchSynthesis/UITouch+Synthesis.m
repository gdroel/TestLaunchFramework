//
//  UITouch+Synthesis.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import "UITouch+Synthesis.h"
#import "UIEvent+Synthesis.h"

@implementation UITouch (Synthesis)

- (instancetype)initInView:(UIView *)view
{
    self = [super init];
    if (self) {
        CGRect frameInWindow;
        if ([view isKindOfClass:[UIWindow class]])
        {
            frameInWindow = view.frame;
        }
        else
        {
            frameInWindow = [view.window convertRect:view.frame fromView:view.superview];
        }
         
        // Calculate the center point of the view to simulate a tap on
        CGPoint tapPoint = CGPointMake(
                                frameInWindow.origin.x + 0.5 * frameInWindow.size.width,
                                frameInWindow.origin.y + 0.5 * frameInWindow.size.height);
        UIWindow *window = [view window];
//        CGPoint windowCoord = [view convertPoint:tapPoint toView:window];
        UIView *target = [view.window hitTest:tapPoint withEvent:nil];

        [self setValue:@(1) forKey: @"tapCount"];
        [self setValue:window forKey: @"window"];
        [self setValue:target forKey: @"view"];
        [self setValue:@(tapPoint) forKey: @"locationInWindow"];
        [self setValue:@(tapPoint) forKey: @"previousLocationInWindow"];
        [self setValue:@(UITouchPhaseBegan) forKey: @"phase"];
        [self setValue:@(UITouchTypeDirect) forKey: @"type"];
        [self setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];

//        [self setValue:[UITouch PhaseforKey: @"tapCount"];

    }
    return self;
}

+ (void) dispatchTo:(UIView *)view {
    UITouch *touch = [[UITouch alloc] initInView:view];
    UIEvent *eventDown = [UIEvent makeWith:touch];
    [touch.window sendEvent:eventDown];
//
    [touch setValue:@(UITouchPhaseEnded) forKey:@"phase"];
    [touch setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
//    
    UIEvent *eventUp = [UIEvent makeWith:touch];
    [touch.window sendEvent:eventUp];
}

@end
