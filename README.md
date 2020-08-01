LVCycleScrollView
================

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/LVCycleScrollView/master/LICENSE)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/LVCycleScrollView.svg?style=flat)](http://cocoapods.org/pods/LVCycleScrollView)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/LVCycleScrollView.svg?style=flat)](http://cocoadocs.org/docsets/LVCycleScrollView)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYText.svg?branch=master)](https://travis-ci.org/ibireme/YYText)

介绍
==============
这是一个图片及文字自动轮播的控件,由于本人是个的小菜鸟,所以这个依赖库都是看别人的,主体代码是参考[SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView),图片滚轮样式是参考这篇博客[UICollectionView自定义布局](https://juejin.im/post/5a320ea36fb9a0452405d8bb),文字水平滚动是参考[LMJHorizontalScrollText](https://github.com/JerryLMJ/LMJHorizontalScrollText),自定义的UICollectionViewLayout是跟[HJCarouselDemo](https://github.com/panghaijiao/HJCarouselDemo)学习的,本人现阶段能力有限,代码比较混乱,累赘,看不惯的兄弟可以使用上面的`SDCycleScrollView`

控件整体是由一个UICollectionView组成,由于是自定义的UICollectionViewLayout,所以形成了各种滚动的样式,而文字的滚动除了无样式的是滚动的是整个cell,其他只是在第0个cell定时修改文字label的x或y来改变文字的位置,以达到文字好像在滚动的效果

安装
==============
##使用CocoaPods安装
```
pod 'LVCycleScrollView'
```

##手动安装
直接拉取代码,把`LVCycleScrollView`文件夹拉到项目工程即可

用法
==============
将头文件导入到您希望使用该控件的任何类中
```
#import "LVCycleScrollView.h"
```

滚动类型
==============
* LVImageScroll:图片或者图片+底部文字只有水平滚动才显示底部文字
* LVOnlyTextScroll:仅文字

滚动方向
==============
* 水平滚动
* 竖直滚动


唯一初始化方法
==============
```
/**
 *  初始化
 *
 *  @param frame            view的frame,可先随便传,addsubView后面可用Masonry进行约束
 *  @param itemSize         collectionView里面cell的大小
 *  @param scrollType       滚动类型,包括图片,文字
 *  @param scrollDirection  滚动方式,包括水平,竖直滚动
 *  @return 返回
 */
- (instancetype)initWithFrame:(CGRect)frame
                     itemSize:(CGSize)itemSize
                   scrollType:(LVScrollType)scrollType
              scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
```
### 图片轮播
```
LVCycleScrollView *view = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, 200)
                                                           itemSize:CGSizeMake(self.view.frame.size.width, 200)
                                                         scrollType:LVImageScroll
                                                    scrollDirection:UICollectionViewScrollDirectionHorizontal];
view.imagesArray = @[@"1",@"2",@"3",@"4"];
[self.view addSubview:view];
```
![](https://upload-images.jianshu.io/upload_images/12618366-5a477e2f55453934.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
> 这里图片数组可以传网络路径,本地图片名字,NSURL类型,UIImage类型

### 图片+底部文字
```
LVCycleScrollView *view = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 200 + 10, self.view.frame.size.width, 200)
                                                          itemSize:CGSizeMake(self.view.frame.size.width, 200)
                                                        scrollType:LVImageScroll
                                                    scrollDirection:UICollectionViewScrollDirectionHorizontal];
view.imagesArray = @[@"1",@"2",@"3",@"4"];
view.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
view.pageControlAliment = LVPageControlRight;
[self.view addSubview:view];
```
![](https://upload-images.jianshu.io/upload_images/12618366-f99fbd1364938c24.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 文字轮播

```
LVCycleScrollView *view = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 10, self.view.frame.size.width, 40)
                                                          itemSize:CGSizeMake(self.view.frame.size.width, 40)
                                                        scrollType:LVOnlyTextScroll
                                                   scrollDirection:UICollectionViewScrollDirectionHorizontal];
view.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
view.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
[self.view addSubview:view];
```

![](https://upload-images.jianshu.io/upload_images/12618366-8b7b88d3a63443a9.gif?imageMogr2/auto-orient/strip)

属性
==============
```
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
```

图片滚动样式
==============
* LVImageScrollNone:普通,无滚动特效
* LVImageScrollCardOne:样式1,随滑动缩放的特效,控件中间的cell宽高度不变,两侧的cell缩放,默认两个cell间缩放比80%,以cell的中心进行缩放,可通过属性zoomScale改变缩放比
* LVImageScrollCardTwo:样式2,随滑动缩放的特效,控件中间的cell宽高度不变,中间两侧的cell缩放,默认两个cell间缩放比80%,水平滚动缩小高度,竖直滚动缩小宽度,不过每个cell的间隔相同,默认为0,可通过space属性修改间隔,zoomScale改变缩放比
* LVImageScrollCardThird:样式3,随滑动缩放的特效,控件中间的cell宽高度不变,两侧的cell的宽高都一样,水平滚动缩小高度,竖直滚动缩小宽度,可通过space属性修改间隔,zoomScale改变缩放比
* LVImageScrollCardFour:样式4,随滑动缩放的特效,控件中间的cell宽高度不变,两侧的cell的宽高都一样,水平滚动缩小高度,竖直滚动缩小宽度,和样式3不同的是底部或左边对齐控件中间的cell,即控件中间两侧cell的center和控件中间的cell的center不一样,美团选电影票的页面和这个类似,可通过space属性修改间隔,zoomScale改变缩放比
* LVImageScrollCardFive:样式5,随滑动旋转的特效,以cell为中心旋转,控件中间的cell角度不变,默认两个cell之间旋转度数为M_PI_4,也就是45°,可通过space属性修改间隔,rotationAngle改变旋转角度,rotationAngle正负值会影响角度
* LVImageScrollCardSix:样式6,三维特效,随滑动图片绕x轴旋转特效,默认旋转的度数M_PI_4,也就是45°,可通过space属性修改间隔,rotationAngle改变旋转角度,rotationAngle正负值会影响角度
* LVImageScrollCardSeven:样式7,轮盘旋转,随滑动绕控件外外的某点旋转,这个点就是瞄点,位置为anchorPoint,cell的center到这个点的连线是半径,默认500,可通过radius属性修改,半径的夹角是angle,默认M_PI/12,也就是45°

图片滚动样式效果展示
==============
|水平效果|竖直效果|样式|
|:---:|:---:|:---:|
|![](https://upload-images.jianshu.io/upload_images/12618366-dc16ef09cd6eec7f.gif?imageMogr2/auto-orient/strip)|![](https://upload-images.jianshu.io/upload_images/12618366-c2082c2c9a35ea45.gif?imageMogr2/auto-orient/strip)|无样式|
|![](https://upload-images.jianshu.io/upload_images/12618366-4b046da4ecc15a49.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![](https://upload-images.jianshu.io/upload_images/12618366-1c318291f8a4eb86.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|![](https://upload-images.jianshu.io/upload_images/12618366-30e7e524d071a301.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|样式1|
|![](https://upload-images.jianshu.io/upload_images/12618366-69abff4c347aec07.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![](https://upload-images.jianshu.io/upload_images/12618366-c74deec036694b31.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![添加30像素的间隙](https://upload-images.jianshu.io/upload_images/12618366-f8c50e5a78b2b17c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|![](https://upload-images.jianshu.io/upload_images/12618366-6f2d709b5d989d76.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|样式2|
|![](https://upload-images.jianshu.io/upload_images/12618366-390b785e40502a1f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|![](https://upload-images.jianshu.io/upload_images/12618366-c39d509ffe1653c5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|样式3|
|![](https://upload-images.jianshu.io/upload_images/12618366-5b6922c6b1f803ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|![](https://upload-images.jianshu.io/upload_images/12618366-e59796da9e476df5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|样式4|
|![原始](https://upload-images.jianshu.io/upload_images/12618366-40517110f0fa25e5.gif?imageMogr2/auto-orient/strip)![添加间隔,调整view的高度](https://upload-images.jianshu.io/upload_images/12618366-8349cbf06e08659f.gif?imageMogr2/auto-orient/strip)|![](https://upload-images.jianshu.io/upload_images/12618366-a7a40b1b549660af.gif?imageMogr2/auto-orient/strip)|样式5|
|![](https://upload-images.jianshu.io/upload_images/12618366-6118253f8ccf7a88.gif?imageMogr2/auto-orient/strip)|![](https://upload-images.jianshu.io/upload_images/12618366-ff85250220417c2f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|样式6|
|![](https://upload-images.jianshu.io/upload_images/12618366-549b6a6bc7bcec26.gif?imageMogr2/auto-orient/strip)|![](https://upload-images.jianshu.io/upload_images/12618366-3d6ad6add8046dfc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)|样式7|

图片属性
==============
```
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
```

文字滚动样式
==============
* LVTextScrollModeNone:无样式,轮播模式
* LVTextScrollModeOne:从控件内开始连续滚动,如果文字数组是多个元素,水平滚动轮播的文字会通过空格拼接起来,竖直滚动会通过换行拼接起来
* LVTextScrollModeTwo:从控件内开始间断滚动
* LVTextScrollModeThird:从控件外开始滚动
* LVTextScrollModeFour:往返滚动,如果文字数组是多个元素,水平滚动轮播的文字会通过空格拼接起来,竖直滚动会通过换行拼接起来

文字滚动样式效果展示
==============
|水平效果|竖直效果|样式|
|:---:|:---:|:---:|
| ![](https://upload-images.jianshu.io/upload_images/12618366-9640e7cecaf2d9ca.gif?imageMogr2/auto-orient/strip)|![](https://upload-images.jianshu.io/upload_images/12618366-a0fd0a5d3cb1d7a0.gif?imageMogr2/auto-orient/strip)|无样式|
|![一条数据](https://upload-images.jianshu.io/upload_images/12618366-e673e45da2a141f6.gif?imageMogr2/auto-orient/strip)![多条数据](https://upload-images.jianshu.io/upload_images/12618366-175d95f73b718c18.gif?imageMogr2/auto-orient/strip)|![一条数据](https://upload-images.jianshu.io/upload_images/12618366-5e870155b82aac93.gif?imageMogr2/auto-orient/strip)![多条数据](https://upload-images.jianshu.io/upload_images/12618366-90b819d14d4501b0.gif?imageMogr2/auto-orient/strip)|样式1|
|![](https://upload-images.jianshu.io/upload_images/12618366-4d6068aebb870213.gif?imageMogr2/auto-orient/strip)|![](https://upload-images.jianshu.io/upload_images/12618366-335c9ba8a5133ca2.gif?imageMogr2/auto-orient/strip)|样式2|
|![](https://upload-images.jianshu.io/upload_images/12618366-965a732110f3dbdd.gif?imageMogr2/auto-orient/strip)|![](https://upload-images.jianshu.io/upload_images/12618366-059b5f6d57bcaffa.gif?imageMogr2/auto-orient/strip)|样式3|
|![文字宽度比控件宽度短](https://upload-images.jianshu.io/upload_images/12618366-ce213ae308616bd4.gif?imageMogr2/auto-orient/strip)![文字宽度比控件宽度长](https://upload-images.jianshu.io/upload_images/12618366-a5e177f2edcbcfb7.gif?imageMogr2/auto-orient/strip)|![文字高度比控件高度短](https://upload-images.jianshu.io/upload_images/12618366-c615adf5d0a5dd24.gif?imageMogr2/auto-orient/strip)![文字高度比控件高度长](https://upload-images.jianshu.io/upload_images/12618366-daec9ff8d91c959b.gif?imageMogr2/auto-orient/strip)|样式4|

文字属性
==============
```
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

/// 适用于图片和无样式的文字滚动,有样式的文字滚动为0
@property (nonatomic, assign) NSInteger textLabelNumberOfLines;
```


PageControl
==============
只有是滚动类型是LVImageScroll,水平滚动才展示,其他不展示,也可以选择隐藏.

PageControl位置
==============

* LVPageControlCenter:中间,默认
* LVPageControlLeft:底部左边
* LVPageControlRight:底部右边

PageControl类型
==============

* LVPageContolStyleClassic:`系统自带经典样式`,大小形状固定,默认系统的大小7
* LVPageContolStyleCustom:`自定义PageControl`,默认此样式,可以通过下面的属性定义缩放,旋转动画,也可以设置形状大小等等

PageControl属性
==============

```
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
```

自定义PageControl的属性
==============

```
/// 分页控件自定义样式中当前点旋转的角度,默认为0不旋转,设置为M_PI_4就是正向滚动顺时针旋转45°,而逆向滚动时就会逆时针旋转45°,反之设置为-M_PI_4,就是正向滚动时逆时针旋转45°,而逆向滚动时就会顺时针旋转45°
@property (nonatomic, assign) CGFloat pageControlRotationAngle;

/// 分页控件自定义样式中小点的缩放功能,该属性表示当前点较其他点的大小,比如设置为2,就是当前点是其他点的两倍大小,默认为1
@property (nonatomic, assign) CGFloat pageControlZoomSize;

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
```

最后
==============

第一次搞依赖库,可能还存在有bug,代码也有点烂,有问题发我邮箱2387356991@qq.com,觉得还可以的兄弟可以给我个✨
