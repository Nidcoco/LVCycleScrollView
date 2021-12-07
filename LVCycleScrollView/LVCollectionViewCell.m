//
//  LVCollectionViewCell.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/5/28.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVCollectionViewCell.h"
#import "LVCollectionViewLayoutAttributes.h"

@implementation LVCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageView];
    // 不设置,改变UICollectionViewLayoutAttributes里面的frame,首个和最后一个图片大小不会随着cell的大小发生变化
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.hidden = YES;
    [self.contentView addSubview:_textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isOnlyText) {
        _textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
    } else {
        CGFloat textLabelW = CGRectGetWidth(self.contentView.bounds);
        CGFloat textLabelH = self.textLabelHeight;
        CGFloat textLabelX = 0;
        CGFloat textLabelY = CGRectGetHeight(self.contentView.bounds) - textLabelH;
        _textLabel.frame = CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH);
    }
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    _textLabel.text = [NSString stringWithFormat:@"%@", text];
    if (_textLabel.hidden) {
        _textLabel.hidden = NO;
    }
}

- (void)setTextFrame:(CGRect)textFrame
{
    _textFrame = textFrame;
    _textLabel.frame = self.textFrame;
}

- (void)setCellCornerRadius:(CGFloat)cellCornerRadius
{
    _cellCornerRadius = cellCornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cellCornerRadius;
}

/*
 对于自定义的属性anchorPoint，必须手动实现这个方法
 注意：该方法声明在UICollectionReusableView类中，适用于cells、supplementary view、decoration views。首先你必须调用父类的实现，然后检查layoutAttributes是否自定义类的实例，来决定是否进行指针的强制转换。
 */
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    //改变锚点(改变锚点会影响center的位置 参考http://www.jianshu.com/p/15f007f40209 )
    LVCollectionViewLayoutAttributes *attribute = (LVCollectionViewLayoutAttributes *)layoutAttributes;
    self.layer.anchorPoint = attribute.anchorPoint;
    if (attribute.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat centerX = (attribute.anchorPoint.x - 0.5)*CGRectGetWidth(self.bounds);
        self.center = CGPointMake(centerX + self.center.x, self.center.y);
    }else {
        CGFloat centerY = (attribute.anchorPoint.y - 0.5)*CGRectGetHeight(self.bounds);
        self.center = CGPointMake(self.center.x, centerY + self.center.y);
    }
}

- (void)setTextLabelBackgroundColor:(UIColor *)textLabelBackgroundColor
{
    _textLabelBackgroundColor = textLabelBackgroundColor;
    _textLabel.backgroundColor = textLabelBackgroundColor;
}

- (void)setTextLabelTextColor:(UIColor *)textLabelTextColor
{
    _textLabelTextColor = textLabelTextColor;
    _textLabel.textColor = textLabelTextColor;
}

- (void)setTextLabelTextFont:(UIFont *)textLabelTextFont
{
    _textLabelTextFont = textLabelTextFont;
    _textLabel.font = textLabelTextFont;
}


@end
