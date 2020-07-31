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

文字滚动样式
==============
* LVTextScrollModeNone:无样式,轮播模式
* LVTextScrollModeOne:从控件内开始连续滚动
* LVTextScrollModeTwo:从控件内开始间断滚动
* LVTextScrollModeThird:从控件外开始滚动
* LVTextScrollModeFour:往返滚动

图片滚动样式效果展示
==============
|水平效果|竖直效果|样式|
|:---:|:---:|:---:|
