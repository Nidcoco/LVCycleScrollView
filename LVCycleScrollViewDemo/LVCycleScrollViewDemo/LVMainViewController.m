//
//  LVMainViewController.m
//  LVCycleScrollViewDemo
//
//  Created by Levi on 2020/7/30.
//  Copyright © 2020 None. All rights reserved.
//

#import "LVMainViewController.h"
#import "LVShowViewController.h"
#import "LVShowXibViewController.h"

@interface LVMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation LVMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main";
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
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"文字样式";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"图片无样式";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"图片xib加载";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"分页控件设置";
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"图片样式%ld",indexPath.row - 3];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        LVShowXibViewController *vc = [LVShowXibViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LVShowViewController *vc = [LVShowViewController new];
        vc.index = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
