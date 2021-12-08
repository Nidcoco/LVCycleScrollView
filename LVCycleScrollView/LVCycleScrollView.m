//
//  LVCycleScrollView.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVCycleScrollView.h"
#import "LVCollectionViewCell.h"
#import "TAPageControl.h"
#import <SDWebImage/SDWebImage.h>

#define kPointDotSize CGSizeMake(8, 8)

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

#define kTextBackgroundColor UIColorFromHexWithAlpha(0x000000,0.6)

#define kTextFont 13

#define kTextColor UIColorFromHexWithAlpha(0xFFFFFF,1)

#define kTextLabelHeight 28

#define kSpacingBetweenDots 8

#define kPageControlMarginOffset 10

#define kPageControlBottomOffset 10

#define kAutoScrollTimeInterval 2.0

#define _selfWidth self.frame.size.width

#define _selfHeight self.frame.size.height

@interface LVCycleScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate>

/// mainView的bound和self的bound一样
@property (nonatomic, strong) UICollectionView *mainView;

@property (nonatomic, strong) NSArray *dataSourceArr;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) int wanderingOffset;

@property (nonatomic, weak) TAPageControl *pageControl;

@property (strong, nonatomic) dispatch_source_t timer;

@property (nonatomic, weak) LVCollectionViewLayout *mainViewLayout;


@end

@implementation LVCycleScrollView
{
    NSUInteger _totalItemsCount;
    BOOL _isSetCenter;
    BOOL _isSetPointCornerRadius;
    NSInteger _preIndex;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self addSubview:self.mainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self addSubview:self.mainView];
}

// 初始化
- (void)initialization
{
    _scrollDirection         = UICollectionViewScrollDirectionHorizontal;// 默认横向滚动
    
    _showPageControl         = YES;
    
    _currentPointDotColor    = [UIColor whiteColor];
    _pointDotColor           = [UIColor lightGrayColor];
    
    _pointDotSize            = kPointDotSize;
    
    _spacingBetweenDots      = kSpacingBetweenDots;
    _pageControlMarginOffset = kPageControlMarginOffset;
    _pageControlBottomOffset = kPageControlBottomOffset;
    
    _currentPointDotAlpha    = 1;
    _pointDotAlpha           = 1;
    
    _pointZoomSize           = 1;
    
    _imageScrollType         = LVImageScrollNone;
    
    _anglePerItem            = kAnglePerItem;
    
    _autoScroll              = YES;
    
    _autoScrollTimeInterval  = kAutoScrollTimeInterval;
    
    _textBackgroundColor     = kTextBackgroundColor;
    _textFont                = [UIFont systemFontOfSize:kTextFont];
    _textColor               = kTextColor;
    _textLabelHeight         = kTextLabelHeight;
    
    _wanderingOffset         = -1;
    
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LVCollectionViewCell class]) forIndexPath:indexPath];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:indexPath.row];

    if (self.imagesArray.count) {
        NSString *imagePath = self.dataSourceArr[indexOnPageControl];
        if ([imagePath isKindOfClass:[NSString class]]) {
            if ([imagePath hasPrefix:@"http"]) {
                if (self.placeholderImage) {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
                } else {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                }
            } else {
                UIImage *image = [UIImage imageNamed:imagePath];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:imagePath];
                }
                cell.imageView.image = image;
            }
        } else if ([imagePath isKindOfClass:[UIImage class]]) {
            cell.imageView.image = (UIImage *)imagePath;
        }
    }

        
    if (_titlesArray.count) {
        cell.text = indexOnPageControl >= _titlesArray.count ? @"" : _titlesArray[indexOnPageControl]; // 图片比个文字多
    }
    
    if (!cell.hasConfigured) {
        cell.hasConfigured      = YES;
        cell.textLabelTextFont  = _textFont;
        cell.textLabelTextColor = _textColor;
        
        cell.textLabelBackgroundColor = _textBackgroundColor;
        cell.textLabel.numberOfLines  = _textLabelNumberOfLines;
        
        cell.textLabel.textAlignment = _textLabelTextAlignment;
        cell.textLabelHeight         = _textLabelHeight;
        cell.cellCornerRadius        = _cellCornerRadius;
        cell.imageView.contentMode   = _imageContentMode;
        if (_titlesArray.count && !_imagesArray.count) {
            cell.isOnlyText = YES;
        }
        
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.row]];
    }
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.row]);
    }
    if (self.isTouchScrollToIndex) {
        [self makeScrollViewScrollToIndex:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDidScroll:)]) {
        [self.delegate cycleScrollViewDidScroll:scrollView];
    }
    
    if (!self.dataSourceArr.count) return;
    
    NSInteger itemIndex = [self currentIndex];
    
    if (itemIndex == _preIndex) { // 减少调用次数
        return;
    }
    
    _preIndex = itemIndex;
    
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    _pageControl.currentPage    = indexOnPageControl;
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:willDidScrollToIndex:)]) {
        [self.delegate cycleScrollView:self willDidScrollToIndex:indexOnPageControl];
    }
    if (self.itemWillDidScrollOperationBlock) {
        self.itemWillDidScrollOperationBlock(indexOnPageControl);
    }

}

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    
    if (self.isScrollOnePage) {
        NSInteger index              = [self currentIndex];// 滑动前的当前页
        _mainViewLayout.currentIndex = @(index);
    }
    
}
// 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.dataSourceArr.count) return; // 解决清除timer时偶尔会出现的问题
    NSInteger itemIndex    = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];

    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(indexOnPageControl);
    }
}



