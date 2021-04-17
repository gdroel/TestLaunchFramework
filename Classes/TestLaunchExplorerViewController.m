//
//  TestLaunchExplorerViewController.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/5/21.
//

#define TL_ENABLED YES

#import "TestLaunchExplorerViewController.h"
#import "TestLaunchUtility.h"
#import "UIView+Synthesis.h"
#import "TestLaunchTap.h"

@interface TestLaunchExplorerViewController ()

@property (nonatomic) UIButton *recordButton;

@property (nonatomic) UIButton *runTestsButton;

/// The actual views at the selection point with the deepest view last.
@property (nonatomic) NSArray<UIView *> *viewsAtTapPoint;

@property (nonatomic) NSDictionary<NSValue *, UIView *> *outlineViewsForVisibleViews;

@property (nonatomic) UIView *selectedView;

@property (nonatomic) NSMutableArray<TestLaunchTap *> *tlTaps;

@property (nonatomic) BOOL runningTest;

@property (nonatomic) BOOL isRecording;

@end

@implementation TestLaunchExplorerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    CGFloat initialY = 40;
    CGFloat buttonHeight = 40;
    CGFloat padding = 5;
    CGFloat buttonWidth = buttonHeight;
    UIColor *buttonColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.6];

    // Set up record button
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - buttonWidth - padding, initialY, buttonWidth, buttonHeight)];
    [_recordButton setBackgroundColor:buttonColor];
    [_recordButton setImage:[UIImage imageNamed:@"RecordIcon"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[_recordButton layer] setCornerRadius:buttonHeight/2];
    [_recordButton setClipsToBounds:YES];
    
    // Set up run tests button
    _runTestsButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) + padding, initialY, buttonWidth, buttonHeight)];
    [_runTestsButton setBackgroundColor:buttonColor];
    [_runTestsButton setImage:[UIImage imageNamed:@"RunTestsIcon"] forState:UIControlStateNormal];
    [_runTestsButton addTarget:self action:@selector(runTests:) forControlEvents:UIControlEventTouchUpInside];
    [[_runTestsButton layer] setCornerRadius:buttonHeight/2];
    [_runTestsButton setClipsToBounds:YES];
    
    [self.view addSubview:_recordButton];
    [self.view addSubview:_runTestsButton];

    UITapGestureRecognizer *selectionTapGR = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(handleSelectionTap:)
    ];
    
    [selectionTapGR setDelegate:self];
    
    _runningTest = NO;
    _isRecording = NO;
    
    [self.view addGestureRecognizer:selectionTapGR];
}

- (void)recordButtonTapped:(UIButton*)sender {
    NSLog(@"record button tapped");
    
    if (NO == _isRecording) {
        [sender setBackgroundColor:[UIColor redColor]];
        _isRecording = YES;
    } else {
        [sender setBackgroundColor:[UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.6]];
        [self removeAndClearOutlineViews];
        _isRecording = NO;
        
        // Clear the taps array
        _tlTaps = [[NSMutableArray alloc] init];
    }
}

- (void)runTests:(UIButton*)sender {
    NSLog(@"Trying to run test.");
    [sender setBackgroundColor:[UIColor greenColor]];
    UIWindow *windowForSelection = UIApplication.sharedApplication.keyWindow;
    _runningTest = YES;
    
    for (TestLaunchTap *tlTap in _tlTaps) {
        [self updateOutlineViewsForSelectionPoint:tlTap.tapPoint];
        [NSThread sleepForTimeInterval:1.0];
    }
    
    _runningTest = NO;
    [sender setBackgroundColor:[UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.6]];
}

/* Handles touches */

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates {
    
//    return TL_ENABLED;
    
    BOOL shouldReceiveTouch = NO;
    
    CGPoint pointInLocalCoordinates = [self.view convertPoint:pointInWindowCoordinates fromView:nil];
    
    // Always handle record events
    if (CGRectContainsPoint(self.recordButton.frame, pointInLocalCoordinates)) {
        shouldReceiveTouch = YES;
    }
    
    // If we are recording then always handle touch
    if (YES == _isRecording) {
        shouldReceiveTouch = YES;
    }
    
    return shouldReceiveTouch;

//    BOOL shouldReceiveTouch = NO;
//
//    CGPoint pointInLocalCoordinates = [self.view convertPoint:pointInWindowCoordinates fromView:nil];
//
//    // Always if it's on the toolbar
////    if (CGRectContainsPoint(self.explorerToolbar.frame, pointInLocalCoordinates)) {
////        shouldReceiveTouch = YES;
////    }
//
//    // Always if it's on the toolbar
//    if (CGRectContainsPoint(self.recordButton.frame, pointInLocalCoordinates)) {
//        shouldReceiveTouch = YES;
//    }
//
////    // Always if we're in selection mode
////    if (!shouldReceiveTouch && self.currentMode == FLEXExplorerModeSelect) {
////        shouldReceiveTouch = YES;
////    }
//
//    return YES;
    
//    return shouldReceiveTouch;
}

