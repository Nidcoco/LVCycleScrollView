//
//  TADotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TADotView.h"

static CGFloat const kAnimateDuration = 1;

@implementation TADotView

- (void)changeActivityState:(BOOL)active
{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}

- (void)changeActivityState:(BOOL)active
         pointRotationAngle:(CGFloat)pointRotationAngle
              pointZoomSize:(CGFloat)pointZoomSize
{
    self.pointRotationAngle = pointRotationAngle;
    self.pointZoomSize = pointZoomSize;
    [self changeActivityState:active];
}

// 当前
- (void)animateToActiveState
{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(self.pointZoomSize, self.pointZoomSize), CGAffineTransformMakeRotation(self.pointRotationAngle));
    } completion:nil];
}

// 其他
- (void)animateToDeactiveState
{
    self.transform = CGAffineTransformIdentity;
}

#pragma mark - Setter & Getter


- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}


@end
