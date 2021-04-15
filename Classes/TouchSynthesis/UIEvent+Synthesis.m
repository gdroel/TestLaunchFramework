//
//  UIEvent+Synthesis.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import "UIEvent+Synthesis.h"
#import <objc/message.h>

@interface GSEventProxy : NSObject
{
@public
    unsigned int flags;
    unsigned int type;
    unsigned int ignored1;
    float x1;
    float y1;
    float x2;
    float y2;
    unsigned int ignored2[10];
    unsigned int ignored3[7];
    float sizeX;
    float sizeY;
    float x3;
    float y3;
    unsigned int ignored4[3];
}
@end
@implementation GSEventProxy
@end

@implementation UIEvent (Synthesis)

+ (UIEvent *)makeWith:(UITouch *)touch {
    CGPoint location = [touch locationInView:touch.window];

    CGSize size = CGSizeMake(1.0, 1.0);
        
    // Using private API right here
    NSSet *touchSet = [NSSet setWithArray:[NSArray arrayWithObject:touch]];
    
    /* Build our event proxy that is sent to the event class*/
    GSEventProxy *eproxy = [[GSEventProxy alloc] init];
    eproxy->x1 = location.x;
    eproxy->x2 = location.x;
    eproxy->x3 = location.x;
   
    eproxy->y1 = location.y;
    eproxy->y2 = location.y;
    eproxy->y3 = location.y;
   
    eproxy->sizeX = size.width;
    eproxy->sizeY = size.height;
    
    eproxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
    eproxy->type = 3001;
    
    SEL selector = NSSelectorFromString(@"_initWithEvent:touches:");
    Class touchesEventClass = objc_getClass("UITouchesEvent");
    NSObject *instance = [touchesEventClass alloc];
    instance = [instance performSelector:selector withObject:eproxy withObject:touchSet];
    [instance setValue:@([[NSProcessInfo processInfo] systemUptime]) forKey:@"timestamp"];

    return (UIEvent *)instance;
}

@end