#pragma mark - 生命周期

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.mainView.bounds, self.bounds)) {
        self.mainView.frame = self.bounds;
    }
    
    if (CGSizeEqualToSize(CGSizeZero, _itemSize)) {
        _itemSize = CGSizeMake(_selfWidth, _selfHeight);
        _mainViewLayout.itemSize = _itemSize;
    }
    
    // 无限滚动要重新设置ContentOffset
    [self setContentOffsetCenter];
    
    [self setupPageControl];
    
    // 启动定时器
    [self setupTimer];

}

- (void)dealloc {
    [self invalidateTimer];
}

#pragma mark - 私有方法

- (NSInteger)currentIndex
{
    if (_selfWidth == 0 || _selfHeight == 0) {
        return 0;
    }
    
    NSInteger index     = 0;
    NSInteger cellCount = [self.mainView numberOfItemsInSection:0];
    
    if (_imageScrollType == LVImageScrollCardSeven) {
        CGFloat anglePerItem   = self.anglePerItem;
        CGFloat angleAtExtreme = (cellCount - 1) * anglePerItem;
        CGFloat factor;
        // 默认停下来时，旋转的角度
        CGFloat proposedAngle;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            factor        = angleAtExtreme / (self.mainView.contentSize.height - _selfHeight);
            proposedAngle = factor * self.mainView.contentOffset.y;

        } else {
            factor        = angleAtExtreme / (self.mainView.contentSize.width - _selfWidth);
            proposedAngle = factor * self.mainView.contentOffset.x;
        }
        CGFloat ratio = proposedAngle / anglePerItem;
        index         = roundf(ratio);
    } else {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            index = roundf((_mainView.contentOffset.y + _selfHeight / 2 - (_itemSize.height + self.space) / 2) / (_itemSize.height + self.space));
        } else {
            index = roundf((_mainView.contentOffset.x + _selfWidth / 2 - (_itemSize.width + self.space) / 2) / (_itemSize.width + self.space));
        }
    }
    if (index < 0) {
        index = 0;
    }
    if (index >= cellCount) {
        index = cellCount - 1;
    }
    return index;
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    if (self.dataSourceArr.count == 0) {
        return 0;
    }
    return (int)index % self.dataSourceArr.count;
}

