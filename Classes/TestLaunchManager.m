//
//  TestLaunchManager.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 3/30/21.
//

#import <UIKit/UIKit.h>
#import "TestLaunchManager.h"

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

@end
