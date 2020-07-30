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

#define kPageControlDotSize CGSizeMake(8, 8)

#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

#define kTextBackgroundColor UIColorFromHexWithAlpha(0x000000,0.6)

#define kTextFont 13

#define kTextColor UIColorFromHexWithAlpha(0xFFFFFF,1)

#define kTextLabelHeight 28

#define kSpeed (_scrollDirection == UICollectionViewScrollDirectionVertical ? 0.1 : 0.02)

#define kSpacingBetweenDots 8

#define kPageControlMarginOffset 10

#define kPageControlBottomOffset 10

#define kAutoScrollTimeInterval 2.0

@interface LVCycleScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate>

/// mainView的bound和self的bound一样
@property (nonatomic, strong) UICollectionView *mainView;

@property (nonatomic, strong) NSArray *dataSourceArr;

@property (nonatomic, copy) NSString *textString;

@property (nonatomic, assign) CGFloat textSize;

@property (nonatomic, assign) CGSize maxSize;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) int wanderingOffset;

@property (nonatomic, weak) UIControl *pageControl;

@property (nonatomic, strong) NSTimer * timer;

/// 是否调用了setPageControlCornerRadius方法
@property (nonatomic, assign) BOOL isSetCornerRadius;

@property (nonatomic, weak) LVCollectionViewLayout *mainViewLayout;

/// 滚动类型
@property (nonatomic, assign) LVScrollType scrollType;

/// 滚动方式
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;


@end

@implementation LVCycleScrollView
{
    CGFloat _selfWidth;
    CGFloat _selfHeight;
    CGSize _itemSize;
    NSInteger _totalItemsCount;
}

- (instancetype)initWithFrame:(CGRect)frame
                     itemSize:(CGSize)itemSize
                   scrollType:(LVScrollType)scrollType
              scrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (self = [super initWithFrame:frame]) {
        _itemSize = itemSize;
        _scrollDirection = scrollDirection;
        _scrollType = scrollType;
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)initialization
{
    _selfWidth = self.frame.size.width;
    _selfHeight = self.frame.size.height;
    
    _maxSize = CGSizeMake(_selfWidth - 2, MAXFLOAT);
    
    _showPageControl = YES;
    
    _pageControlStyle = LVPageContolStyleCustom;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    
    _pageControlDotSize = kPageControlDotSize;
    
    _spacingBetweenDots = kSpacingBetweenDots;
    _pageControlMarginOffset = kPageControlMarginOffset;
    _pageControlBottomOffset = kPageControlBottomOffset;
    
    _currentPageDotAlpha = 1;
    _pageDotAlpha = 1;
    
    _isSetCornerRadius = NO;
    
    _pageControlBorderColor = [UIColor clearColor];
    _pageControlBorderWidth = 0.f;
    
    _imageScrollType = LVImageScrollNone;
    
    _anglePerItem = kAnglePerItem;
    
    _autoScroll = YES;
    
    _autoScrollTimeInterval = kAutoScrollTimeInterval;
    
    _speed = kSpeed;
    
    _textBackgroundColor = kTextBackgroundColor;
    _textFont = [UIFont systemFontOfSize:kTextFont];
    _textColor = kTextColor;
    _textLabelHeight = kTextLabelHeight;
    
    _wanderingOffset = -1;
    
}

- (void)setupMainView
{
    if (CGSizeEqualToSize(CGSizeZero, _itemSize)) {
        NSAssert(NO, @"该参数不能为zero");
    }
    LVCollectionViewLayout *layout = [[LVCollectionViewLayout alloc] init];
    layout.scrollDirection = _scrollDirection;
    layout.itemSize = _itemSize;
    
    _mainViewLayout = layout;
    
    CGFloat viewWidth = 0;
    CGFloat viewHeight = 0;
    // 如果传进来的是CGRectZero,collectionView大小就用传进来的itemSize
    if (CGRectEqualToRect(CGRectZero, self.bounds)) {
        viewWidth = _itemSize.width;
        viewHeight = _itemSize.height;
    }else {
        // 竖直滑动的时候,如果设置的collectionView的宽度小于cell的宽度,则collectionView的宽度等于cell的宽度,保证不会遮挡cell
        if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
            if (self.bounds.size.width < _itemSize.width) {
                viewWidth = _itemSize.width;
                viewHeight = self.bounds.size.height;
            }else {
                viewWidth = self.bounds.size.width;
                viewHeight = self.bounds.size.height;
            }
        }else {
            // 水平滑动的时候,如果设置的collectionView的高度小于cell的高度,则collectionView的宽度等于cell的高度
            if (self.bounds.size.height < _itemSize.height) {
                viewHeight = _itemSize.height;
                viewWidth = self.bounds.size.width;
            }else {
                viewHeight = self.bounds.size.height;
                viewWidth = self.bounds.size.width;
            }
        }

    }
    _mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) collectionViewLayout:layout];
    _mainView.backgroundColor = [UIColor clearColor];
    _mainView.pagingEnabled = false;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    // 若不设置,竖直滚动,当collectionView的顶部超过导航栏底部,collectionView刚创建好的时候contentOffset.y会偏移
    _mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [_mainView registerClass:[LVCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LVCollectionViewCell class])];
