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

        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, 200) itemSize:CGSizeMake(self.view.frame.size.width, 200) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view1.imagesArray = @[@"1",@"2",@"3",@"4"];
        [self.view addSubview:view1];
        
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 200 + 10, self.view.frame.size.width, 200) itemSize:CGSizeMake(self.view.frame.size.width, 200) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view2.infiniteLoop = YES;
        view2.imagesArray = @[@"1",@"2",@"3",@"4"];
        view2.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view2.pageControlAliment = LVPageControlRight;
        view2.pageControlRotationAngle = M_PI;
        view2.pageControlCornerRadius = 0;
        [self.view addSubview:view2];
        
        LVCycleScrollView *view3 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 420, self.view.frame.size.width, 200) itemSize:CGSizeMake(self.view.frame.size.width, 200) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view3.imagesArray = @[@"1",@"2",@"3",@"4"];
        [self.view addSubview:view3];
    }else {
        self.title = [NSString stringWithFormat:@"样式%ld",self.index];
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, 200) itemSize:CGSizeMake(160, 200) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view1.imagesArray = @[@"5",@"6",@"7",@"8"];
        if (self.index == 1) {
            view1.imageScrollType = LVImageScrollCardOne;
            view1.titlesArray = @[@"多喜欢阿离一点,可以吗?果然,想征服爱人的心",@"垂涎于我美貌的人 都在冰原下冷静反省",@"美男子们~恭候等待朕的收割吧！叫我女王陛下！",@"大小姐驾到，通通闪开.来一发吗？满足你"];
            view1.textLabelNumberOfLines = 0;
            view1.textLabelHeight = 50;
        }else if (self.index == 2) {
            view1.imageScrollType = LVImageScrollCardTwo;
            view1.space = 30;
        }else if (self.index == 3) {
            view1.imageScrollType = LVImageScrollCardThird;
            view1.space = 30;
        }else if (self.index == 4) {
            view1.imageScrollType = LVImageScrollCardFour;
        }else if (self.index == 5) {
            view1.imageScrollType = LVImageScrollCardFive;
            view1.space = 70;
        }else if (self.index == 6) {
            view1.imageScrollType = LVImageScrollCardSix;
        }else if (self.index == 7) {
            view1.imageScrollType = LVImageScrollCardSeven;
            view1.radius = 1000;
        }
        view1.cellCornerRadius = 10.f;
        [self.view addSubview:view1];
        
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 210, self.view.frame.size.width, self.view.frame.size.height - navBarHeight - 210) itemSize:CGSizeMake(100, 125) scrollType:LVImageScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view2.imagesArray = @[@"5",@"6",@"7",@"8"];
        if (self.index == 1) {
            view2.imageScrollType = LVImageScrollCardOne;
        }else if (self.index == 2) {
            view2.imageScrollType = LVImageScrollCardTwo;
        }else if (self.index == 3) {
            view2.imageScrollType = LVImageScrollCardThird;
        }else if (self.index == 4) {
            view2.imageScrollType = LVImageScrollCardFour;
        }else if (self.index == 5) {
            view2.imageScrollType = LVImageScrollCardFive;
            view2.space = 35;
        }else if (self.index == 6) {
            view2.imageScrollType = LVImageScrollCardSix;
        }else if (self.index == 7) {
            view2.imageScrollType = LVImageScrollCardSeven;
        }
        [self.view addSubview:view2];
    }
    
    
}


@end