// 创建GCD定时器
- (void)setupTimer
{
    [self invalidateTimer];
    
    if (_autoScroll && _dataSourceArr.count) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_source_set_timer(self.timer,
                                  dispatch_time(DISPATCH_TIME_NOW, self.autoScrollTimeInterval * NSEC_PER_SEC),
                                  (self.autoScrollTimeInterval + self.scrollTime) * NSEC_PER_SEC,
                                  0);
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            [weakSelf automaticScroll];
        });
        
        dispatch_resume(self.timer);
    }
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex  = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex
{
    CGPoint offset         = CGPointZero;
    CGFloat angleAtExtreme = (_totalItemsCount - 1) * self.anglePerItem;
    CGFloat factor;
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            if (self.imageScrollType == LVImageScrollCardSeven) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    factor = angleAtExtreme / (self.mainView.contentSize.height - _selfHeight);
                    offset = CGPointMake(0, targetIndex * self.anglePerItem / factor);
                } else {
                    factor = angleAtExtreme / (self.mainView.contentSize.width - _selfWidth);
                    offset = CGPointMake(targetIndex * self.anglePerItem / factor, 0);
                }
            } else {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2 + targetIndex * (_itemSize.height + self.space));
                } else {
                    offset = CGPointMake(-(_selfWidth - (_itemSize.width + self.space)) / 2 + targetIndex * (_itemSize.width + self.space), 0);
                }
            }
            [_mainView setContentOffset:offset animated:NO];
        } else {
            if (self.imageScrollType == LVImageScrollCardSeven) {
                offset = CGPointMake(0, 0);
            } else {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2);
                } else {
                    offset = CGPointMake(-(_selfWidth - (_itemSize.width + self.space)) / 2, 0);
                }
            }
            if (self.scrollTime > 0) { // 测试了下,0.3左右是系统默认的值,当然我没看源码猜的,没设置无限循环回滚的时候默认系统速度
                [_mainView setValue:@(0.3) forKeyPath:@"contentOffsetAnimationDuration"];
            }
            [_mainView setContentOffset:offset animated:YES];
        }
        
    } else {
        if (self.imageScrollType == LVImageScrollCardSeven) {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                factor = angleAtExtreme / (self.mainView.contentSize.height - _selfHeight);
                offset = CGPointMake(0, targetIndex * self.anglePerItem / factor);
            } else {
                factor = angleAtExtreme / (self.mainView.contentSize.width - _selfWidth);
                offset = CGPointMake(targetIndex * self.anglePerItem / factor, 0);
            }
        } else {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2 + targetIndex * (_itemSize.height + self.space));
            } else {
                offset = CGPointMake(-(_selfWidth - (_itemSize.width + self.space)) / 2 + targetIndex * (_itemSize.width + self.space), 0);
            }
        }
        if (self.scrollTime > 0) {
            [_mainView setValue:@(self.scrollTime) forKeyPath:@"contentOffsetAnimationDuration"];
        }
        
        [_mainView setContentOffset:offset animated:YES];
        // [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];使用这个方法当水平滚动,item的宽不是全屏滚动就会有误差,并且targetIndex超出行数滚回第一行的时候在layout设置的collectionView.contentInset无效,竖直滚动亦如此
    }
    
}


- (void)setupPageControl
{
    // 只有水平图片滚动才创建分页控件,满足这两条件后,展不展示再由属性ShowPageControl决定
    if (_pageControl) { // 重新加载数据时调整
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    
    if(_scrollDirection != UICollectionViewScrollDirectionHorizontal || !_imagesArray.count) {
        return;
    }
    
    TAPageControl *pageControl           = [[TAPageControl alloc] init];
    pageControl.numberOfPages            = _dataSourceArr.count;
    pageControl.pointDotColor            = _pointDotColor;
    pageControl.currentPointDotColor     = _currentPointDotColor;
    pageControl.currentPointDotAlpha     = _currentPointDotAlpha;
    pageControl.pointDotAlpha            = _pointDotAlpha;
    pageControl.pointRotationAngle       = _pointRotationAngle;
    pageControl.pointZoomSize            = _pointZoomSize;
    pageControl.currentDotImage          = _currentPointDotImage;
    pageControl.dotImage                 = _pointDotImage;
    pageControl.dotSize                  = _pointDotSize;
    if (!(_currentPointDotImage || _pointDotImage) && !CGSizeEqualToSize(_pointDotSize, CGSizeZero) && !_isSetPointCornerRadius) { // 默认情况取宽的一半
        pageControl.cornerRadius         = _pointDotSize.width / 2.f;
    } else {
        pageControl.cornerRadius         = _pointCornerRadius;
    }
    pageControl.userInteractionEnabled   = NO;
    [self addSubview:pageControl];
    _pageControl                         = pageControl;
    
    
    // 设置分页控件的frame
    [self setupPageControlFrame];
}

- (void)setupPageControlFrame
{
    
    CGSize size = CGSizeZero;
    
    _pageControl.spacingBetweenDots = _spacingBetweenDots;

    size = [_pageControl sizeForNumberOfPages:_dataSourceArr.count];

    CGFloat x = (_selfWidth - size.width) * 0.5;
    if (_pageControlAliment == LVPageControlLeft) {
        x = _pageControlMarginOffset;
    } else if (_pageControlAliment == LVPageControlRight) {
        x = _selfWidth - size.width - _pageControlMarginOffset;
    }
    CGFloat y = _mainView.frame.size.height - size.height - _pageControlBottomOffset;
    
    [_pageControl sizeToFit];


    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    _pageControl.frame  = pageControlFrame;

    _pageControl.hidden = !_showPageControl;
}

- (void)setContentOffsetCenter
{
    if (_isSetCenter && _infiniteLoop) {
        int targetIndex = _totalItemsCount * 0.5;
        CGPoint offset  = CGPointZero;
        if (self.imageScrollType == LVImageScrollCardSeven) {
            CGFloat angleAtExtreme = (_totalItemsCount - 1) * self.anglePerItem;
            CGFloat factor;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                factor = angleAtExtreme / (_totalItemsCount * _itemSize.height);
                offset = CGPointMake(0, targetIndex * self.anglePerItem / factor);
            } else {
                factor = angleAtExtreme / (_totalItemsCount * _itemSize.width);
                offset = CGPointMake(targetIndex * self.anglePerItem / factor, 0);
            }
            // 这里获取的self.mainView.contentSize.width为0,应该是collectionView的布局还没完全计算出来,可以在下面设置数据源的时候reload之后再加上layoutIfNeeded,但是此时除了图片滚动样式7,其他样式如果设置了无限循环轮播还是会从第0行开始,就是下面的[weakSelf.mainView setContentOffset:offset animated:NO];会失效,所以这里我直接手动计算出来,因为layout类里面有写,直接用过来就行了
        } else {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2 + targetIndex * (_itemSize.height + self.space));
            } else {
                offset = CGPointMake(-(_selfWidth - (_itemSize.width + self.space)) / 2 + targetIndex * (_itemSize.width + self.space), 0);
            }
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mainView setContentOffset:offset animated:NO];
        });
        _isSetCenter = NO;
    }
}


