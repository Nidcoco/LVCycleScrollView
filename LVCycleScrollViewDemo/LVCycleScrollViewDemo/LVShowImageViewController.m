//
//  LVShowImageViewController.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/7/30.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVShowImageViewController.h"
#import "LVMainViewController.h"
#import "LVCycleScrollView.h"

@interface LVShowImageViewController ()

@end

@implementation LVShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat navBarHeight = iPhoneX ? 88 : 64;
    
    if (self.index == 0) {
        self.title = @"无样式";

        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, 250) itemSize:CGSizeMake(self.view.frame.size.width, 250) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view1.imagesArray = @[@"1",@"2",@"3",@"4"];
        [self.view addSubview:view1];
        
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 250 + 10, self.view.frame.size.width, 250) itemSize:CGSizeMake(self.view.frame.size.width, 250) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view2.infiniteLoop = YES;
        view2.imagesArray = @[@"1",@"2",@"3",@"4"];
        view2.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view2.textLabelTextAlignment = NSTextAlignmentRight;
        view2.pageControlAliment = LVPageControlLeft;
        view2.pageControlRotationAngle = M_PI;
        view2.pageControlCornerRadius = 0;
        [self.view addSubview:view2];
        
        LVCycleScrollView *view3 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 250 + 250 + 20, self.view.frame.size.width, 250) itemSize:CGSizeMake(self.view.frame.size.width, 250) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view3.imagesArray = @[@"1",@"2",@"3",@"4"];
        [self.view addSubview:view3];
    }else {
        self.title = [NSString stringWithFormat:@"样式%ld",self.index];
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, 125) itemSize:CGSizeMake(200, 250) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view1.imagesArray = @[@"5",@"6",@"7",@"8"];
        if (self.index == 1) {
            view1.imageScrollType = LVImageScrollCardOne;
        }else if (self.index == 2) {
            view1.imageScrollType = LVImageScrollCardTwo;
            view1.space = 30;
        }else if (self.index == 3) {
            view1.imageScrollType = LVImageScrollCardThird;
            view1.space = 30;
        }
        view1.cellCornerRadius = 10.f;
        [self.view addSubview:view1];
        
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 260, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - 260) itemSize:CGSizeMake(100, 125) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view2.imagesArray = @[@"5",@"6",@"7",@"8"];
        if (self.index == 1) {
            view2.imageScrollType = LVImageScrollCardOne;
        }else if (self.index == 2) {
            view2.imageScrollType = LVImageScrollCardTwo;
        }else if (self.index == 3) {
            view2.imageScrollType = LVImageScrollCardThird;
        }
        view2.cellCornerRadius = 5.f;
        [self.view addSubview:view2];
    }
    
    
}


@end
