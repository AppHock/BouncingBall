//
//  BouncingBallView.m
//  BouncingBall
//
//  Created by Hock on 2020/4/13.
//  Copyright © 2020 Hock. All rights reserved.
//

#import "BouncingBallView.h"

@interface BouncingBallView() <UICollisionBehaviorDelegate>
{
    // 存储动画行为
    NSMutableArray *arrays;
}
//实现的动画
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
//动画行为
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;
//碰撞行为
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
//重力行为
@property (nonatomic, strong) UIGravityBehavior * gravityBehavior;
//推力行为
@property (nonatomic, strong) UIPushBehavior * pushBehavior;

@end
@implementation BouncingBallView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initViewsInSelf];
    }
    return self;
}
- (void)initViewsInSelf
{
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    
    //碰撞
    _collisionBehavior = [[UICollisionBehavior alloc] init];
    _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    _collisionBehavior.collisionDelegate = self;

    [_dynamicAnimator addBehavior:_collisionBehavior];
    
    arrays = [NSMutableArray array];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    int d_x = [self getRandomNumber:-10 to:10];
    int d_y = [self getRandomNumber:-10 to:10];
    
    int x = arc4random() % (int)self.bounds.size.width;
    int y = arc4random() % (int)self.bounds.size.height;
    
    int size = 50;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, size, size)];

    imageView.image = [UIImage imageNamed:@"篮球"];
    imageView.tag = 100+arrays.count;
    [self addSubview:imageView];
    
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] init];
    
    // 摩擦系数
    dynamicItemBehavior.friction = 0;
    // 是否固定
    dynamicItemBehavior.anchored = NO;
    // 旋转
    dynamicItemBehavior.allowsRotation = NO;
    // 弹力系数
    dynamicItemBehavior.elasticity = 0;
    // 线速度阻尼
    dynamicItemBehavior.resistance = 0;
    // 角速度阻尼
    dynamicItemBehavior.angularResistance = 0;
    // 密度
    dynamicItemBehavior.density = 1;
    // 添加动画
    [_dynamicAnimator addBehavior:dynamicItemBehavior];
    
    // view添加弹力
    [_collisionBehavior addItem:imageView];
    // view添加物理属性
    [dynamicItemBehavior addItem:imageView];
    
    // 设置线速度
    [dynamicItemBehavior addLinearVelocity:CGPointMake(30, 30) forItem:imageView];
    // 设置角速度
    [dynamicItemBehavior addAngularVelocity:1 forItem:imageView];
    
    NSDictionary *dict = @{@"x":@(d_x), @"y":@(d_y), @"itemBehavior":dynamicItemBehavior};
    [arrays addObject:dict];
}

// 开始接触屏幕边界
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(nonnull id<UIDynamicItem>)item withBoundaryIdentifier:(nullable id<NSCopying>)identifier atPoint:(CGPoint)p {
     UIImageView *imageView = (UIImageView *)item;
       if (imageView.tag - 100 + 1 > arrays.count) {
           return;
       }
       NSDictionary *dict = arrays[imageView.tag - 100];
       CGFloat d_x = [[dict objectForKey:@"x"] floatValue];
       CGFloat d_y = [[dict objectForKey:@"y"] floatValue];
       UIDynamicItemBehavior *dynamicItemBehavior = (UIDynamicItemBehavior *)[dict objectForKey:@"itemBehavior"];
       
       [dynamicItemBehavior addLinearVelocity:CGPointMake(-d_x, -d_y) forItem:imageView];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier {
    
}


// 取区间范围内值
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}


@end
