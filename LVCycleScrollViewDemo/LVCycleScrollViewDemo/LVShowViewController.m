//
//  LVShowImageViewController.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/7/30.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVShowViewController.h"
#import "LVMainViewController.h"
#import "LVCycleScrollView.h"
#import <Masonry/Masonry.h>
#import "LVPageControl.h"

@interface LVShowViewController ()<LVCycleScrollViewDelegate>

@property (nonatomic, weak) LVCycleScrollView *cycleView;

@property (nonatomic, strong) LVPageControl *pageControl;

@end

@implementation LVShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat navBarHeight = iPhoneX ? 88 : 64;
    
    UIScrollView *sView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height - navBarHeight)];
    [self.view addSubview:sView];
    
    if (self.index == 0) {
        self.title = @"文字样式";

        // 简单初始化
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        view1.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view1.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        [sView addSubview:view1];

        // 无限竖直滚动, 添加间隔
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 40)];
        view2.infiniteLoop = YES;
        view2.scrollDirection = UICollectionViewScrollDirectionVertical;
        view2.space = 40;
        view2.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view2.backgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        view2.textBackgroundColor = [UIColor clearColor];
        [sView addSubview:view2];

    } else if (self.index == 1) {
        
        self.title = @"图片无样式";

        // 简单初始化, 推荐
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        /*
         也可以
         LVCycleScrollView *view1 = [[LVCycleScrollView alloc] init];
         view1.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
         */

        view1.imagesArray = @[@"1",@"2",@"3",@"4"];
        [sView addSubview:view1];

        // 竖直滚动方向
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.width, 200)];
        view2.imagesArray = @[@"1",@"2",@"3",@"4"];
        view2.scrollDirection = UICollectionViewScrollDirectionVertical;
        [sView addSubview:view2];
        
        // 模拟网络请求, 延时赋值
        LVCycleScrollView *view3 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 200)];
        [sView addSubview:view3];
        _cycleView = view3;
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:1.];
        
        // 带文字的无限滚动, 文字比图片少
        LVCycleScrollView *view4 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 630, self.view.frame.size.width, 200)];
        view4.imagesArray = @[@"1",@"2",@"3",@"4"];
        view4.infiniteLoop = YES;
        view4.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白"];
        view4.pageControlAliment = LVPageControlRight;
        [sView addSubview:view4];
        
        // 改变item的大小, 添加圆角间隔
        LVCycleScrollView *view5 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 840, self.view.frame.size.width, 200)];
        view5.imagesArray = @[@"5",@"6",@"7",@"8"];
        view5.cellCornerRadius = 10.f;
        view5.space = 20.f;
        view5.itemSize = CGSizeMake(160, 200);
        [sView addSubview:view5];
        
        // 约束
        LVCycleScrollView *view6 = [[LVCycleScrollView alloc] init];
        view6.imagesArray = @[@"1",@"2",@"3",@"4"];
        [sView addSubview:view6];

        [view6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.left.right.offset(0);
            make.top.offset(1050);
            make.height.offset(200);
            make.bottom.offset(0);
        }];
        
    } else if(self.index == 3) {
        self.title = @"分页控件设置";
        sView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.5);
        
        // 设置颜色和透明度
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        view1.imagesArray = @[@"1",@"2",@"3",@"4"];
        view1.pointDotColor = [UIColor blueColor];
        view1.currentPointDotColor = [UIColor redColor];
        view1.pointDotAlpha = 0.5;
        view1.currentPointDotAlpha = 0.5;
        [sView addSubview:view1];
        
        // 改变分页小控件大小, 间隔, 圆角, 旋转
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 210, self.view.frame.size.width, 200)];
        view2.imagesArray = @[@"1",@"2",@"3",@"4"];
        view2.pointDotSize = CGSizeMake(20, 20);
        view2.spacingBetweenDots = 20;
        view2.pointCornerRadius = 0;
        view2.pointRotationAngle = M_PI;
        [sView addSubview:view2];
        
        // 自定义分页小控件图片, 缩放
        LVCycleScrollView *view3 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, 200)];
        view3.imagesArray = @[@"1",@"2",@"3",@"4"];
        view3.pointDotSize = CGSizeMake(12, 12);
        view3.pointCornerRadius = 6;
        view3.currentPointDotImage = [UIImage imageNamed:@"AC_Select"];
        view3.pointDotImage = [UIImage imageNamed:@"AC"];
        view3.pointZoomSize = 1.2;
        [sView addSubview:view3];
        
        // 自定义分页
        LVCycleScrollView *view4 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, 630, self.view.frame.size.width, 200)];
        view4.imagesArray = @[@"1",@"2",@"3",@"4"];
        view4.showPageControl = NO;
        view4.delegate = self;
        [sView addSubview:view4];
        
        [view4 addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(2.0f);
            make.left.offset(0);
            make.centerX.offset(0);
            make.bottom.offset(-5.0f);
        }];
        
    } else {
        NSInteger index = self.index - 3;
        self.title = [NSString stringWithFormat:@"图片样式%ld",index];
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, 200)];
        view1.imagesArray = @[@"5",@"6",@"7",@"8"];
        view1.showPageControl = NO;
        if (index == 1) {
            view1.imageScrollType = LVImageScrollCardOne;
        }else if (index == 2) {
            view1.imageScrollType = LVImageScrollCardTwo;
            view1.space = 30;
        }else if (index == 3) {
            view1.imageScrollType = LVImageScrollCardThird;
            view1.space = 30;
        }else if (index == 4) {
            view1.imageScrollType = LVImageScrollCardFour;
        }else if (index == 5) {
            view1.imageScrollType = LVImageScrollCardFive;
            view1.space = 70;
        }else if (index == 6) {
            view1.imageScrollType = LVImageScrollCardSix;
        }else if (index == 7) {
            view1.imageScrollType = LVImageScrollCardSeven;
            view1.radius = 1000;
        }
        view1.itemSize = CGSizeMake(160, 200);
        view1.cellCornerRadius = 10.f;
        [self.view addSubview:view1];

        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 210, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - 210)];
        view2.imagesArray = @[@"5",@"6",@"7",@"8"];
        if (index == 1) {
            view2.imageScrollType = LVImageScrollCardOne;
        }else if (index == 2) {
            view2.imageScrollType = LVImageScrollCardTwo;
        }else if (index == 3) {
            view2.imageScrollType = LVImageScrollCardThird;
        }else if (index == 4) {
            view2.imageScrollType = LVImageScrollCardFour;
        }else if (index == 5) {
            view2.imageScrollType = LVImageScrollCardFive;
            view2.space = 35;
        }else if (index == 6) {
            view2.imageScrollType = LVImageScrollCardSix;
        }else if (index == 7) {
            view2.imageScrollType = LVImageScrollCardSeven;
        }
        view2.itemSize = CGSizeMake(100, 125);
        view2.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self.view addSubview:view2];
    }
    
    
}

- (void)cycleScrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pageControl moveCurrentViewWithX:scrollView.contentOffset.x];
}

- (void)delayAction
{
    self.cycleView.imagesArray = @[@"1",@"2",@"3",@"4"];
}

- (LVPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[LVPageControl alloc] init];
        _pageControl.cornerRadius = 1;
        _pageControl.dotHeight = 2;
        _pageControl.dotSpace = 3;
        _pageControl.currentDotWidth = 13;
        _pageControl.otherDotWidth = 5;
        _pageControl.otherDotColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5];
        _pageControl.currentDotColor = UIColor.whiteColor;
        _pageControl.numberOfPages = 4;
    }
    return _pageControl;
}

@end
