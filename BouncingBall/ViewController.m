//
//  ViewController.m
//  BouncingBall
//
//  Created by Hock on 2020/4/13.
//  Copyright © 2020 Hock. All rights reserved.
//

#import "ViewController.h"
#import "BouncingBallView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BouncingBallView * bbView = [[BouncingBallView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:bbView];
}


@end
