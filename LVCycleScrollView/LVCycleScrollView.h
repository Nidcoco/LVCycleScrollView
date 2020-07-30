//
//  LVCycleScrollView.h
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**
 滚动图片还是文字,文字不支持换行,水平滚动有换行符就省略换行符后面的;竖直滚动文字只支持单行显示,单行文字超出控件部分用省略号表示
 */
typedef enum {
    LVImageScroll,        // 图片/图片+底部文字只有水平滚动才显示底部文字
    LVOnlyTextScroll,     // 仅文字
}LVScrollType;

/**
 纯文字滚动样式
 */
typedef enum {
    LVTextScrollModeNone,   // 无样式,轮播模式
    LVTextScrollModeOne,    // 从控件内开始连续滚动
    LVTextScrollModeTwo,    // 从控件内开始间断滚动
    LVTextScrollModeThird,  // 从控件外开始滚动
    LVTextScrollModeFour,   // 往返滚动
}LVTextScrollMode;

/**
PageControl位置
*/
typedef enum {
    LVPageControlCenter,
    LVPageControlLeft,
    LVPageControlRight,
} LVPageControlAliment;

typedef enum {
    LVPageContolStyleClassic,        // 系统自带经典样式,大小形状固定,默认系统的大小7
    LVPageContolStyleCustom,         // 自定义pagecontrol,默认此样式,可以通过下面的属性定义缩放,旋转动画,也可以设置形状大小等等
} LVPageControlStyle;

@class LVCycleScrollView;

@protocol LVCycleScrollViewDelegate <NSObject>

@optional