// This is the bread and butter of view introspection
- (NSArray<UIView *> *)recursiveSubviewsAtPoint:(CGPoint)pointInView
                                         inView:(UIView *)view
                                skipHiddenViews:(BOOL)skipHidden {
    
    NSMutableArray<UIView *> *subviewsAtPoint = [NSMutableArray new];
    for (UIView *subview in view.subviews) {
        BOOL isHidden = subview.hidden || subview.alpha < 0.01;
        if (skipHidden && isHidden) {
            continue;
        }
        
        BOOL subviewContainsPoint = CGRectContainsPoint(subview.frame, pointInView);
        if (subviewContainsPoint) {
            [subviewsAtPoint addObject:subview];
            
            // We don't want to go any deeper, at least for recording
            if ([subview isKindOfClass:[UIControl class]]) {
                break;
            }
        }
        
        // If this view doesn't clip to its bounds, we need to check its subviews even if it
        // doesn't contain the selection point. They may be visible and contain the selection point.
        if (subviewContainsPoint || !subview.clipsToBounds) {
            CGPoint pointInSubview = [view convertPoint:pointInView toView:subview];
            [subviewsAtPoint addObjectsFromArray:[self
                recursiveSubviewsAtPoint:pointInSubview inView:subview skipHiddenViews:skipHidden
            ]];
        }
    }
    return subviewsAtPoint;
}

- (NSArray<UIView *> *)viewsAtPoint:(CGPoint)tapPointInWindow skipHiddenViews:(BOOL)skipHidden {
    NSMutableArray<UIView *> *views = [NSMutableArray new];
    for (UIWindow *window in TestLaunchUtility.allWindows) {
        // Don't include the explorer's own window or subviews.
        if (window != self.view.window && [window pointInside:tapPointInWindow withEvent:nil]) {
            [views addObject:window];
            [views addObjectsFromArray:[self
                recursiveSubviewsAtPoint:tapPointInWindow inView:window skipHiddenViews:skipHidden
            ]];
        }
    }
    return views;
}

- (UIView *)viewForSelectionAtPoint:(CGPoint)tapPointInWindow {
    // Select in the window that would handle the touch, but don't just use the result of
    // hitTest:withEvent: so we can still select views with interaction disabled.
    // Default to the the application's key window if none of the windows want the touch.
    UIWindow *windowForSelection = UIApplication.sharedApplication.keyWindow;
    for (UIWindow *window in TestLaunchUtility.allWindows.reverseObjectEnumerator) {
        // Ignore the explorer's own window.
        if (window != self.view.window) {
            if ([window hitTest:tapPointInWindow withEvent:nil]) {
                windowForSelection = window;
                break;
            }
        }
    }
    
    UIView *lastSubview = [self recursiveSubviewsAtPoint:tapPointInWindow inView:windowForSelection skipHiddenViews:YES].lastObject;
    NSLog(@"TestLaunchFramework: Selected view class is %@", [lastSubview class]);
    NSLog(@"TestLaunchFramework: Selected view is %@", lastSubview.debugDescription);
    
    if ([[lastSubview class] isSubclassOfClass:[UIControl class]]) {
        NSLog(@"some sort of control");
        
        UIControl *control = (UIControl *)lastSubview;
        NSSet *targs = [control allTargets];
        NSArray<NSString *> *actions = [control actionsForTarget:[targs anyObject] forControlEvent:UIControlEventTouchUpInside];

        [control sendActionsForControlEvents:UIControlEventTouchUpInside];
//        [[item target] performSelector:item.action];
    } else {
        [lastSubview simulateTap];
    }
    
    if (!_runningTest) {
        TestLaunchTap *tlTap = [[TestLaunchTap alloc] initWithTapPoint:tapPointInWindow];
        [_tlTaps addObject:tlTap];
    }
    /* Clear all the views */
//    [self removeAndClearOutlineViews];

    
    /* We play a trick on the user here, they think they are the ones tapping the view but we programatically do it*/
//    NSError *error;
//    [lastSubview tapAt:LocationCenter bypassSubviews:false error:&error];
    
    // Select the deepest visible view at the tap point. This generally corresponds to what the user wants to select.
    return lastSubview;
}