- (void)setViewLayout
{
    _isSetCenter = YES;
    [self setNeedsLayout];
}

#pragma mark - 公有方法

- (void)makeScrollViewScrollToIndex:(NSInteger)index{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == _totalItemsCount) return;

    [self scrollToIndex:index];
    
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)disableScrollGesture {
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

- (void)move
{
    [self setupTimer];
}

- (void)stop
{
    [self invalidateTimer];
}

- (void)invalidateTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}


#pragma mark - Setter & Getter

- (void)setImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
    NSMutableArray *temp = [NSMutableArray new];
    [_imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[UIImage class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.dataSourceArr = [temp copy];
}

- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    if (!self.imagesArray.count) {
        self.dataSourceArr = titlesArray;
    }
}

- (void)setDataSourceArr:(NSArray *)dataSourceArr
{
    _dataSourceArr = dataSourceArr;
    _totalItemsCount = _infiniteLoop ? _dataSourceArr.count * 100 : _dataSourceArr.count;
    [self.mainView reloadData];

    [self setViewLayout];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:0];
    }
    
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(0);
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    _totalItemsCount = _infiniteLoop ? _dataSourceArr.count * 100 : _dataSourceArr.count;
    if (_totalItemsCount) {
        [self.mainView reloadData];
        [self setViewLayout];
    }
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    _mainViewLayout.itemSize = itemSize;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    _mainViewLayout.scrollDirection = scrollDirection;

    [self setupPageControl];
}

- (void)setImageScrollType:(LVImageScrollType)imageScrollType
{
    _imageScrollType = imageScrollType;
    _mainViewLayout.scrollType = imageScrollType;
}

- (void)setSpace:(CGFloat)space
{
    _space = space;
    _mainViewLayout.space = space;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    _mainViewLayout.radius = radius;
}

- (void)setAnglePerItem:(CGFloat)anglePerItem
{
    _anglePerItem = anglePerItem;
    _mainViewLayout.anglePerItem = anglePerItem;
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    _mainViewLayout.zoomScale = zoomScale;
}

- (void)setRotationAngle:(CGFloat)rotationAngle
{
    _rotationAngle = rotationAngle;
    _mainViewLayout.rotationAngle = rotationAngle;
}

