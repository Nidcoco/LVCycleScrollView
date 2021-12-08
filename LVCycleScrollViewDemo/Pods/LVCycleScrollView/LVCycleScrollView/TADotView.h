//
//  TADotView.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TADotView : UIView

/**
 * 图标圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 * 旋转角度
 */
@property (nonatomic, assign) CGFloat pointRotationAngle;

/**
 * 缩放大小
 */
@property (nonatomic, assign) CGFloat pointZoomSize;


/**
 * @param pointRotationAngle           旋转角度
 * @param pointZoomSize                缩放大小
 */
- (void)changeActivityState:(BOOL)active
         pointRotationAngle:(CGFloat)pointRotationAngle
              pointZoomSize:(CGFloat)pointZoomSize;

@end
