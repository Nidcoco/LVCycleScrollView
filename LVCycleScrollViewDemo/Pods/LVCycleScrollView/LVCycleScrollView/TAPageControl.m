//
//  TAPageControl.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-21.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAPageControl.h"
#import "TADotView.h"

/**
 *  Default number of pages for initialization
 */
static NSInteger const kDefaultNumberOfPages = 0;

/**
 *  Default current page for initialization
 */
static NSInteger const kDefaultCurrentPage = 0;

/**
 *  Default setting for shouldResizeFromCenter. For initialiation
 */
static BOOL const kDefaultShouldResizeFromCenter = YES;

/**
 *  Default spacing between dots
 */
static NSInteger const kDefaultSpacingBetweenDots = 8;


@interface TAPageControl()


/**
 *  Array of dot views for reusability and touch events.
 */
@property (strong, nonatomic) NSMutableArray *dots;


@end

@implementation TAPageControl


#pragma mark - Lifecycle


- (id)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}


/**
 *  Default setup when initiating control
 */
- (void)initialization
{
    self.dotViewClass           = [TADotView class];
    self.spacingBetweenDots     = kDefaultSpacingBetweenDots;
    self.numberOfPages          = kDefaultNumberOfPages;
    self.currentPage            = kDefaultCurrentPage;
    self.shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
}


#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.dots indexOfObject:touch.view];
        if ([self.delegate respondsToSelector:@selector(TAPageControl:didSelectPageAtIndex:)]) {
            [self.delegate TAPageControl:self didSelectPageAtIndex:index];
        }
    }
}

#pragma mark - Layout


/**
 *  Resizes and moves the receiver view so it just encloses its subviews.
 */
- (void)sizeToFit
{
    [self updateFrame:YES];
}


- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    return CGSizeMake((self.dotSize.width + self.spacingBetweenDots) * pageCount - self.spacingBetweenDots , self.dotSize.height);
}


/**
 *  Will update dots display and frame. Reuse existing views or instantiate one if required. Update their position in case frame changed.
 */
- (void)updateDots
{
    if (self.numberOfPages == 0) {
        return;
    }
    
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        
        UIView *dot;
        if (i < self.dots.count) {
            dot = [self.dots objectAtIndex:i];
        } else {
            dot = [self generateDotView];
        }
        
        [self updateDotFrame:dot atIndex:i];
    }
    
    [self changeActivity:YES atIndex:self.currentPage];
}


/**
 *  Update frame control to fit current number of pages. It will apply required size if authorize and required.
 *
 *  @param overrideExistingFrame BOOL to allow frame to be overriden. Meaning the required size will be apply no mattter what.
 */
- (void)updateFrame:(BOOL)overrideExistingFrame
{
    CGPoint center = self.center;
    CGSize requiredSize = [self sizeForNumberOfPages:self.numberOfPages];
    
    // We apply requiredSize only if authorize to and necessary
    if (overrideExistingFrame || ((CGRectGetWidth(self.frame) < requiredSize.width || CGRectGetHeight(self.frame) < requiredSize.height) && !overrideExistingFrame)) {
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), requiredSize.width, requiredSize.height);
        if (self.shouldResizeFromCenter) {
            self.center = center;
        }
    }
    
    [self resetDotViews];
}


/**
 *  Update the frame of a specific dot at a specific index
 *
 *  @param dot   Dot view
 *  @param index Page index of dot
 */
- (void)updateDotFrame:(UIView *)dot atIndex:(NSInteger)index
{
    // Dots are always centered within view
    CGFloat x = (self.dotSize.width + self.spacingBetweenDots) * index + ( (CGRectGetWidth(self.frame) - [self sizeForNumberOfPages:self.numberOfPages].width) / 2);
    CGFloat y = (CGRectGetHeight(self.frame) - self.dotSize.height) / 2;
    
    dot.frame = CGRectMake(x, y, self.dotSize.width, self.dotSize.height);
}


#pragma mark - Utils


/**
 *  Generate a dot view and add it to the collection
 *
 *  @return The UIView object representing a dot
 */
- (UIView *)generateDotView
{
    UIView *dotView = [[self.dotViewClass alloc] initWithFrame:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height)];
    dotView.clipsToBounds =YES;
    if (self.pointDotColor) {
        ((TADotView *)dotView).backgroundColor = self.pointDotColor;
    }
    
    ((TADotView *)dotView).alpha = self.pointDotAlpha;
    ((TADotView *)dotView).cornerRadius = self.cornerRadius;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.dotImage];
    imageView.frame = dotView.frame;
    [dotView addSubview:imageView];
    
    if (dotView) {
        [self addSubview:dotView];
        [self.dots addObject:dotView];
    }
    
    dotView.userInteractionEnabled = YES;
    
    return dotView;
}


/**
 *  Change activity state of a dot view. Current/not currrent.
 *
 *  @param active Active state to apply
 *  @param index  Index of dot for state update
 */
- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index
{
    TADotView *abstractDotView = (TADotView *)[self.dots objectAtIndex:index];
    abstractDotView.alpha = active ? self.currentPointDotAlpha : self.pointDotAlpha;
    abstractDotView.backgroundColor = active ? self.currentPointDotColor : self.pointDotColor;

    if ([abstractDotView respondsToSelector:@selector(changeActivityState:)]) {
        [abstractDotView changeActivityState:active pointRotationAngle:self.pointRotationAngle pointZoomSize:self.pointZoomSize];
    } else {
        NSLog(@"Custom view : %@ must implement an 'changeActivityState' method or you can subclass %@ to help you.", self.dotViewClass, [TADotView class]);
    }
    
    if (self.dotImage && self.currentDotImage) {
        UIImageView *dotView = (UIImageView *)abstractDotView.subviews.firstObject;
        dotView.image = (active) ? self.currentDotImage : self.dotImage;
    }
}


- (void)resetDotViews
{
    for (UIView *dotView in self.dots) {
        [dotView removeFromSuperview];
    }
    
    [self.dots removeAllObjects];
    [self updateDots];
}


#pragma mark - Setters

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    if (self.dots.count) {
        [self resetDotViews];
    }
}

- (void)setPointZoomSize:(CGFloat)pointZoomSize
{
    _pointZoomSize = pointZoomSize;
    
    if (self.dots.count) {
        [self resetDotViews];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    // If no pages, no current page to treat.
    if (self.numberOfPages == 0 || currentPage == _currentPage) {
        _currentPage = currentPage;
        return;
    }
    
    // Pre set
    [self changeActivity:NO atIndex:_currentPage];
    _currentPage = currentPage;
    // Post set
    [self changeActivity:YES atIndex:_currentPage];
}


- (void)setDotImage:(UIImage *)dotImage
{
    _dotImage = dotImage;
    if (self.dots.count) {
        [self resetDotViews];
    }
}


- (void)setCurrentDotImage:(UIImage *)currentDotimage
{
    _currentDotImage = currentDotimage;
    if (self.dots.count) {
        [self resetDotViews];
    }
}


#pragma mark - Getters

- (NSMutableArray *)dots
{
    if (!_dots) {
        _dots = [[NSMutableArray alloc] init];
    }
    
    return _dots;
}

@end
