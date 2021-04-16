//
//  TestLaunchTap.h
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/16/21.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestLaunchTap : NSObject

@property (nonatomic) CGPoint tapPoint;

- (instancetype)initWithTapPoint:(CGPoint)tapPoint;

@end

NS_ASSUME_NONNULL_END