- (void)handleSelectionTap:(UITapGestureRecognizer *)tapGR {
    NSLog(@"attempting to handle tap");
    // Only if we're in selection mode
    // if (self.currentMode == FLEXExplorerModeSelect && tapGR.state == UIGestureRecognizerStateRecognized) {
    
    CGPoint point = [tapGR locationInView:self.view];
    if (CGRectContainsPoint(_recordButton.frame, point)) {//change it to your condition
        NSLog(@"Tapping on record button");
        [self recordButtonTapped: _recordButton];
        return;
    }
    
    if (CGRectContainsPoint(_runTestsButton.frame, point)) {//change it to your condition
        NSLog(@"Tapping on run tests button");
        [self runTests:_runTestsButton];
        return;
    }
    
    if (YES == _isRecording && tapGR.state == UIGestureRecognizerStateRecognized) {
        // Note that [tapGR locationInView:nil] is broken in iOS 8,
        // so we have to do a two step conversion to window coordinates.
        // Thanks to @lascorbe for finding this: https://github.com/Flipboard/FLEX/pull/31
        CGPoint tapPointInView = [tapGR locationInView:self.view];
        CGPoint tapPointInWindow = [self.view convertPoint:tapPointInView toView:nil];
        [self updateOutlineViewsForSelectionPoint:tapPointInWindow];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    // Disallow recognition of tap gestures in the segmented control.
    return YES;
}


- (void)updateOutlineViewsForSelectionPoint:(CGPoint)selectionPointInWindow {
    [self removeAndClearOutlineViews];
    
    // Include hidden views in the "viewsAtTapPoint" array so we can show them in the hierarchy list.
    self.viewsAtTapPoint = [self viewsAtPoint:selectionPointInWindow skipHiddenViews:NO];
    
    // For outlined views and the selected view, only use visible views.
    // Outlining hidden views adds clutter and makes the selection behavior confusing.
    NSArray<UIView *> *visibleViewsAtTapPoint = [self viewsAtPoint:selectionPointInWindow skipHiddenViews:YES];
    NSMutableDictionary<NSValue *, UIView *> *newOutlineViewsForVisibleViews = [NSMutableDictionary new];
    for (UIView *view in visibleViewsAtTapPoint) {
        UIView *outlineView = [self outlineViewForView:view];
        [self.view addSubview:outlineView];
        NSValue *key = [NSValue valueWithNonretainedObject:view];
        [newOutlineViewsForVisibleViews setObject:outlineView forKey:key];
    }
    self.outlineViewsForVisibleViews = newOutlineViewsForVisibleViews;
    self.selectedView = [self viewForSelectionAtPoint:selectionPointInWindow];
    
    // Make sure the explorer toolbar doesn't end up behind the newly added outline views.
//    [self.view bringSubviewToFront:self.explorerToolbar];
//
//    [self updateButtonStates];
}

- (UIView *)outlineViewForView:(UIView *)view {
    CGRect outlineFrame = [self frameInLocalCoordinatesForView:view];
    UIView *outlineView = [[UIView alloc] initWithFrame:outlineFrame];
    outlineView.backgroundColor = UIColor.clearColor;
    outlineView.layer.borderColor = [[UIColor cyanColor] CGColor];
    outlineView.layer.borderWidth = 1.0;
    return outlineView;
}

- (CGRect)frameInLocalCoordinatesForView:(UIView *)view {
    // Convert to window coordinates since the view may be in a different window than our view
    CGRect frameInWindow = [view convertRect:view.bounds toView:nil];
    // Convert from the window to our view's coordinate space
    return [self.view convertRect:frameInWindow fromView:nil];
}

// Clears all the outlines
- (void)removeAndClearOutlineViews {
    for (NSValue *key in self.outlineViewsForVisibleViews) {
        UIView *outlineView = self.outlineViewsForVisibleViews[key];
        [outlineView removeFromSuperview];
    }
    self.outlineViewsForVisibleViews = nil;
}

@end