//    [_mainView registerNib:[UINib nibWithNibName:NSStringFromClass([LVCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LVCollectionViewCell class])];
    
    _mainView.dataSource = self;
    _mainView.delegate = self;
    _mainView.scrollsToTop = NO;
    [self addSubview:_mainView];

    
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone) {
        return 1;
    }
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LVCollectionViewCell class]) forIndexPath:indexPath];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:indexPath.row];

    if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone && _titlesArray) {
        [self calculateAction];
        cell.text = self.textString;
        [self setupTextTimer:cell];
        
    }else {
        NSString *imagePath = self.dataSourceArr[indexOnPageControl];
        if (self.scrollType == LVImageScroll && [imagePath isKindOfClass:[NSString class]]) {
            if ([imagePath hasPrefix:@"http"]) {
                if (self.placeholderImage) {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
                }else {
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
                }
            }else {
                UIImage *image = [UIImage imageNamed:imagePath];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:imagePath];
                }
                cell.imageView.image = image;
            }
        }else if (self.scrollType == LVImageScroll && [imagePath isKindOfClass:[UIImage class]]) {
            cell.imageView.image = (UIImage *)imagePath;
        }
        
        if (_titlesArray.count) {
            if (self.scrollType == LVImageScroll && _titlesArray.count == 1) {
                cell.text = _titlesArray.firstObject;
            }else {
                cell.text = _titlesArray[indexOnPageControl];
            }
        }
    }
    if (!cell.hasConfigured) {
        cell.hasConfigured = YES;
        cell.scrollType = _scrollType;
        cell.scrollDirection = _scrollDirection;
        cell.textLabelTextFont = _textFont;
        cell.textLabelTextColor = _textColor;
        if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone) {
            cell.backgroundColor = _textBackgroundColor;
            cell.textLabelBackgroundColor = [UIColor clearColor];
            if (self.textScrollMode == LVTextScrollModeThird) {
                cell.isTextModeThird = YES;
            }
            cell.textLabel.numberOfLines = 0;
        }else {
            cell.textLabelBackgroundColor = _textBackgroundColor;
            cell.textLabel.numberOfLines = _textLabelNumberOfLines;
        }
        cell.textLabel.textAlignment = _textLabelTextAlignment;
        cell.textLabelHeight = _textLabelHeight;
        cell.cellCornerRadius = _cellCornerRadius;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone) {
            if (self.textScrollMode == LVTextScrollModeOne) {
                [self.delegate cycleScrollView:self didSelectItemAtIndex:0];
            }else {
                [self.delegate cycleScrollView:self didSelectItemAtIndex:self.index];
            }
        }else {
            [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.row]];
        }
    }
    if (self.clickItemOperationBlock) {
        if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone) {
            if (self.textScrollMode == LVTextScrollModeOne) {
                self.clickItemOperationBlock(0);
            }else {
                self.clickItemOperationBlock(self.index);
            }
        }else {
            self.clickItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.row]);
        }
    }
    if (self.scrollType == LVImageScroll && self.isTouchScrollToIndex) {
        [self makeScrollViewScrollToIndex:indexPath.row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger itemIndex = [self currentIndex];
    
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }
}

// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    
    if (self.isScrollOnePage) {
        NSInteger index = [self currentIndex];// 滑动前的当前页
        _mainViewLayout.currentIndex = @(index);
    }
    
}
// 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupImageTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.dataSourceArr.count) return; // 解决清除timer时偶尔会出现的问题
    NSInteger itemIndex = [self currentIndex];
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
    self.delegate = self.delegate;

    [super layoutSubviews];
    
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount && self.infiniteLoop) {
        int targetIndex = _totalItemsCount * 0.5;
        CGPoint offset = CGPointZero;
        if (self.imageScrollType == LVImageScrollCardSeven) {
            CGFloat angleAtExtreme = (_totalItemsCount - 1) * self.anglePerItem;
            CGFloat factor;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                factor = angleAtExtreme / (_totalItemsCount * _itemSize.height);
                offset = CGPointMake(0, targetIndex * self.anglePerItem / factor);
            }else {
                factor = angleAtExtreme / (_totalItemsCount * _itemSize.width);
                offset = CGPointMake(targetIndex * self.anglePerItem / factor, 0);
            }
            // 这里获取的self.mainView.contentSize.width为0,应该是collectionView的布局还没完全计算出来,可以在下面设置数据源的时候reload之后再加上layoutIfNeeded,但是此时除了图片滚动样式7,其他样式如果设置了无限循环轮播还是会从第0行开始,就是下面的[weakSelf.mainView setContentOffset:offset animated:NO];会失效,所以这里我直接手动计算出来,因为layout类里面有写,直接用过来就行了
        }else {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2 + targetIndex * (_itemSize.height + self.space));
            }else {
                offset = CGPointMake(-(_selfWidth - (_itemSize.width + self.space)) / 2 + targetIndex * (_itemSize.width + self.space), 0);
            }
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mainView setContentOffset:offset animated:NO];
        });

    }
    
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.spacingBetweenDots = self.spacingBetweenDots;
        if (!(self.pageDotImage && self.currentPageDotImage && CGSizeEqualToSize(CGSizeMake(8, 8), self.pageControlDotSize))) {
            pageControl.dotSize = self.pageControlDotSize;
        }
        size = [pageControl sizeForNumberOfPages:self.dataSourceArr.count];
    } else {
        size = CGSizeMake(self.dataSourceArr.count * 7 * 1.5, 7);
    }
    
    CGFloat x = (_selfWidth - size.width) * 0.5;
    if (self.pageControlAliment == LVPageControlLeft) {
        x = self.pageControlMarginOffset;
    }else if (self.pageControlAliment == LVPageControlRight) {
        x = _selfWidth - size.width - self.pageControlMarginOffset;
    }
    CGFloat y = self.mainView.frame.size.height - size.height - self.pageControlBottomOffset;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    self.pageControl.frame = pageControlFrame;
    self.pageControl.hidden = !_showPageControl;
    
    if (self.scrollType == LVImageScroll && _titlesArray && !(_titlesArray.count == 1 || _titlesArray.count == _imagesArray.count)) {
        NSAssert(NO, @"titlesArray不等于1,并且与imagesArray数组数量不相同");
    }
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:0];
    }
    
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(0);
    }
    
}

- (void)dealloc {
    [self.timer invalidate];
}

#pragma mark - 私有方法

- (NSInteger)currentIndex
{
    if (_selfWidth == 0 || _selfHeight == 0) {
        return 0;
    }
    
    NSInteger index = 0;
    NSInteger cellCount = [self.mainView numberOfItemsInSection:0];
    
    if (_imageScrollType == LVImageScrollCardSeven) {
        CGFloat anglePerItem = self.anglePerItem;
        CGFloat angleAtExtreme = (cellCount - 1) * anglePerItem;
        CGFloat factor;
        // 默认停下来时，旋转的角度
        CGFloat proposedAngle;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            factor = angleAtExtreme / (self.mainView.contentSize.height - _selfHeight);
            proposedAngle = factor * self.mainView.contentOffset.y;

        }else {
            factor = angleAtExtreme / (self.mainView.contentSize.width - _selfWidth);
            proposedAngle = factor * self.mainView.contentOffset.x;
        }
        CGFloat ratio = proposedAngle / anglePerItem;
        index = roundf(ratio);
    }else {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            index = roundf((_mainView.contentOffset.y + _selfHeight / 2 - (_itemSize.height + self.space) / 2) / (_itemSize.height + self.space));
        }else {
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
    return (int)index % self.dataSourceArr.count;
}

// 图片及无样式文字滚动
- (void)setupImageTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:weakSelf.autoScrollTimeInterval + (weakSelf.scrollTime == 0 ? 0.3 : weakSelf.scrollTime)]];
        [weakSelf automaticScroll];
    }];
}

