//
//  LVImageViewController.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/7/30.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVImageViewController.h"
#import "LVMainViewController.h"
#import "LVShowImageViewController.h"

@interface LVImageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation LVImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Image";
    CGFloat navBarHeight = iPhoneX ? 88 : 64;
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height - navBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.myTableView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"无样式";
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"样式%ld",indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LVShowImageViewController *vc = [LVShowImageViewController new];
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
