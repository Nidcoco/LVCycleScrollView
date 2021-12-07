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

///**
// 滚动图片还是文字,文字不支持换行,水平滚动有换行符就省略换行符后面的;竖直滚动文字只支持单行显示,单行文字超出控件部分用省略号表示
// */



/**
PageControl位置
*/
typedef enum {
    LVPageControlCenter,
    LVPageControlLeft,
    LVPageControlRight,
} LVPageControlAliment;


@class LVCycleScrollView;

@protocol LVCycleScrollViewDelegate <NSObject>

@optional

/// 点击回调,
- (void)cycleScrollView:(LVCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/// 滚动回调
- (void)cycleScrollViewDidScroll:(UIScrollView *)scrollView;

/// 滚动回调, 滑动到一半就触发回调, 自己添加分页控件, 赋值页码可以用此回调, 用didScrollToIndex是滚动到下一页才触发回调
- (void)cycleScrollView:(LVCycleScrollView *)cycleScrollView willDidScrollToIndex:(NSInteger)index;

/// 滚动到下一页回调
- (void)cycleScrollView:(LVCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface LVCycleScrollView : UIView

/// 代理
@property (nonatomic, weak) id<LVCycleScrollViewDelegate> delegate;

/// block方式监听点击
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/// block方式监听滚动
@property (nonatomic, copy) void (^itemWillDidScrollOperationBlock)(NSInteger currentIndex);

/// block方式监听滚动
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/// 页码, 注意这个页码如果开启了无限轮播不同于上面代理或block方法里面的那个页码
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/// 图片数组,空则滚动文字,文字数组为空那就是一个空view, 如果是带文字的图片轮播, 推荐先设置imagesArray
@property (nonatomic, strong) NSArray *imagesArray;

/// 底部文字数组,空则隐藏文字
@property (nonatomic, strong) NSArray *titlesArray;

/// 是否自动滚动,默认Yes
@property (nonatomic, assign) BOOL autoScroll;

/// 是否无限循环,默认NO
@property (nonatomic, assign) BOOL infiniteLoop;

/// collectionView里面cell的大小, 默认控件的大小
@property (nonatomic, assign) CGSize itemSize;

/// 滚动方式,包括水平,竖直滚动, 默认水平滚动
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/// 图片滚动,点击cell是否滑动到该cell,默认NO
@property (nonatomic, assign) BOOL isTouchScrollToIndex;

/// 滚动时间,由于是使用系统私有属性contentOffsetAnimationDuration设置的,不保证以后会不会crash或者会被苹果商店拒绝,若以后使用崩溃则不用或需要更新库,如果用[UIView animateWithDuration:1.2 delay:0.02 options:UIViewAnimationCurveLinear animations:^{ [colorPaletteScrollView setContentOffset: offset ];}completion:^(BOOL finished){ NSLog(@"animate");} ];,由于单元格重用,滑动的时候,前面的cell在划入最左边会突然消失留白
@property (nonatomic, assign) CGFloat scrollTime;

/// 滚动间隔时间,不包含滚动的时间,默认2s
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/// 手动拖拽是否最多滑动一页,默认NO
@property (nonatomic, assign) BOOL isScrollOnePage;

/// cell的圆角
@property (nonatomic, assign) CGFloat cellCornerRadius;

/// 两个cell的间隔,适用除图片滚动样式7外的图片滚动和文字滚动,图片样式7可以用属性radius,anglePerItem来改变两个cell的间隔
@property (nonatomic, assign) CGFloat space;

/// collectionView展示cell的数量,以最中间的cell开始和其两边的cell的数量加起来的数量,由于两边对称,所以数量为单数,如果设置为4,则展示3个,中间一个cell和两边各一个,数量必须为大于0,默认5
@property (nonatomic, assign) NSInteger visibleCount;



/*--------------------------- 文字滚动属性 ----------------------------*/

/// 字体大小, 默认大小13
@property (nonatomic, copy) UIFont  *textFont;

/// 字体颜色
@property (nonatomic, copy) UIColor * textColor;

/// 背景颜色
@property (nonatomic, strong) UIColor *textBackgroundColor;

/// 文字label的高度, 要有图片和文字同时存在才有效, 只有文字, label的高度就是view的高度
@property (nonatomic, assign) CGFloat textLabelHeight;

@property (nonatomic, assign) NSTextAlignment textLabelTextAlignment;

/// 文字label最大行数
@property (nonatomic, assign) NSInteger textLabelNumberOfLines;

/*--------------------------- 图片滚动属性 ----------------------------*/

/// 占位图，用于网络未加载到图片时
@property (nonatomic, strong) UIImage *placeholderImage;

/// 缩放比,图片样式1,2,3,4中的缩放比例调节,默认是0.8
@property (nonatomic, assign) CGFloat zoomScale;

/// 图片样式5,6的旋转弧度,默认M_PI_4,也就是度数为45°
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

/// 分页控件位置,默认居中
@property (nonatomic, assign) LVPageControlAliment pageControlAliment;

/// 当前分页控件小圆标颜色,默认白色
@property (nonatomic, strong) UIColor *currentPointDotColor;

/// 其他分页控件小圆标颜色,默认灰色
@property (nonatomic, strong) UIColor *pointDotColor;

/// 分页控件距离轮播图的底部间距的偏移量,默认为10
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/// 分页控件距离轮播图左或右边间距的偏移量,具体看pageControlAliment的类型,当pageControlAliment为LVAlimentCenter,则大小为self的宽减去分页控件的宽除2,这时的大小不可改变,若为LVAlimentLeft,则表示距离左边距的偏移量,默认为10;反正也一样
@property (nonatomic, assign) CGFloat pageControlMarginOffset;

/// 以下属性若不是自定义的样式分页控件不能使用,pageControlStyle为LVPageContolStyleCustom才能用
/*--------------------------- 自定义样式分页控件的缩放,旋转 ----------------------------*/
/// 分页控件自定义样式中当前点旋转的角度,默认为0不旋转,设置为M_PI_4就是正向滚动顺时针旋转45°,而逆向滚动时就会逆时针旋转45°,反之设置为-M_PI_4,就是正向滚动时逆时针旋转45°,而逆向滚动时就会顺时针旋转45°,如果分页控件是小圆点看不出旋转变化
@property (nonatomic, assign) CGFloat pointRotationAngle;

/// 分页控件自定义样式中小点的缩放功能,该属性表示当前点较其他点的大小,比如设置为2,就是当前点是其他点的两倍大小,默认为1
@property (nonatomic, assign) CGFloat pointZoomSize;

/*--------------------------- 自定义样式分页控件的其他属性----------------------------*/

/// 图标圆角,默认分页控件宽度的一半, 若设置了currentPointDotImage或pointDotImage,默认0
@property (nonatomic, assign) CGFloat pointCornerRadius;

/// 分页控件小圆标大小,默认宽高8
@property (nonatomic, assign) CGSize pointDotSize;

/// 两点的间距,默认8
@property (nonatomic, assign) CGFloat spacingBetweenDots;

/// 当前分页控件小圆标透明度,默认1
@property (nonatomic, assign) CGFloat currentPointDotAlpha;

/// 其他分页控件小圆标透明度,默认1
@property (nonatomic, assign) CGFloat pointDotAlpha;

/// 当前分页控件小圆标图片,默认为空,如果设置优先显示,上面的7个自定义样式分页控件属性则无效,注意currentPageDotImage,pageDotImage必须同时为空或者同时不为空
@property (nonatomic, strong) UIImage *currentPointDotImage;

/// 其他分页控件小圆标图片,默认为空,如果设置优先显示,上面的7个自定义样式分页控件属性则无效
@property (nonatomic, strong) UIImage *pointDotImage;

/// 暂停滚动,调用GCD定时器的dispatch_source_cancel,如果用dispatch_suspend只是暂停一个队列,并不意味着暂停当前正在执行的block,而是block可以执行完，但是接下来的block才会被暂停,这会轮播频率错误
- (void)stop;

/// 继续滚动,既然暂停用的是dispatch_source_cancel,继续滚动就是重新创建定时器
- (void)move;

/// 滚动手势禁用,只适用于除图片滚动,无样式的文字滚动,因为有样式的图片滚动默认禁止手势
- (void)disableScrollGesture;

/// 可以调用此方法手动控制滚动到哪一个index
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
