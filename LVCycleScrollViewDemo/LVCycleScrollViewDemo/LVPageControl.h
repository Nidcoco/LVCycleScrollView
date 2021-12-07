//
//  LVPageControl.h
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2021/12/6.
//  Copyright © 2021 None. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVPageControl : UIView

///< 页码数
@property (nonatomic, assign) int numberOfPages;
///< 其他点颜色
@property (nonatomic, strong) UIColor *otherDotColor;
///< 当前点颜色
@property (nonatomic, strong) UIColor *currentDotColor;
///< 圆角
@property (nonatomic, assign) CGFloat cornerRadius;
///< 当前点宽度
@property (nonatomic, assign) CGFloat currentDotWidth;
///< 其他点宽度
@property (nonatomic, assign) CGFloat otherDotWidth;
///< 点高度
@property (nonatomic, assign) CGFloat dotHeight;
///< 点间隔
@property (nonatomic, assign) CGFloat dotSpace;

- (void)moveCurrentViewWithX:(CGFloat)offsetX;

@end

NS_ASSUME_NONNULL_END
