//
//  CustomView.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import "CustomView.h"

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touches began");
    //your code
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    //your code
    NSLog(@"touches ended");
}


@end
