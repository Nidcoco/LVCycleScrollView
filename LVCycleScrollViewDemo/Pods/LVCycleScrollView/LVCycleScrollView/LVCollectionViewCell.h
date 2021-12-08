//
//  LVCollectionViewCell.h
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LVCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LVCollectionViewCell : UICollectionViewCell

/// 图片
@property (nonatomic, strong) UIImageView *imageView;

/// 文字
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIColor *textLabelTextColor;
@property (nonatomic, strong) UIFont *textLabelTextFont;
@property (nonatomic, strong) UIColor *textLabelBackgroundColor;
@property (nonatomic, assign) CGFloat textLabelHeight;

@property (nonatomic, assign) CGFloat cellCornerRadius;

@property (nonatomic, assign) BOOL hasConfigured;

/// 文字的frame
@property (nonatomic, assign) CGRect textFrame;

@property (nonatomic, assign) BOOL isOnlyText;

@end

NS_ASSUME_NONNULL_END