// 有样式的文字滚动
- (void)setupTextTimer:(LVCollectionViewCell *)cell
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.speed repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf setupTextScroll:weakCell];
    }];
}

- (void)setupTextScroll:(LVCollectionViewCell *)cell
{
    CGFloat cellOrigin = self.scrollDirection == UICollectionViewScrollDirectionVertical ? cell.textLabel.frame.origin.y :cell.textLabel.frame.origin.x;
    if (self.textScrollMode != LVTextScrollModeFour) {
        cellOrigin --;
    }else {
        cellOrigin += self.wanderingOffset;
        CGFloat range = self.scrollDirection == UICollectionViewScrollDirectionVertical ? _selfHeight : _selfWidth;
        if (self.textSize > range) {
            if (cellOrigin < - (self.textSize - range + 2)) {
                self.wanderingOffset = 1;
            }
            if (cellOrigin > 2) {
                self.wanderingOffset = - 1;
            }
        }else if (self.textSize < range){
            if (cellOrigin < 0) {
                self.wanderingOffset = 1;
            }
            if (cellOrigin > range - self.textSize) {
                self.wanderingOffset = -1 ;
            }
        }
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        cell.textFrame = CGRectMake(2, cellOrigin, _selfWidth - 2, self.textSize);
    }else {
        cell.textFrame = CGRectMake(cellOrigin, 0  , self.textSize, _selfHeight);
    }
    
    CGFloat range;
    if (self.textScrollMode != LVTextScrollModeFour) {
        if (self.textScrollMode == LVTextScrollModeOne) {
            range = - self.textSize / (self.index + 1);
        }else {
            range = - self.textSize;
        }
        if (cellOrigin < range) {
            if (self.titlesArray.count > 1 && self.textScrollMode != LVTextScrollModeOne) {
                if (self.index < self.titlesArray.count - 1) {
                    self.index ++;
                }else {
                    self.index = 0;
                }
                self.textString = self.titlesArray[self.index];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    self.textSize = [self heightWithString:self.textString font:self.textFont maxSize:self.maxSize];
                }else {
                    self.textSize = [self.textString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textFont, NSFontAttributeName, nil]].width;
                }
            }
            
            if (self.textScrollMode == LVTextScrollModeThird) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    cell.textFrame = CGRectMake(2, _selfHeight, _selfWidth, self.textSize);
                }else {
                    cell.textFrame = CGRectMake(_selfWidth, 0, self.textSize, _selfHeight);
                }
            }else {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    cell.textFrame = CGRectMake(2, 0, _selfWidth - 2, self.textSize);
                }else {
                    cell.textFrame = CGRectMake(2, 0, self.textSize, _selfHeight);
                }
            }
            cell.text = self.textString;
            
            if (self.textScrollMode != LVImageScrollCardOne) {
                if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
                    [self.delegate cycleScrollView:self didScrollToIndex:self.index];
                }
                if (self.itemDidScrollOperationBlock) {
                    self.itemDidScrollOperationBlock(self.index);
                }
            }
            
        }
    }
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex
{
    CGPoint offset = CGPointZero;
    CGFloat angleAtExtreme = (_totalItemsCount - 1) * self.anglePerItem;
    CGFloat factor;
    if (targetIndex >= _totalItemsCount) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.autoScrollTimeInterval]];
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            if (self.imageScrollType == LVImageScrollCardSeven) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    factor = angleAtExtreme / (self.mainView.contentSize.height - _selfHeight);
                    offset = CGPointMake(0, targetIndex * self.anglePerItem / factor);
                }else {
                    factor = angleAtExtreme / (self.mainView.contentSize.width - _selfWidth);
                    offset = CGPointMake(targetIndex * self.anglePerItem / factor, 0);
                }
            }else {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2 + targetIndex * (_itemSize.height + self.space));
                }else {
                    offset = CGPointMake(-(_selfWidth - (_itemSize.width + self.space)) / 2 + targetIndex * (_itemSize.width + self.space), 0);
                }
            }
            [_mainView setContentOffset:offset animated:NO];
        }else {
            if (self.imageScrollType == LVImageScrollCardSeven) {
                offset = CGPointMake(0, 0);
            }else {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2);
                }else {
                    offset = CGPointMake(-(_selfWidth - (_itemSize.width + self.space)) / 2, 0);
                }
            }
            if (self.scrollTime > 0) { // 测试了下,0.3左右是系统默认的值,当然我没看源码猜的,没设置无限循环回滚的时候默认系统速度
                [_mainView setValue:@(0.3) forKeyPath:@"contentOffsetAnimationDuration"];
            }
            [_mainView setContentOffset:offset animated:YES];
        }
        
    }else {
        if (self.imageScrollType == LVImageScrollCardSeven) {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                factor = angleAtExtreme / (self.mainView.contentSize.height - _selfHeight);
                offset = CGPointMake(0, targetIndex * self.anglePerItem / factor);
            }else {
                factor = angleAtExtreme / (self.mainView.contentSize.width - _selfWidth);
                offset = CGPointMake(targetIndex * self.anglePerItem / factor, 0);
            }
        }else {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                offset = CGPointMake(0, -(_selfHeight - (_itemSize.height + self.space)) / 2 + targetIndex * (_itemSize.height + self.space));
            }else {
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
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整

    switch (self.pageControlStyle) {
        case LVPageContolStyleClassic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.dataSourceArr.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            [self addSubview:pageControl];
            _pageControl = pageControl;

        }
            break;

        case LVPageContolStyleCustom:
        {
            TAPageControl *pageControl = [[TAPageControl alloc] init];
            pageControl.numberOfPages = self.dataSourceArr.count;
            pageControl.pageDotColor = self.pageDotColor;
            pageControl.currentPageDotColor = self.currentPageDotColor;
            pageControl.currentPageDotAlpha = self.currentPageDotAlpha;
            pageControl.pageDotAlpha = self.pageDotAlpha;
            pageControl.borderColor = self.pageControlBorderColor;
            pageControl.borderWidth = self.pageControlBorderWidth;
            if (self.isSetCornerRadius) {
                pageControl.cornerRadius = self.pageControlCornerRadius;
            }else {
                pageControl.cornerRadius = self.pageControlDotSize.height / 2;
            }
            pageControl.userInteractionEnabled = NO;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
    }
}

