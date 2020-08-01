//
//  LVLabel.m
//  LVCycleScrollView
//
//  Created by Levi on 2020/7/31.
//

#import "LVLabel.h"

@implementation LVLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
}

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds ,self.edgeInsets) limitedToNumberOfLines:numberOfLines];

    rect.origin.x -= self.edgeInsets.left;

    rect.origin.y -= self.edgeInsets.top;

    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;

    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;

    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
