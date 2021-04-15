//
//  ViewController.m
//  TLTestApp
//
//  Created by Gabe Roeloffs on 4/14/21.
//

#import "ViewController.h"
#import "UIView+Synthesis.h"
#import "CustomView.h"

@interface ViewController ()

@property UIButton *button;
@property CustomView *customView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _button = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
    _button.backgroundColor = [UIColor redColor];
    [_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
//     _customView = [[CustomView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    _customView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_customView];
//
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 2.0
                          target: self
                          selector:@selector(onTick:)
                          userInfo: nil repeats:YES];
        
//    UIView *invisibleView = [[UIView alloc] initWithFrame:self.view.bounds];
//    invisibleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [invisibleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHit:)]];
//    [self.view addSubview:invisibleView];
}

- (void)onTick:(NSObject *)sender {
//    NSLog(@"tick");
    [_button simulateTap];
}

-(void)tapHit:(UITapGestureRecognizer*)tap {
    NSLog( @"tapHit" );
}

- (void)buttonTapped:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0]];

    NSLog(@"button tapped");
}


@end