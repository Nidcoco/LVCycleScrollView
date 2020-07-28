//
//  TADotView.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAAbstractDotView.h"

@interface TADotView : TAAbstractDotView

/**
 * 图标阴影颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 * 图标阴影大小
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 图标圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 * 当前分页控件小圆标颜色,默认白色
 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/**
 * 其他分页控件小圆标颜色,默认灰色
 */
@property (nonatomic, strong) UIColor *pageDotColor;

/**
 * 当前分页控件小圆标透明度,默认1
 */
@property (nonatomic, assign) CGFloat currentPageDotAlpha;

/**
 * 其他分页控件小圆标透明度,默认1
 */
@property (nonatomic, assign) CGFloat pageDotAlpha;

/**
 * 旋转角度
 */
@property (nonatomic, assign) CGFloat pageControlRotationAngle;

/**
 * 缩放大小
 */
@property (nonatomic, assign) CGFloat pageControlZoomSize;



@end
