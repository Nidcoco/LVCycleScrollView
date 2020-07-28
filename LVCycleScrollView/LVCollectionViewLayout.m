//
//  LVCollectionViewLayout.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVCollectionViewLayout.h"
#import "LVCollectionViewLayoutAttributes.h"

@interface LVCollectionViewLayout ()<UICollectionViewDelegate>

@property (nonatomic, assign) LVImageScrollType scrollType;

/// 所有的item的属性数组
@property (nonatomic,strong) NSMutableArray *attributeArray;


@end

@implementation LVCollectionViewLayout
{
    CGFloat   _viewHeight;// 竖直滚动表示collectionView高,水平表示宽
    CGFloat   _itemHeight;// 竖直滚动表示cell高,水平表示宽
    NSInteger _cellCount;
}

/*
接下来需要告诉collection view使用自定义的类而不是系统的UICollectionViewLayoutAttributes类，需要在自定义的LVCollectionViewLayout中重写类方法+(Class)layoutAttributesClass
 */
+ (Class)layoutAttributesClass{
    return [LVCollectionViewLayoutAttributes class];
}

- (instancetype)initWithImageScrollType:(LVImageScrollType)scrollType
{
    if (self = [super init]) {
        self.scrollType = scrollType;
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.zoomScale = kZoomScale;
    self.radius = kImageSevenRadius;
    self.anglePerItem = kAnglePerItem;
    self.rotationAngle = kRotationAngle;
    self.visibleCount = kVisibleCount;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        _viewHeight = CGRectGetHeight(self.collectionView.frame);
        _itemHeight = self.itemSize.height + self.space;
        if (self.scrollType != LVImageScrollCardSeven) {
            self.collectionView.contentInset = UIEdgeInsetsMake((_viewHeight - _itemHeight) / 2, 0, (_viewHeight - _itemHeight) / 2, 0);
        }
    } else {
        _viewHeight = CGRectGetWidth(self.collectionView.frame);
        _itemHeight = self.itemSize.width + self.space;
        if (self.scrollType != LVImageScrollCardSeven) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewHeight - _itemHeight) / 2, 0, (_viewHeight - _itemHeight) / 2);
        }
    }
    
    [self.attributeArray removeAllObjects];
    
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    if (_cellCount == 0) {
        return;
    }
    
    /// 获取总的旋转的角度
    CGFloat angleAtExtreme = (_cellCount - 1) * self.anglePerItem;
    /// 随着UICollectionView的移动，第0个cell初始时的角度
    CGFloat angle;
    //// 锚点的位置
    CGFloat anchorPoint;
    
    NSInteger minIndex = 0;
    NSInteger maxIndex = _cellCount - 1;
    if (self.visibleCount <= 0) {
        NSAssert(NO, @"visibleCount不能小于等于0");
    }else {
        NSInteger index = 0;
        if (self.scrollType != LVImageScrollCardSeven) {
            CGFloat centerY = (self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.collectionView.contentOffset.y : self.collectionView.contentOffset.x) + _viewHeight / 2;
            index = centerY / _itemHeight;
        }else {
            CGFloat factor;
            // 默认停下来时，旋转的角度
            CGFloat proposedAngle;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                factor = angleAtExtreme / (self.collectionView.contentSize.height - _viewHeight);
                proposedAngle = factor * self.collectionView.contentOffset.y;

            }else {
                factor = angleAtExtreme / (self.collectionView.contentSize.width - _viewHeight);
                proposedAngle = factor * self.collectionView.contentOffset.x;
            }
            CGFloat ratio = proposedAngle / _anglePerItem;
            index = roundf(ratio);

        }
        if (index < 0) {
            index = 0;
        }
        if (index >= _cellCount) {
            index = _cellCount - 1;
        }

        NSInteger count = (self.visibleCount - 1) / 2;
        minIndex = MAX(0, (index - count));
        maxIndex = MIN((_cellCount - 1), (index + count));
    }

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        angle = - angleAtExtreme * self.collectionView.contentOffset.y / (self.collectionView.contentSize.height - _viewHeight);
        anchorPoint = (self.itemSize.width/2.0 + self.radius) / self.itemSize.width;
    }else {
        angle = - angleAtExtreme * self.collectionView.contentOffset.x / (self.collectionView.contentSize.width - _viewHeight);
        anchorPoint = (self.itemSize.height/2.0 + self.radius) / self.itemSize.height;
    }
    
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        LVCollectionViewLayoutAttributes *attribute = [LVCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attribute.size = self.itemSize;
        CGFloat rowCenter = _itemHeight * i + _itemHeight / 2;
        
        CGFloat center = (self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.collectionView.contentOffset.y : self.collectionView.contentOffset.x) + _viewHeight / 2;
        
        switch (self.scrollType) {
            case LVImageScrollCardOne:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                CGFloat scale = 1 - ABS(ratio) * (1 - self.zoomScale);
                attribute.transform = CGAffineTransformMakeScale(scale, scale);
                
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                } else {
                    attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                }
                
            }
                break;
            case LVImageScrollCardTwo:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                CGFloat scale = 1 - ABS(ratio) * (1 - self.zoomScale);
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    if (delta == 0) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width * scale, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                    }
                }else {
                    if (delta == 0) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width , self.itemSize.height * scale);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                    }
                }
            }
                break;
            case LVImageScrollCardThird:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                CGFloat scale = 1 - ABS(ratio) * (1 - self.zoomScale);
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    if ((delta > -_itemHeight && delta < 0) || (delta > 0 && delta < _itemHeight)) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width * scale, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                    }else if (delta == 0){
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width * self.zoomScale, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                    }
                }else {
                    if ((delta > -_itemHeight && delta < 0) || (delta > 0 && delta < _itemHeight)) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width , self.itemSize.height * scale);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                    }else if (delta == 0){
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height * self.zoomScale);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                    }
                }
            }
                break;
            case LVImageScrollCardFour:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                CGFloat scale = 1 - ABS(ratio) * (1 - self.zoomScale);
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    if ((delta > -_itemHeight && delta < 0) || (delta > 0 && delta < _itemHeight)) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width * scale, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2 - self.itemSize.width * ((1 - self.zoomScale)/2) * ABS(ratio), rowCenter);
                    }else if (delta == 0){
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width * self.zoomScale, self.itemSize.height);
                        attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2 - self.itemSize.width * ((1 - self.zoomScale)/2), rowCenter);
                    }
                }else {
                    if ((delta > -_itemHeight && delta < 0) || (delta > 0 && delta < _itemHeight)) {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height * scale);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2 + self.itemSize.height * ((1 - self.zoomScale)/2) * ABS(ratio));
                    }else if (delta == 0){
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                    }else {
                        attribute.frame = CGRectMake(attribute.frame.origin.x, attribute.frame.origin.y, self.itemSize.width, self.itemSize.height * self.zoomScale);
                        attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2 + self.itemSize.height * ((1 - self.zoomScale)/2));
                    }
                }
            }
                break;
            case LVImageScrollCardFive:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                attribute.transform = CGAffineTransformRotate(attribute.transform, - ratio * self.rotationAngle);
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                }else {
                    attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                }
                attribute.zIndex = (int)(-1) *i *1000;
            }
                break;
            case LVImageScrollCardSix:
            {
                CGFloat delta = center - rowCenter;
                CGFloat ratio =  - delta / _itemHeight;
                CATransform3D transform = CATransform3DIdentity;
                transform.m34 = -1.0/400.0f;
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    transform = CATransform3DRotate(transform, ratio * self.rotationAngle, 1, 0, 0);
                    attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                }else {
                    transform = CATransform3DRotate(transform, -ratio * self.rotationAngle, 0, 1, 0);
                    attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                }
                attribute.transform3D = transform;
            }
                break;
            case LVImageScrollCardSeven:
            {
                attribute.angle = angle + self.anglePerItem *i;
                attribute.scrollDirection = self.scrollDirection;
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    attribute.anchorPoint = CGPointMake(-anchorPoint, 0.5);
                    attribute.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), center);
                }else {
                    attribute.anchorPoint = CGPointMake(0.5, anchorPoint);
                    attribute.center = CGPointMake(center, CGRectGetMidY(self.collectionView.bounds));
                    
                }
                attribute.transform = CGAffineTransformMakeRotation(attribute.angle);
                attribute.zIndex = (int)(-1) *i *1000;
            }
                break;
            default:
            {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    attribute.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, rowCenter);
                } else {
                    attribute.center = CGPointMake(rowCenter, CGRectGetHeight(self.collectionView.frame) / 2);
                }
            }
                break;
        }

        
        [self.attributeArray addObject:attribute];
    }
    
}

