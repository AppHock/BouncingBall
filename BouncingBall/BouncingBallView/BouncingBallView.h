//
//  BouncingBallView.h
//  BouncingBall
//
//  Created by Hock on 2020/4/13.
//  Copyright © 2020 Hock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BouncingBallView : UIView

// 添加球
- (void)addBollWithView:(UIView *)boll;

// 速度
@property (nonatomic, assign) CGFloat speed;

// 距离屏幕边界
@property (nonatomic, assign) CGFloat border;

@end

NS_ASSUME_NONNULL_END
