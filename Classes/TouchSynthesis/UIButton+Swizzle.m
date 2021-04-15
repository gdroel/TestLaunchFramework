//
//  UIButtonSwizzle.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import "UIButton+Swizzle.h"

@implementation UIButton (Swizzle)

+ (void)load {
    Class class = [self class];
    
    SEL defaultSelector = @selector(touchesBegan:withEvent:);
    SEL swizzledSelector = @selector(swizzled_touchesBegan:withEvent:);
    
    Method defaultMethod = class_getInstanceMethod(class, defaultSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL isMethodExists = !class_addMethod(class, defaultSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (isMethodExists) {
        method_exchangeImplementations(defaultMethod, swizzledMethod);
    }
    else {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(defaultMethod), method_getTypeEncoding(defaultMethod));
    }
}

- (void)swizzled_touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self swizzled_touchesBegan:touches withEvent:event];
    NSLog(@"swizzle this uibutton");
}


@end