/// 点击回调,文字滚动样式1和4回调都是0
- (void)cycleScrollView:(LVCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/// 滚动回调,文字滚动样式1和4回调都是0
- (void)cycleScrollView:(LVCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface LVCycleScrollView : UIView

/// 代理
@property (nonatomic, weak) id<LVCycleScrollViewDelegate> delegate;

/// block方式监听点击
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/// block方式监听滚动
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/// 图片数组
@property (nonatomic, strong) NSArray *imagesArray;

/// 文字数组,如果是图片+底部文字,文字数组数量为一则是全部图片底部文字都是第一个元素,不为一数量必须与图片数组数量保持一致,否则抛出异常
@property (nonatomic, strong) NSArray *titlesArray;

/// 是否自动滚动,默认Yes
@property (nonatomic,assign) BOOL autoScroll;

/// 是否无限循环,默认NO,只适用于图片滚动和无样式的文字滚动,有样式的文字滚动默认无限循环
@property (nonatomic,assign) BOOL infiniteLoop;

/// 图片滚动,点击cell是否滑动到该cell,默认NO
@property (nonatomic,assign) BOOL isTouchScrollToIndex;

/// 图片及无样式的纯文字滚动时间,由于是使用系统私有属性contentOffsetAnimationDuration设置的,不保证以后会不会crash或者会被苹果商店拒绝,若以后使用崩溃则不用或需要更新库,[UIView animateWithDuration:1.2 delay:0.02 options:UIViewAnimationCurveLinear animations:^{ [colorPaletteScrollView setContentOffset: offset ];}completion:^(BOOL finished){ NSLog(@"animate");} ];,由于单元格重用,滑动的时候,前面的cell在划入最左边会突然消失留白
@property (nonatomic, assign) CGFloat scrollTime;

/// 图片及无样式的纯文字滚动间隔时间,不包含滚动的时间,默认2s
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/// 有样式的纯文字滚动的速度,每多少秒移动一个像素,竖直滚动默认0.1,水平滚动默认0.02
@property (nonatomic, assign) CGFloat speed;

/// 手动拖拽是否最多滑动一页,默认NO
@property (nonatomic, assign) BOOL isScrollOnePage;

/// cell的圆角
@property (nonatomic, assign) CGFloat cellCornerRadius;

/// 两个cell的间隔,适用除图片滚动样式7外的图片滚动和无样式的文字滚动,图片样式7可以用属性radius,anglePerItem来改变两个cell的间隔
@property (nonatomic, assign) CGFloat space;

/// collectionView展示cell的数量,以最中间的cell开始和其两边的cell的数量加起来的数量,由于两边对称,所以数量为单数,如果设置为4,则展示3个,中间一个cell和两边各一个,数量必须为大于0,默认5
@property (nonatomic, assign) NSInteger visibleCount;


/**
 *  初始化
 *
 *  @param frame                                      view的frame,可先随便传,addsubView后面可用Masonry进行约束
 *  @param itemSize                               collectionView里面cell的大小
 *  @param scrollType                           滚动类型,包括图片,文字
 *  @param scrollDirection                滚动方式,包括水平,竖直滚动
 *  @return 返回
 */
- (instancetype)initWithFrame:(CGRect)frame
                     itemSize:(CGSize)itemSize
                   scrollType:(LVScrollType)scrollType
              scrollDirection:(UICollectionViewScrollDirection)scrollDirection;

/*--------------------------- 文字滚动属性 ----------------------------*/

/// 字体大小
@property (nonatomic, copy) UIFont  *textFont;

/// 字体颜色
@property (nonatomic, copy) UIColor * textColor;

/// 背景颜色
@property (nonatomic, strong) UIColor *textBackgroundColor;

/// 文字label的高度,只有在文字滚动类型是图片加底部文字才可以有效
@property (nonatomic, assign) CGFloat textLabelHeight;

/// 滚动文字样式
@property (nonatomic, assign) LVTextScrollMode textScrollMode;

@property (nonatomic, assign) NSTextAlignment textLabelTextAlignment;

/// 适用于图片底部文字和纯文字无样式
@property (nonatomic, assign) NSInteger textLabelNumberOfLines;

/*--------------------------- 图片滚动属性 ----------------------------*/

/// 占位图，用于网络未加载到图片时
@property (nonatomic, strong) UIImage *placeholderImage;

/// 缩放比,样式1,2,3,4中的缩放比例调节,默认是0.8
@property (nonatomic, assign) CGFloat zoomScale;

/// 样式5,6的旋转弧度,默认M_PI_4,也就是度数为45°
@property (nonatomic, assign) CGFloat rotationAngle;

/// 图片滚动的样式, 默认无样式
@property (nonatomic, assign) LVImageScrollType imageScrollType;

/// 轮播图的ContentMode
@property (nonatomic, assign) UIViewContentMode imageContentMode;

/// 轮播图样式7的半径,表示cell的中心到圆心的距离,默认500
@property (nonatomic, assign) CGFloat radius;

/// 轮播图样式7的夹角,表示两个cell的夹角,默认M_PI/12
@property (nonatomic, assign) CGFloat anglePerItem;

/// 是否显示分页控件,默认显示,不过只有是图片的水平滚动才支持显示,其他不显示
@property (nonatomic, assign) BOOL showPageControl;

/// 分页控件的样式
@property (nonatomic, assign) LVPageControlStyle pageControlStyle;

/// 分页控件位置,默认居中
@property (nonatomic, assign) LVPageControlAliment pageControlAliment;

/// 当前分页控件小圆标颜色,默认白色
@property (nonatomic, strong) UIColor *currentPageDotColor;

/// 其他分页控件小圆标颜色,默认灰色
@property (nonatomic, strong) UIColor *pageDotColor;

/// 分页控件距离轮播图的底部间距的偏移量,默认为10
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/// 分页控件距离轮播图左或右边间距的偏移量,具体看pageControlAliment的类型,当pageControlAliment为LVAlimentCenter,则大小为self的宽减去分页控件的宽除2,这时的大小不可改变,若为LVAlimentLeft,则表示距离左边距的偏移量,默认为10;反正也一样
@property (nonatomic, assign) CGFloat pageControlMarginOffset;

/*--------------------------- 自定义样式分页控件的缩放,旋转 ----------------------------*/
/// 分页控件自定义样式中当前点旋转的角度,默认为0不旋转,设置为M_PI_4就是正向滚动顺时针旋转45°,而逆向滚动时就会逆时针旋转45°,反之设置为-M_PI_4,就是正向滚动时逆时针旋转45°,而逆向滚动时就会顺时针旋转45°
@property (nonatomic, assign) CGFloat pageControlRotationAngle;

/// 分页控件自定义样式中小点的缩放功能,该属性表示当前点较其他点的大小,比如设置为2,就是当前点是其他点的两倍大小,默认为1
@property (nonatomic, assign) CGFloat pageControlZoomSize;

/*--------------------------- 自定义样式分页控件的其他属性,以下属性若不是自定义的样式分页控件不能使用,pageControlStyle为LVPageContolStyleCustom才能用----------------------------*/
/// 图标阴影颜色,默认透明
@property (nonatomic, strong) UIColor *pageControlBorderColor;

/// 图标阴影大小,默认为0
@property (nonatomic, assign) CGFloat pageControlBorderWidth;

/// 图标圆角,默认g宽高的一半,就是个圆的,想要看旋转效果设置为0,正方形的时候就能看到旋转的变化,宽高必须相等
@property (nonatomic, assign) CGFloat pageControlCornerRadius;

/// 分页控件小圆标大小,默认宽高8
@property (nonatomic, assign) CGSize pageControlDotSize;

/// 两点的间距,默认8
@property (nonatomic, assign) CGFloat spacingBetweenDots;

/// 当前分页控件小圆标透明度,默认1
@property (nonatomic, assign) CGFloat currentPageDotAlpha;

/// 其他分页控件小圆标透明度,默认1
@property (nonatomic, assign) CGFloat pageDotAlpha;

/// 当前分页控件小圆标图片,默认为空,如果设置优先显示,上面的7个自定义样式分页控件属性则无效,注意currentPageDotImage,pageDotImage必须同时为空或者同时不为空
@property (nonatomic, strong) UIImage *currentPageDotImage;

/// 其他分页控件小圆标图片,默认为空,如果设置优先显示,上面的7个自定义样式分页控件属性则无效
@property (nonatomic, strong) UIImage *pageDotImage;

/// 启动定时器
- (void)move;

/// 停止计时器
- (void)stop;

/// 滚动手势禁用,只适用于除图片滚动,无样式的文字滚动,因为有样式的图片滚动默认禁止手势
- (void)disableScrollGesture;

/// 可以调用此方法手动控制滚动到哪一个index
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