- (CGSize)collectionViewContentSize {
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (self.scrollType == LVImageScrollCardSeven) {
            // UICollectionView不满一屏时，无法滚动
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame), _cellCount * self.itemSize.height + _viewHeight);
        }
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), _cellCount * _itemHeight);
    }else {
        if (self.scrollType == LVImageScrollCardSeven) {
            // 加上_viewHeight是因为UICollectionView不满一屏时，无法滚动,并且加上了滚动会丝滑点,具体原因以后再学习
            return CGSizeMake(_cellCount * self.itemSize.width + _viewHeight, CGRectGetHeight(self.collectionView.frame));
        }
        return CGSizeMake(_cellCount * _itemHeight, CGRectGetHeight(self.collectionView.frame));
    }
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributeArray;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 预期停下来original
    CGPoint finalContentOffset = proposedContentOffset;
    if (self.scrollType == LVImageScrollCardSeven) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            // 影响参数
            CGFloat angleAtExtreme = (_cellCount - 1) * self.anglePerItem;
            CGFloat factor = -angleAtExtreme / (self.collectionView.contentSize.height - _viewHeight);

            // 默认停下来时，旋转的角度
            CGFloat proposedAngle = factor * self.collectionView.contentOffset.y;
            CGFloat ratio = proposedAngle / self.anglePerItem;

            CGFloat multiplier = 0;
            if (velocity.y > 0) {
                //向下运动
                if (self.currentIndex) {
                    multiplier = _currentIndex.integerValue - 1;
                }else {
                    multiplier = ceil(ratio);
                }
                
            }else if (velocity.y < 0){
                //向上运动
                if (self.currentIndex) {
                    multiplier = _currentIndex.integerValue + 1;
                }else {
                    multiplier = floor(ratio);
                }
            }else{
                //速度为0
                multiplier = round(ratio);
            }
            finalContentOffset.y = multiplier * self.anglePerItem / factor;
        }else {
            // 影响参数
            CGFloat angleAtExtreme = (_cellCount - 1) * self.anglePerItem;
            CGFloat factor = -angleAtExtreme / (self.collectionView.contentSize.width - _viewHeight);

            // 默认停下来时，旋转的角度
            CGFloat proposedAngle = factor * self.collectionView.contentOffset.x;
            CGFloat ratio = proposedAngle / self.anglePerItem;

            CGFloat multiplier = 0;
            if (velocity.x > 0) {
                //向右运动
                if (self.currentIndex) {
                    multiplier = _currentIndex.integerValue - 1;
                }else {
                    multiplier = ceil(ratio);
                }
                
            }else if (velocity.x < 0){
                //向左运动
                if (self.currentIndex) {
                    multiplier = _currentIndex.integerValue + 1;
                }else {
                    multiplier = floor(ratio);
                }
            }else{
                //速度为0
                multiplier = round(ratio);
            }
            finalContentOffset.x = multiplier * self.anglePerItem / factor;
        }
        
    }else {
        CGFloat index;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            index = roundf((proposedContentOffset.y + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
        }else {
            index = roundf((proposedContentOffset.x + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
        }
        
        if (self.currentIndex) {
            if (index > _currentIndex.integerValue) {
                index = _currentIndex.integerValue +1;
            }else {
                index = _currentIndex.integerValue -1;
            }
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            finalContentOffset.y = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
        } else {
            finalContentOffset.x = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
        }
    }
    return finalContentOffset;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


#pragma mark - Setter && Getter
- (NSMutableArray *)attributeArray{
    if (!_attributeArray) {
        _attributeArray = [[NSMutableArray alloc]init];
    }
    return _attributeArray;
}

@end
