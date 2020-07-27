//
//  LVCollectionViewLayoutAttributes.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVCollectionViewLayoutAttributes.h"

@implementation LVCollectionViewLayoutAttributes

- (instancetype)init{
    self = [super init];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.angle = 0;
    }
    return self;
}

// 由于布局属性对象可能会被collectionView复制，因此布局属性对象应该遵循NSCoping协议，并实现copyWithZone:方法，否则我们获取的自定义属性会一直是空值。
- (id)copyWithZone:(NSZone *)zone{
    LVCollectionViewLayoutAttributes *attribute = [super copyWithZone:zone];
    attribute.anchorPoint = self.anchorPoint;
    attribute.angle = self.angle;
    attribute.scrollDirection = self.scrollDirection;
    return attribute;
}


@end
