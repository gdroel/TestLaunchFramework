//
//  UIView.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import "UIView+Synthesis.h"
#import "UITouch+Synthesis.h"
#import "UIEvent+Synthesis.h"

@implementation UIView (Synthesis)

- (void) simulateTap {
//    UITouch *touch = [[UITouch alloc] initInView:self];
//    UIEvent *eventDown = [UIEvent makeWith:touch];
//
//    [touch.view touchesBegan:[eventDown allTouches] withEvent:eventDown];
//    [touch setValue:@(UITouchPhaseEnded) forKey:@"phase"];
//    [touch setValue:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"timestamp"];
//    
//    UIEvent *eventUp = [UIEvent makeWith:touch];
//    [touch.view touchesEnded:[eventUp allTouches] withEvent:eventUp];

//    [[self window] sendEvent:event];
    [UITouch dispatchTo:self];

}

@end
