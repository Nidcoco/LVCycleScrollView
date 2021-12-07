//
//  LVPageControl.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2021/12/6.
//  Copyright © 2021 None. All rights reserved.
//

#import "LVPageControl.h"

@interface LVPageControl ()

@property (nonatomic, strong) NSMutableArray *dotViewArrayM;
@property (nonatomic, assign) BOOL isInitialize;
@property (nonatomic, assign) BOOL inAnimating;

@property (nonatomic, strong) UIView *currentView;

@property (nonatomic, assign) CGFloat currentX;

@end

@implementation LVPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.otherDotColor = [UIColor lightGrayColor];
        self.currentDotColor = [UIButton buttonWithType:UIButtonTypeSystem].tintColor;
        self.isInitialize = YES;
        self.inAnimating = NO;
        self.dotViewArrayM = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateUI];
}

- (void)updateUI {
    if (self.dotViewArrayM.count == 0) return;
    if (self.isInitialize) {
        self.isInitialize = NO;
        CGFloat totalWidth = self.currentDotWidth + (self.numberOfPages - 1) * (self.dotSpace + self.otherDotWidth);
        CGFloat currentX = (self.frame.size.width - totalWidth) / 2;
        for (int i = 0; i < self.dotViewArrayM.count; i++) {
            UIView *dotView = self.dotViewArrayM[i];
            
            // 更新位置
            CGFloat width = (i == 0 ? self.currentDotWidth : self.otherDotWidth);
            CGFloat height = self.dotHeight;
            CGFloat x = currentX;
            CGFloat y = (self.frame.size.height - height) / 2;
            dotView.frame = CGRectMake(x, y, width, height);
            
            currentX = currentX + width + self.dotSpace; // 走到下一个点开的开头位置
            
            // 更新颜色
            dotView.backgroundColor = self.otherDotColor;
            if (i == 0) {
                dotView.backgroundColor = self.currentDotColor;
            }
        }
    }
}

#pragma mark ------------------------ Setter ------------------------

- (void)setNumberOfPages:(int)numberOfPages {
    
    _numberOfPages = numberOfPages;
    
    if (self.dotViewArrayM.count > 0) {
        [self.dotViewArrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [(UIView *)obj removeFromSuperview];
         }];
        [self.dotViewArrayM removeAllObjects];
    }
    
    for (int i = 0; i < numberOfPages; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectZero];
        dotView.layer.cornerRadius = self.cornerRadius;
        [self addSubview:dotView];
        [self.dotViewArrayM addObject:dotView];
    }
    
    self.isInitialize = YES;
    [self setNeedsLayout];
}

- (void)moveCurrentViewWithX:(CGFloat)offsetX
{
    
    if (self.numberOfPages == 0) {
        return;
    }
    
    // 轮播图宽度
    CGFloat onePageLong = [UIScreen mainScreen].bounds.size.width;
    CGFloat totalWidth = self.currentDotWidth + (self.numberOfPages - 1) * (self.dotSpace + self.otherDotWidth);
    CGFloat initX = (self.frame.size.width - totalWidth) / 2;
    
    NSInteger i = 0;
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.dotViewArrayM];
    
    while (offsetX - onePageLong * i >= onePageLong) {
        i ++;
    }
    
    if (i != 0) {
        UIView *firstView = newArray.firstObject;
        [newArray insertObject:firstView atIndex:i + 1];
        [newArray removeObjectAtIndex:0];
    }
    
    UIView *currentView = newArray[i];
    [self bringSubviewToFront:currentView];
    if (offsetX - onePageLong * i < onePageLong/2) {
        CGRect frame = currentView.frame;
        frame.size.width = self.currentDotWidth + (self.dotSpace + self.otherDotWidth) * (offsetX - onePageLong * i)/(onePageLong/2);
        frame.origin.x = initX + (self.dotSpace + self.otherDotWidth) * i;
        currentView.frame = frame;
        
        if (offsetX < self.currentX) {
            UIView *nextView = newArray[i + 1];
            CGRect nextFrame = nextView.frame;
            nextFrame.origin.x = initX + self.dotSpace * (i + 1) + self.otherDotWidth * i + self.currentDotWidth;
            nextView.frame = nextFrame;
        }
        
    } else {
        CGRect frame = currentView.frame;
        frame.origin.x = initX + (self.dotSpace + self.otherDotWidth) * i + (self.otherDotWidth + self.dotSpace) * (offsetX - onePageLong * i - onePageLong/2)/(onePageLong/2);
        frame.size.width = self.currentDotWidth + self.dotSpace + self.otherDotWidth - (self.dotSpace + self.otherDotWidth) * (offsetX - onePageLong * i - onePageLong/2)/(onePageLong/2);
        currentView.frame = frame;
        
        
        if (offsetX > self.currentX) {
            UIView *nextView = newArray[i + 1];
            CGRect nextFrame = nextView.frame;
            nextFrame.origin.x = initX + (self.dotSpace + self.otherDotWidth) * i;
            nextView.frame = nextFrame;
        }
    }
    
    self.currentX = offsetX;
}

@end
