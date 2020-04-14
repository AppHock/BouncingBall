//
//  BouncingBallView.m
//  BouncingBall
//
//  Created by Hock on 2020/4/13.
//  Copyright © 2020 Hock. All rights reserved.
//

#import "BouncingBallView.h"

#define tagNum 100

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
    /*
     UICollisionBehaviorModeItems     ：气泡间碰撞，无边界碰撞
     UICollisionBehaviorModeBoundaries：气泡间无相互碰撞，气泡与边界碰撞
     UICollisionBehaviorModeEverything：气泡间和边界都相互碰撞
     */
    _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    
    /*translatesReferenceBoundsIntoBoundary=YES，保证气泡不会消失*/
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    _collisionBehavior.collisionDelegate = self;

    [_dynamicAnimator addBehavior:_collisionBehavior];
    
    arrays = [NSMutableArray array];
    
    // normal value
    self.speed = 30;
    self.border = 0;
}

// 开始接触屏幕边界
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(nonnull id<UIDynamicItem>)item withBoundaryIdentifier:(nullable id<NSCopying>)identifier atPoint:(CGPoint)p {
    UIView *view = (UIView *)item;
    if (view.tag - tagNum + 1 > arrays.count) {
        return;
    }
    
    NSDictionary *dict = arrays[view.tag - tagNum];
    
    UIDynamicItemBehavior *dynamicItemBehavior = (UIDynamicItemBehavior *)[dict objectForKey:@"itemBehavior"];
    
    CGPoint currentPoint = [dynamicItemBehavior linearVelocityForItem:item];
    
    CGFloat d_x = currentPoint.x;
    CGFloat d_y = currentPoint.y;
    
    CGFloat screen_height = self.frame.size.height;
    CGFloat screen_width = self.frame.size.width;

    // self.border+1:(p的x或者y有小数位，p会大于self.border，必须self.border+1)
    if (screen_height-p.y < self.border+1) {
        d_y = -self.speed;
    } else if (p.y < self.border+1) {
        d_y = self.speed;
    } else {
        d_y = 0;
    }
    
    if (screen_width-p.x < self.border+1) {
        d_x = -self.speed;
    } else if (p.x < self.border+1) {
        d_x = self.speed;
    } else {
        d_x = 0;
    }
    
    [dynamicItemBehavior addLinearVelocity:CGPointMake(d_x, d_y) forItem:view];
    
    NSDictionary *newDict = @{@"x":@(d_x), @"y":@(d_y), @"itemBehavior":dynamicItemBehavior};
    [arrays replaceObjectAtIndex:view.tag - tagNum withObject:newDict];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier {
    
}

- (void)setBorder:(CGFloat)border {
    _border = border;
    [_collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(self.border, self.border, self.border, self.border)];
}

#pragma mark --- public methods
// 添加球
- (void)addBollWithView:(UIView *)boll {
    int d_x = [self getRandomNumber:-1 to:1] * self.speed;
    int d_y = [self getRandomNumber:-1 to:1] * self.speed;
    
    int x = (arc4random() % (int)self.bounds.size.width)*0.8;
    int y = (arc4random() % (int)self.bounds.size.height)*0.8;

    CGRect bollFrame = boll.frame;
    bollFrame.origin.x = x;
    bollFrame.origin.y = y;
    boll.frame = bollFrame;
    
    boll.tag = tagNum+arrays.count;
    [self addSubview:boll];
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] init];
       
    // 摩擦系数
    dynamicItemBehavior.friction = 0;
    // 是否固定
    dynamicItemBehavior.anchored = NO;
    // 旋转
    dynamicItemBehavior.allowsRotation = NO;
    // 弹力系数
    dynamicItemBehavior.elasticity = 1;
    // 线速度阻尼
    dynamicItemBehavior.resistance = 0;
    // 角速度阻尼
    dynamicItemBehavior.angularResistance = 0;
    // 密度
    dynamicItemBehavior.density = 1;
    // 添加动画
    [_dynamicAnimator addBehavior:dynamicItemBehavior];
    
    // view添加弹力
    [_collisionBehavior addItem:boll];
    // view添加物理属性
    [dynamicItemBehavior addItem:boll];
    
    // 设置线速度
    [dynamicItemBehavior addLinearVelocity:CGPointMake(d_x, d_y) forItem:boll];
    // 设置角速度
    //    [dynamicItemBehavior addAngularVelocity:1 forItem:boll];
        
    NSDictionary *dict = @{@"x":@(d_x), @"y":@(d_y), @"itemBehavior":dynamicItemBehavior};
    [arrays addObject:dict];
}

#pragma mark --- private methods
// 取区间范围内值
-(int)getRandomNumber:(int)from to:(int)to
{
    int num = (from + (arc4random() % (to - from + 1)));
    if (num == -1) {
        NSLog(@"ww");
    }
    while (num != 0) {
        return num;
    }
    return [self getRandomNumber:from to:to];
}


@end
