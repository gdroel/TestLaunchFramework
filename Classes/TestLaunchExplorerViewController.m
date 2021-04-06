//
//  TestLaunchExplorerViewController.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/5/21.
//

#import "TestLaunchExplorerViewController.h"

@interface TestLaunchExplorerViewController ()

@property (nonatomic) UIButton *recordButton;

@end

@implementation TestLaunchExplorerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    _recordButton.backgroundColor = [UIColor greenColor];
    
    [_recordButton addTarget:self action:@selector(recordButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
}

- (void)recordButtonTapped:(UIButton*)sender {
    NSLog(@"record button tapped");
}

/* Handles touches */

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates {
    BOOL shouldReceiveTouch = NO;
    
    CGPoint pointInLocalCoordinates = [self.view convertPoint:pointInWindowCoordinates fromView:nil];
    
    // Always if it's on the toolbar
//    if (CGRectContainsPoint(self.explorerToolbar.frame, pointInLocalCoordinates)) {
//        shouldReceiveTouch = YES;
//    }
    
    // Always if it's on the toolbar
    if (CGRectContainsPoint(self.recordButton.frame, pointInLocalCoordinates)) {
        shouldReceiveTouch = YES;
    }
    
//    // Always if we're in selection mode
//    if (!shouldReceiveTouch && self.currentMode == FLEXExplorerModeSelect) {
//        shouldReceiveTouch = YES;
//    }
    
    return shouldReceiveTouch;
}


@end
