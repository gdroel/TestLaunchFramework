//
//  TestLaunchExplorerViewController.m
//  TestLaunchFramework
//
//  Created by Gabe Roeloffs on 4/5/21.
//

#import "TestLaunchExplorerViewController.h"

@interface TestLaunchExplorerViewController ()

@end

@implementation TestLaunchExplorerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    recordButton.backgroundColor = [UIColor greenColor];
    
    [recordButton addTarget:self action:@selector(recordButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
}

- (void)recordButtonTapped:(UIButton*)sender {
    NSLog(@"record button tapped");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
