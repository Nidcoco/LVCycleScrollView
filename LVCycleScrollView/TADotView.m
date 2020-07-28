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
        currentPageDotColor:(UIColor *)currentPageDotColor
               pageDotColor:(UIColor *)pageDotColor
        currentPageDotAlpha:(CGFloat)currentPageDotAlpha pageDotAlpha:(CGFloat)pageDotAlpha
   pageControlRotationAngle:(CGFloat)pageControlRotationAngle
        pageControlZoomSize:(CGFloat)pageControlZoomSize
{
    self.currentPageDotColor = currentPageDotColor;
    self.pageDotColor = pageDotColor;
    self.currentPageDotAlpha = currentPageDotAlpha;
    self.pageDotAlpha = pageDotAlpha;
    self.pageControlRotationAngle = pageControlRotationAngle;
    self.pageControlZoomSize = pageControlZoomSize;
    [self changeActivityState:active];
}

// 当前
- (void)animateToActiveState
{
    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self.currentPageDotColor;
        self.alpha = self.currentPageDotAlpha;
        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(self.pageControlZoomSize, self.pageControlZoomSize), CGAffineTransformMakeRotation(self.pageControlRotationAngle)) ;
        
    } completion:nil];
}

// 其他
- (void)animateToDeactiveState
{
    self.transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self.pageDotColor;
        self.alpha = self.pageDotAlpha;
//        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - Setter & Getter

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor  = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    self.backgroundColor = pageDotColor;
}
//
//- (void)setPageDotAlpha:(CGFloat)pageDotAlpha
//{
//    _pageDotAlpha = pageDotAlpha;
//    self.alpha = pageDotAlpha;
//}



@end
