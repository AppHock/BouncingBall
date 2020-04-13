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
{
    BouncingBallView *bbView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bbView = [[BouncingBallView alloc] initWithFrame:self.view.frame];
    bbView.speed = 30;
    bbView.border = 0;
    [self.view addSubview:bbView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat imageW = 50;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageW)];
    imageView.image = [UIImage imageNamed:@"篮球"];
    [bbView addBollWithView:imageView];
    
}


@end
