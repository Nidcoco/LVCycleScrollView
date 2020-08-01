//
//  LVCollectionViewLayout.h
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kImageSevenRadius 500.0

#define kZoomScale 0.8

#define kRotationAngle M_PI_4

#define kAnglePerItem M_PI/12

#define kVisibleCount 5

/**
图片滚动的样式
*/
typedef enum {
    LVImageScrollNone,
    LVImageScrollCardOne,
    LVImageScrollCardTwo,
    LVImageScrollCardThird,
    LVImageScrollCardFour,
    LVImageScrollCardFive,
    LVImageScrollCardSix,
    LVImageScrollCardSeven,
}LVImageScrollType;


@interface LVCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) LVImageScrollType scrollType;

/// 图片的大小
@property (nonatomic, assign) CGSize itemSize;

/// collectionView展示cell的数量,以最中间的cell开始和其两边的cell的数量加起来的数量,由于两边对称,所以数量为单数,如果设置为4,则展示3个,中间一个cell和两边各一个,数量必须为大于0,默认5
@property (nonatomic, assign) NSInteger visibleCount;

/// cell的间隔,默认为0,若是竖直滚动,cell的高不进行缩放,只缩放宽,则cell之间的上下间隔就是space,若对高进行缩放,则cell之间的上下间隔就是space+cell的高乘上高的缩放比例除2,也就是说,就算你space为0,cell的高缩放了,间隔也会改变;反之,若是水平滚动,cell的宽不进行缩放,只缩放高,则cell之间的左右间隔就是space,,若对宽进行缩放,则cell之间的左右间隔就是space+cell的宽乘上宽的缩放比例除2.
@property (nonatomic, assign) CGFloat space;

/// 竖直/水平滚动
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/// 当前页码（滑动前）
@property (nonatomic, strong) NSNumber *currentIndex;

/// 缩放比,样式1,2,3,4中的缩放比例调节,默认是0.8
@property (nonatomic, assign) CGFloat zoomScale;

/// 样式5,6的旋转弧度,默认M_PI_4,也就是度数为45°
@property (nonatomic, assign) CGFloat rotationAngle;

/// 样式7圆形半径
@property (nonatomic,assign) CGFloat radius;
/// 样式7每两个item之间的旋转角度
@property (nonatomic,assign) CGFloat anglePerItem;



@end

NS_ASSUME_NONNULL_END
