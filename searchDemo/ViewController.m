//
//  ViewController.m
//  searchDemo
//
//  Created by ZhuKan on 2017/9/27.
//  Copyright © 2017年 ZhuKan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化
    for (int i = 0; i < 100; i++) {
        NSString *str = [NSString stringWithFormat:@"测试数据%d", i];
        [self.datas addObject:str];
    }
    
    //大标题
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    self.navigationItem.title = @"测试";
    
    //safe area
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.safeAreaInsets));
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.adjustedContentInset));
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    //search navigation item
    self.navigationItem.hidesSearchBarWhenScrolling = YES;
    UISearchController *searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchVC.delegate = self;
    searchVC.searchResultsUpdater = self;
    searchVC.searchBar.delegate = self;
    searchVC.dimsBackgroundDuringPresentation = NO;
    self.searchController = searchVC;
    self.navigationItem.searchController = searchVC;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Methods
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}

- (NSMutableArray *)results
{
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *inputStr = searchController.searchBar.text ;
    NSLog(@"%@",inputStr);
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    for (NSString *str in self.datas) {
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            [self.results addObject:str];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.results.count ;
    }
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    if (self.searchController.active ) {
        cell.textLabel.text = [self.results objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
    } else {
        NSLog(@"选择了列表中的%@", [self.datas objectAtIndex:indexPath.row]);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}


@end
