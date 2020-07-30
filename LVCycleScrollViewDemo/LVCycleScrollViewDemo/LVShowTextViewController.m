//
//  LVShowTextViewController.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/7/30.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVShowTextViewController.h"
#import "LVMainViewController.h"
#import "LVCycleScrollView.h"

@interface LVShowTextViewController ()

@end

@implementation LVShowTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat navBarHeight = iPhoneX ? 88 : 64;
    
    if (self.index == 0) {
        self.title = @"无样式";
        //无间隙效果
        LVCycleScrollView *view = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 10, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        [self.view addSubview:view];
        
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 60, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view1.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view1.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        [self.view addSubview:view1];
        
        //有间隙效果,可以用属性space制作间隙的效果
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 110, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view2.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view2.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        view2.space = self.view.frame.size.width;
        view2.infiniteLoop = YES;
        view2.scrollTime = 2;
        [self.view addSubview:view2];
        
        LVCycleScrollView *view3 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 160, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view3.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view3.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        view3.space = 40;
        view3.infiniteLoop = YES;
        view3.scrollTime = 2;
        [self.view addSubview:view3];
        
        //由于间隙的地方的背景颜色和cell的背景颜色不一样,可以把控件的背景颜色设置成cell的颜色,cell的颜色设置成透明色
        LVCycleScrollView *view4 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 210, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view4.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view4.textBackgroundColor = [UIColor clearColor];
        view4.backgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        view4.space = self.view.frame.size.width;
        view4.scrollTime = 2;
        [self.view addSubview:view4];
        
        LVCycleScrollView *view5 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 260, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view5.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view5.textBackgroundColor = [UIColor clearColor];
        view5.backgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        view5.space = 40;
        view5.scrollTime = 2;
        [self.view addSubview:view5];
        
        // 圆角,控件属性cellCornerRadius可以修改cell的圆角,而控件的圆角直接修改cornerRadius
        LVCycleScrollView *view6 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 310, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view6.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view6.textBackgroundColor = [UIColor clearColor];
        view6.backgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        view6.space = 40;
        view6.scrollTime = 2;
        view6.layer.masksToBounds = YES;
        view6.layer.cornerRadius = 10.f;
        [self.view addSubview:view6];
    }else {
        self.title = [NSString stringWithFormat:@"样式%ld",self.index];
        LVCycleScrollView *view = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 10, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        if (self.index == 1) {
            view.textScrollMode = LVTextScrollModeOne;
        }else if (self.index == 2){
            view.textScrollMode = LVTextScrollModeTwo;
        }else if (self.index == 3){
            view.textScrollMode = LVTextScrollModeThird;
        }else if (self.index == 4){
            view.textScrollMode = LVTextScrollModeFour;
        }
        [self.view addSubview:view];
        
        LVCycleScrollView *view1 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 60, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view1.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白",@"想要欣赏妾身的舞姿吗?"];
        view1.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        if (self.index == 1) {
            view1.textScrollMode = LVTextScrollModeOne;
        }else if (self.index == 2){
            view1.textScrollMode = LVTextScrollModeTwo;
        }else if (self.index == 3){
            view1.textScrollMode = LVTextScrollModeThird;
        }else if (self.index == 4){
            view1.textScrollMode = LVTextScrollModeFour;
        }
        [self.view addSubview:view1];
        
        LVCycleScrollView *view2 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 110, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view2.titlesArray = @[@"多喜欢阿离一点,可以吗?"];
        view2.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        if (self.index == 1) {
            view2.textScrollMode = LVTextScrollModeOne;
        }else if (self.index == 2){
            view2.textScrollMode = LVTextScrollModeTwo;
        }else if (self.index == 3){
            view2.textScrollMode = LVTextScrollModeThird;
        }else if (self.index == 4){
            view2.textScrollMode = LVTextScrollModeFour;
        }
        [self.view addSubview:view2];
        
        LVCycleScrollView *view3 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 160, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view3.titlesArray = @[@"多喜欢阿离一点,可以吗?"];
        view3.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        if (self.index == 1) {
            view3.textScrollMode = LVTextScrollModeOne;
        }else if (self.index == 2){
            view3.textScrollMode = LVTextScrollModeTwo;
        }else if (self.index == 3){
            view3.textScrollMode = LVTextScrollModeThird;
        }else if (self.index == 4){
            view3.textScrollMode = LVTextScrollModeFour;
        }
        [self.view addSubview:view3];
        
        // 滚动速度,使用speed
        LVCycleScrollView *view4 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 210, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionHorizontal];
        view4.titlesArray = @[@"多喜欢阿离一点,可以吗?"];
        view4.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        if (self.index == 1) {
            view4.textScrollMode = LVTextScrollModeOne;
        }else if (self.index == 2){
            view4.textScrollMode = LVTextScrollModeTwo;
        }else if (self.index == 3){
            view4.textScrollMode = LVTextScrollModeThird;
        }else if (self.index == 4){
            view4.textScrollMode = LVTextScrollModeFour;
        }
        view4.speed = 0.05;
        [self.view addSubview:view4];
        
        LVCycleScrollView *view5 = [[LVCycleScrollView alloc] initWithFrame:CGRectMake(0, navBarHeight + 260, self.view.frame.size.width, 40) itemSize:CGSizeMake(self.view.frame.size.width, 40) scrollType:LVOnlyTextScroll scrollDirection:UICollectionViewScrollDirectionVertical];
        view5.titlesArray = @[@"多喜欢阿离一点,可以吗?"];
        view5.textBackgroundColor = [UIColor colorWithRed:64/255.f green:151/255.f blue:255/255.f alpha:0.5];
        if (self.index == 1) {
            view5.textScrollMode = LVTextScrollModeOne;
        }else if (self.index == 2){
            view5.textScrollMode = LVTextScrollModeTwo;
        }else if (self.index == 3){
            view5.textScrollMode = LVTextScrollModeThird;
        }else if (self.index == 4){
            view5.textScrollMode = LVTextScrollModeFour;
        }
        view5.speed = 0.01;
        [self.view addSubview:view5];
        
        
    }
    

}


@end
