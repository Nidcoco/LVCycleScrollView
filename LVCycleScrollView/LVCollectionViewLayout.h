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

#define kVisibleCount 4

/**
图片滚动的样式
*/
typedef enum {
    LVImageScrollNone,      // 普通,无滚动特效
    LVImageScrollCardOne,   // 卡片样式1,随滑动缩放的特效,默认两个cell间缩放比80%,以cell的中心缩放,可通过zoomScale改变缩放比
    LVImageScrollCardTwo,   // 卡片样式2,随滑动缩放的特效,默认两个cell间缩放比80%,只缩小80%宽度或高度,不过每个cell的间隔相同,默认为0,可通过space属性修改间隔
    LVImageScrollCardThird, // 卡片样式3,随滑动缩放的特效,默认两个cell间缩放比80%,只缩小80%宽度或高度,中间为原始宽度度或高度,中心不变
    LVImageScrollCardFour,  // 卡片样式4,随滑动缩放的特效,默认两个cell间缩放比80%,只缩小80%宽度或高度,中间为原始宽度度或高度,底部或左边对齐中间的cell
    LVImageScrollCardFive,  // 卡片样式5,以cell为中心旋转,默认两个cell之间旋转度数为45°,也就是M_PI_4
    LVImageScrollCardSix,   // 卡片样式6,三维特效,随滑动图片绕x轴旋转特效,默认旋转最大度数45°,也就是M_PI_4
    LVImageScrollCardSeven, // 卡片样式7,圆形旋转,随滑动绕collectionView外的某点旋转,这个点就是瞄点,位置为anchorPoint;cell的center到这个点的连线到相邻cell的center到这个点连线的夹角angle
}LVImageScrollType;


@interface LVCollectionViewLayout : UICollectionViewLayout

- (instancetype)initWithImageScrollType:(LVImageScrollType)scrollType;

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