- (void)calculateAction
{
    if (self.textScrollMode == LVTextScrollModeOne || self.textScrollMode == LVTextScrollModeFour) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            self.textString = [self.titlesArray componentsJoinedByString:@"\n"];
            self.textSize = [self heightWithString:self.textString font:self.textFont maxSize:self.maxSize];
        }else {
            self.textString = [self.titlesArray componentsJoinedByString:@" "];
            self.textSize = [self.textString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textFont, NSFontAttributeName, nil]].width;
        }
        
        if (self.textScrollMode == LVTextScrollModeOne) {
            NSString *totalText = self.textString;
            CGFloat totalSize = self.textSize;
            while (totalSize - self.textSize < (self.scrollDirection == UICollectionViewScrollDirectionVertical ? _selfHeight : _selfWidth)) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    totalText = [NSString stringWithFormat:@"%@\n%@",totalText,self.textString];
                    totalSize = [self heightWithString:totalText font:self.textFont maxSize:self.maxSize];
                }else {
                    totalText = [NSString stringWithFormat:@"%@ %@",totalText,self.textString];
                    totalSize = [totalText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textFont, NSFontAttributeName, nil]].width;
                }
                
                self.index ++;
            }
            self.textString = totalText;
            self.textSize = totalSize;
        }
    }else {
        self.textString = self.titlesArray.firstObject;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            self.textSize = [self heightWithString:self.textString font:self.textFont maxSize:self.maxSize];
        }else {
            self.textSize = [self.textString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textFont, NSFontAttributeName, nil]].width;
        }
    }
}

- (CGFloat)heightWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize.height;
}


#pragma mark - 公有方法

- (void)makeScrollViewScrollToIndex:(NSInteger)index{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == _totalItemsCount) return;
    
    [self scrollToIndex:index];
    
    if (self.autoScroll) {
        [self setupImageTimer];
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
    if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone) {
        LVCollectionViewCell *cell = (LVCollectionViewCell *)[self.mainView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self setupTextTimer:cell];
    }else {
        [self setupImageTimer];
    }
}

- (void)stop
{
    [self invalidateTimer];
}


#pragma mark - Setter & Getter

- (void)setImagesArray:(NSArray *)imagesArray
{
    if (self.scrollType != LVImageScroll) {
        return;
    }
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
    _totalItemsCount = self.infiniteLoop ? self.dataSourceArr.count * 100 : self.dataSourceArr.count;
    if (_totalItemsCount > 1) { // 由于 !=1 包含count == 0等情况
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
        [self invalidateTimer];
    }
    
    // 只有水平图片滚动才创建分页控件,满足这两条件后,展不展示再由属性ShowPageControl决定
    if(_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        [self setupPageControl];
    }
    [self.mainView reloadData];
    
}

- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    if (self.scrollType == LVOnlyTextScroll && self.textScrollMode == LVTextScrollModeNone) {
        self.dataSourceArr = titlesArray;
        _totalItemsCount = self.infiniteLoop ? self.dataSourceArr.count * 100 : self.dataSourceArr.count;
        if (_totalItemsCount > 1) { // 由于 !=1 包含count == 0等情况
            self.mainView.scrollEnabled = YES;
            [self setAutoScroll:self.autoScroll];
        } else {
            self.mainView.scrollEnabled = NO;
            [self invalidateTimer];
        }
        [self.mainView reloadData];
    }else if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone) {
        [self invalidateTimer];
        self.infiniteLoop = NO;
        self.mainView.scrollEnabled = NO;
        [self.mainView reloadData];
    }
}

- (void)setTextScrollMode:(LVTextScrollMode)textScrollMode
{
    _textScrollMode = textScrollMode;
    if (self.scrollType == LVOnlyTextScroll && textScrollMode != LVTextScrollModeNone) {
        [self invalidateTimer];
        self.infiniteLoop = NO;
        self.mainView.scrollEnabled = NO;
        [self.mainView reloadData];
    }
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    if (self.scrollType == LVOnlyTextScroll && self.textScrollMode != LVTextScrollModeNone) {
        return;
    }
    _infiniteLoop = infiniteLoop;
    _totalItemsCount = self.infiniteLoop ? self.dataSourceArr.count * 100 : self.dataSourceArr.count;
    if (_totalItemsCount > 1) { // 由于 !=1 包含count == 0等情况
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
        [self invalidateTimer];
    }
}

- (void)setImageScrollType:(LVImageScrollType)imageScrollType
{
    _imageScrollType = imageScrollType;
    _mainViewLayout.imageScrollType = imageScrollType;
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
    if (_scrollType == LVImageScroll && _scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        _showPageControl = showPageControl;
        _pageControl.hidden = !showPageControl;
    }
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    if (pageControlDotSize.height != pageControlDotSize.width) {
        NSAssert(NO, @"宽高必须相同");
    }
    _pageControlDotSize = pageControlDotSize;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageContol = (TAPageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
        if (!self.isSetCornerRadius) {
            pageContol.cornerRadius = pageControlDotSize.height / 2;
        }
    }
}

- (void)setPageControlCornerRadius:(CGFloat)pageControlCornerRadius
{
    _pageControlCornerRadius = pageControlCornerRadius;
    self.isSetCornerRadius = YES;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.cornerRadius = pageControlCornerRadius;
    }
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) {
        [self setupImageTimer];
    }
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    if (autoScrollTimeInterval > 0) {
        [self setupImageTimer];
    }
}

- (void)setPageControlStyle:(LVPageControlStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    [self setupPageControl];
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.currentPageDotColor = currentPageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.pageDotColor = pageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setPageControlBorderColor:(UIColor *)pageControlBorderColor
{
    _pageControlBorderColor = pageControlBorderColor;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.borderColor = pageControlBorderColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage
{
    _currentPageDotImage = currentPageDotImage;
    if (self.pageControlStyle != LVPageContolStyleCustom) {
        return;
    }
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage
{
    _pageDotImage = pageDotImage;
    if (self.pageControlStyle != LVPageContolStyleCustom) {
        return;
    }
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot
{
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        if (isCurrentPageDot) {
            pageControl.currentDotImage = image;
        } else {
            pageControl.dotImage = image;
        }
    }
}

- (void)setPageControlBorderWidth:(CGFloat)pageControlBorderWidth
{
    _pageControlBorderWidth = pageControlBorderWidth;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.borderWidth = pageControlBorderWidth;
    }
}

- (void)setPageControlZoomSize:(CGFloat)pageControlZoomSize
{
    _pageControlZoomSize = pageControlZoomSize;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.pageControlZoomSize = pageControlZoomSize;
    }
}

- (void)setPageControlRotationAngle:(CGFloat)pageControlRotationAngle
{
    _pageControlRotationAngle = pageControlRotationAngle;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)_pageControl;
        pageControl.pageControlRotationAngle = pageControlRotationAngle;
    }
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


@end
