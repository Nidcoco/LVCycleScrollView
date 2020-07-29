//
//  TAAbstractDotView.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TAAbstractDotView : UIView


/**
 *  A method call let view know which state appearance it should take. Active meaning it's current page. Inactive not the current page.
 *
 *  @param active BOOL to tell if view is active or not
 */
//- (void)changeActivityState:(BOOL)active;


/**
 * 新增方法, 用来设置颜色
 * @param currentPageDotColor               当前小点的颜色
 * @param pageDotColor                               其他小点的颜色
 * @param currentPageDotAlpha               当前小点的透明度
 * @param pageDotAlpha                               其他小点的透明度
 * @param pageControlRotationAngle    旋转角度
 * @param pageControlZoomSize               缩放大小
 */
- (void)changeActivityState:(BOOL)active
        currentPageDotColor:(UIColor *)currentPageDotColor
               pageDotColor:(UIColor *)pageDotColor
        currentPageDotAlpha:(CGFloat)currentPageDotAlpha
               pageDotAlpha:(CGFloat)pageDotAlpha
   pageControlRotationAngle:(CGFloat)pageControlRotationAngle
        pageControlZoomSize:(CGFloat)pageControlZoomSize;

@end

