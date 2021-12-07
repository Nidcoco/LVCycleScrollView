//
//  LVShowXibViewController.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2021/12/4.
//  Copyright © 2021 None. All rights reserved.
//

#import "LVShowXibViewController.h"
#import "LVCycleScrollView.h"

@interface LVShowXibViewController ()

@property (weak, nonatomic) IBOutlet LVCycleScrollView *cycleView;
@property (weak, nonatomic) IBOutlet LVCycleScrollView *textCycleView;


@end

@implementation LVShowXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cycleView.imagesArray = @[@"1",@"2",@"3",@"4"];
    
    self.textCycleView.titlesArray = @[@"多喜欢阿离一点,可以吗?",@"吟诵十四行诗，作为仲夏之梦的开场",@"见过我家那只可爱的宠物吗?它的名字叫大白"];
}


@end
