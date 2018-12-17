//
//  DNViewController.m
//  DNVideoPlayer
//
//  Created by 563620078@qq.com on 12/12/2018.
//  Copyright (c) 2018 563620078@qq.com. All rights reserved.
//

#import "DNViewController.h"
#import "DNBottomWebMainView.h"
#import "DNDetailVideoListViewController.h"

static NSString *kIdentifier = @"kIdentifier";

@interface DNViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation DNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"VideoPlayer";
    [self.view addSubview:self.tableView];
    self.titles = @[
                    @"底部加载广告Web类型",
                    @"列表点击播放",
                    @"列表自动播放"
                    ];

    self.viewControllers = @[
                             @"DNBottomWebViewController",
                             @"DNDetailVideoListViewController",
                             @"DNListVideoAutoPlayViewController"
                             ];

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate {
    return NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexZPath:indexPath animated:YES];
    NSString *vcString = self.viewControllers[indexPath.row];
    UIViewController *viewController = [[NSClassFromString(vcString) alloc] init];
    viewController.navigationItem.title = self.titles[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
