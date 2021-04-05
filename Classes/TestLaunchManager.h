//
//  TestLaunchManager.h
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 3/30/21.
//

#ifndef TestLaunchManager_h
#define TestLaunchManager_h

@interface TestLaunchManager : NSObject

@property (nonatomic, readonly, class) TestLaunchManager *sharedManager;

// Public methods
- (void) doSomething;
- (void) showExplorer;

@end
#endif /* TestLaunchManager_h */
