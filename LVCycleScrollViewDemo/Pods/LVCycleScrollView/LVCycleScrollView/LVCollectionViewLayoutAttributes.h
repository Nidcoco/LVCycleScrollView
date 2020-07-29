//
//  LVCollectionViewLayoutAttributes.h
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LVCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

/// 圆心
@property (nonatomic, assign) CGPoint anchorPoint;
/// 角度
@property (nonatomic, assign) CGFloat angle;

/// 竖直/水平滚动
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end

NS_ASSUME_NONNULL_END
