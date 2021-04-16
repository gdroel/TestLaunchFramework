//
//  TestLaunchTap.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/16/21.
//

#import "TestLaunchTap.h"

@implementation TestLaunchTap

- (instancetype)initWithTapPoint:(CGPoint)tapPoint
{
    self = [super init];
    if (self) {
        _tapPoint = tapPoint;
    }
    return self;
}
@end
