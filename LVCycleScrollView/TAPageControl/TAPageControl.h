//
//  TAPageControl.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-21.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TAPageControlDelegate;


@interface TAPageControl : UIControl


/**
 * Dot view customization properties
 */

/**
 *  The Class of your custom UIView, make sure to respect the TAAbstractDotView class.
 */
@property (nonatomic) Class dotViewClass;


/**
 *  UIImage to represent a dot.
 */
@property (nonatomic) UIImage *dotImage;


/**
 *  UIImage to represent current page dot.
 */
@property (nonatomic) UIImage *currentDotImage;


/**
 *  Dot size for dot views. Default is 8 by 8.
 */
@property (nonatomic) CGSize dotSize;


/**
 *  Spacing between two dot views. Default is 8.
 */
@property (nonatomic) NSInteger spacingBetweenDots;


/**
 * Page control setup properties
 */


/**
 * Delegate for TAPageControl
 */
@property(nonatomic,assign) id<TAPageControlDelegate> delegate;


/**
 *  Number of pages for control. Default is 0.
 */
@property (nonatomic) NSInteger numberOfPages;


/**
 *  Current page on which control is active. Default is 0.
 */
@property (nonatomic) NSInteger currentPage;


/**
 *  Hide the control if there is only one page. Default is NO.
 */
@property (nonatomic) BOOL hidesForSinglePage;


/**
 *  Let the control know if should grow bigger by keeping center, or just get longer (right side expanding). By default YES.
 */
@property (nonatomic) BOOL shouldResizeFromCenter;


/*--------------------------- 新增属性 ----------------------------*/
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

/**
 *  Return the minimum size required to display control properly for the given page count.
 *
 *  @param pageCount Number of dots that will require display
 *
 *  @return The CGSize being the minimum size required.
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;



@end


@protocol TAPageControlDelegate <NSObject>

@optional
- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end
