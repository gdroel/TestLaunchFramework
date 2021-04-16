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

@interface TestLaunchExplorerViewController ()

@property (nonatomic) UIButton *recordButton;

/// The actual views at the selection point with the deepest view last.
@property (nonatomic) NSArray<UIView *> *viewsAtTapPoint;

@property (nonatomic) NSDictionary<NSValue *, UIView *> *outlineViewsForVisibleViews;

@property (nonatomic) UIView *selectedView;

@property (nonatomic) NSMutableArray<NSValue *> *tapPoints;

@end

@implementation TestLaunchExplorerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    CGFloat recordButtonWidth = 80;
    CGFloat recordButtonHeight = 20;

    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - recordButtonWidth) / 2, 30, recordButtonWidth, recordButtonHeight)];
    _recordButton.backgroundColor = [UIColor greenColor];
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [_recordButton addTarget:self action:@selector(recordButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
    
    UITapGestureRecognizer *selectionTapGR = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(handleSelectionTap:)
    ];
    
    [self.view addGestureRecognizer:selectionTapGR];
}

- (void)recordButtonTapped:(UIButton*)sender {
    NSLog(@"record button tapped");
}

/* Handles touches */

- (BOOL)shouldReceiveTouchAtWindowPoint:(CGPoint)pointInWindowCoordinates {
    
    return TL_ENABLED;
    
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

    /* Clear all the views */
//    [self removeAndClearOutlineViews];

    
    /* We play a trick on the user here, they think they are the ones tapping the view but we programatically do it*/
//    NSError *error;
//    [lastSubview tapAt:LocationCenter bypassSubviews:false error:&error];
    
    // Select the deepest visible view at the tap point. This generally corresponds to what the user wants to select.
    return lastSubview;
}

- (void)handleSelectionTap:(UITapGestureRecognizer *)tapGR {
    // Only if we're in selection mode
    // if (self.currentMode == FLEXExplorerModeSelect && tapGR.state == UIGestureRecognizerStateRecognized) {
    if (tapGR.state == UIGestureRecognizerStateRecognized) {
        // Note that [tapGR locationInView:nil] is broken in iOS 8,
        // so we have to do a two step conversion to window coordinates.
        // Thanks to @lascorbe for finding this: https://github.com/Flipboard/FLEX/pull/31
        CGPoint tapPointInView = [tapGR locationInView:self.view];
        CGPoint tapPointInWindow = [self.view convertPoint:tapPointInView toView:nil];
        [self updateOutlineViewsForSelectionPoint:tapPointInWindow];
    }
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