- (void)setVisibleCount:(NSInteger)visibleCount
{
    _visibleCount = visibleCount;
    _mainViewLayout.visibleCount = visibleCount;
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setPointDotSize:(CGSize)pointDotSize
{
    _pointDotSize = pointDotSize;
    _pageControl.dotSize = pointDotSize;
    if (!(_isSetPointCornerRadius || _currentPointDotImage || _pointDotImage)) {
        _pointCornerRadius = pointDotSize.width / 2.f;
        _pageControl.cornerRadius = _pointCornerRadius;
    }
}

- (void)setSpacingBetweenDots:(CGFloat)spacingBetweenDots
{
    _spacingBetweenDots = spacingBetweenDots;
    if (self.imagesArray.count && _scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        [self setupPageControlFrame];
    }
}

- (void)setPointCornerRadius:(CGFloat)pointCornerRadius
{
    _pointCornerRadius = pointCornerRadius;
    _pageControl.cornerRadius = pointCornerRadius;
    _isSetPointCornerRadius = YES;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    if (autoScrollTimeInterval > 0 && _autoScroll) {
        [self setupTimer];
    }
}

- (void)setCurrentPointDotColor:(UIColor *)currentPointDotColor
{
    _currentPointDotColor = currentPointDotColor;
    _pageControl.currentPointDotColor = currentPointDotColor;
}

- (void)setPointDotColor:(UIColor *)pointDotColor
{
    _pointDotColor = pointDotColor;
    _pageControl.pointDotColor = pointDotColor;
}

- (void)setCurrentPointDotAlpha:(CGFloat)currentPointDotAlpha
{
    _currentPointDotAlpha = currentPointDotAlpha;
    _pageControl.currentPointDotAlpha = currentPointDotAlpha;
}

- (void)setPointDotAlpha:(CGFloat)pointDotAlpha
{
    _pointDotAlpha = pointDotAlpha;
    _pageControl.pointDotAlpha = pointDotAlpha;
}

- (void)setCurrentPointDotImage:(UIImage *)currentPointDotImage
{
    _currentPointDotImage = currentPointDotImage;
    if (currentPointDotImage) {
        _pageControl.currentDotImage = currentPointDotImage;
    }
    if (!_isSetPointCornerRadius) { // 不设置圆角, 默认_pointDotSize宽的一半, 设置图片默认为0
        _pointCornerRadius = 0;
        _pageControl.cornerRadius = 0;
    }
}

- (void)setPointDotImage:(UIImage *)pointDotImage
{
    _pointDotImage = pointDotImage;
    if (pointDotImage) {
        _pageControl.dotImage = pointDotImage;
    }
    if (!_isSetPointCornerRadius) {
        _pointCornerRadius = 0;
        _pageControl.cornerRadius = 0;
    }
}

- (void)setPointZoomSize:(CGFloat)pointZoomSize
{
    _pointZoomSize = pointZoomSize;
    _pageControl.pointZoomSize = pointZoomSize;
}

- (void)setPointRotationAngle:(CGFloat)pointRotationAngle
{
    _pointRotationAngle = pointRotationAngle;
    _pageControl.pointRotationAngle = pointRotationAngle;
}

- (void)setPageControlBottomOffset:(CGFloat)pageControlBottomOffset
{
    _pageControlBottomOffset = pageControlBottomOffset;
    if (pageControlBottomOffset < 0) {
        _pageControlBottomOffset = 0;
    }
}

- (void)setPageControlMarginOffset:(CGFloat)pageControlMarginOffset
{
    _pageControlMarginOffset = pageControlMarginOffset;
    if (pageControlMarginOffset < 0) {
        _pageControlMarginOffset = 0;
    }
}

- (UICollectionView *)mainView
{
    if (_mainView == nil) {
        
        LVCollectionViewLayout *layout = [[LVCollectionViewLayout alloc] init];
        layout.scrollDirection         = _scrollDirection;
        layout.itemSize                = _itemSize;
        _mainViewLayout                = layout;

        _mainView                                = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_mainViewLayout];
        _mainView.backgroundColor                = [UIColor clearColor];
        _mainView.pagingEnabled                  = false;
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator   = NO;
        _mainView.dataSource                     = self;
        _mainView.delegate                       = self;
        _mainView.scrollsToTop                   = NO;
        // 若不设置,竖直滚动,当collectionView的顶部超过导航栏底部,collectionView刚创建好的时候contentOffset.y会偏移
        _mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_mainView registerClass:[LVCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LVCollectionViewCell class])];
    }
    return _mainView;
}

@end
