
//
//  WJMineViewController.m
//  TheMoment
//
//  Created by 王钧 on 16/6/30.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJMineViewController.h"
#import "SettingsViewController.h"
#import "WJMomentViewController.h"
#import "WJWebViewController.h"
#import "WJTextAdd.h"
#import "WJNewsCell.h"

@interface WJMineViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating> {

    // 设置拿到数据的数量
//    NSInteger _size;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *resultArray;

// 搜索条及控制器
@property(nonatomic, strong)UISearchController *searchController;

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

@property (nonatomic, assign) NSInteger size;

@end


@implementation WJMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self creatUI];
    
    
    [self creatNavigationBar];
 
    
    [self getDataWithSize:10];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return _dataArray;
}

#pragma mark - init
- (AFHTTPSessionManager *)requestManager {
    
    if (!_requestManager) {
        _requestManager = [[AFHTTPSessionManager alloc] init];
        _requestManager.responseSerializer.acceptableContentTypes = [[AFJSONResponseSerializer serializer].acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _requestManager;
}


#pragma mark - 拿到数据
- (void)getDataWithSize:(NSInteger)size {
    
    NSString *path = @"http://api.1-blog.com/biz/bizserver/news/list.do";
    NSDictionary *dict = @{@"size":[NSNumber numberWithInteger:size]};
    [self.requestManager POST:path parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"拿到数据源了");
        
        [KVNProgress showSuccessWithStatus:@"一大波消息来了..."];
        [self.dataArray removeAllObjects];
        
        // 拿到数据
        NSArray *array = responseObject[@"detail"];
        if (array.count > 0) {
            NSArray *listArray = [NSArray yy_modelArrayWithClass:[WJNewsModel class] json:array];
            [self.dataArray addObjectsFromArray:listArray];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
                
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"没有请求到数据");
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的网络连接出错了" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        
        [KVNProgress showErrorWithStatus:@"网页加载失败"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 创建界面
- (void)creatUI {
    
    // 关闭自动布局
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //  创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    // 设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 添加到视图上
    [self.view addSubview:_tableView];
    
    if (!_searchController.active) {
        [self addRefresh];
        // 注册cell
        [self.tableView registerNib:[UINib nibWithNibName:@"WJNewsCell" bundle:nil] forCellReuseIdentifier:@"news"];
    }
    
    
    // 创建搜索条
    // 实例化UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchBar.placeholder = @"搜索你的笔记";
    // UISearchController设置代理
    _searchController.searchResultsUpdater = self;
    // 是否隐藏背景
    _searchController.dimsBackgroundDuringPresentation = NO;
    // 是否隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    // 设置搜索条位置
    _searchController.searchBar.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 44);
    // 添加到tabelView
    _tableView.tableHeaderView = _searchController.searchBar;
    
    _resultArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - 创建导航栏
- (void)creatNavigationBar {
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, 30, 30);
    // 添加设置按钮的点击事件
    [settingsButton addTarget:self action:@selector(setingClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setImage:[[UIImage imageNamed:@"dx_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    //self.navigationItem.rightBarButtonItem = settingItem;
    
    
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [locationButton setImage:[UIImage imageNamed:@"dx_location"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithCustomView:locationButton];
    self.navigationItem.leftBarButtonItem = locationItem;
    
}

#pragma mark - 定位点击事件
- (void)locationClick:(UIButton *)btn {
    WJLocationViewController *location = [[WJLocationViewController alloc] init];
    location.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:location animated:YES];
}


#pragma mark - 搜索条的代理方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 获取搜索条中里面的文字
    NSString *searchString = searchController.searchBar.text;
    // 清空之前的搜索的结果
    [_resultArray removeAllObjects];
    // 从
    NSMutableArray *contentArray = [[WJFMDBManager defaultManager] selectDataWithTextContent];
    for (NSString *str in contentArray) {
        NSRange range = [str rangeOfString:searchString];
        NSLog(@"rangeLength:%ld",range.length);
        NSLog(@"rangeLocation:%ld",range.location);
        
        if (range.length > 0) {
            [_resultArray addObject:str];
        }
    }
    NSLog(@"r:%@",_resultArray);
    // 刷新数据
    [_tableView reloadData];
}

#pragma mark - 设置按钮的点击事件
- (void)setingClick:(UIButton *)setBtn {
    
    NSLog(@"123");
    
    SettingsViewController *setting = [[SettingsViewController alloc] init];
    
    setting.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:setting animated:YES];
    
}



#pragma mark - tableView datasource
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_searchController.active) {
        return self.resultArray.count;
    }
    
    return self.dataArray.count;
}

// tableviewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_searchController.active) {
        static NSString *iden = @"cell";
        
        // 复用池去查找
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        // 没有找到
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        }
        cell.textLabel.text = _resultArray[indexPath.row];
        return cell;
    }
    else {
      
            WJNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news" forIndexPath:indexPath];
            cell.tag = indexPath.row + 1;
            cell.model = _dataArray[indexPath.row];
            
            
            NSLog(@"~~~~~~~~~~~~%@, ````````````%@",_dataArray[indexPath.row], cell.model);
            
            return cell;
    }
        
    return nil;
}

#pragma mark -  代理delelgate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 编辑模式下的cell的高度
    if (_searchController.active) {
        return 44;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WJWebViewController *webVC = [[WJWebViewController alloc] init];

//    // 2.赋值
    WJNewsCell *cell = (WJNewsCell *)[self.view viewWithTag:(indexPath.row) + 1];
    
    NSString *url = cell.model.article_url;
    if (url == nil) {
        [KVNProgress showErrorWithStatus:@"链接已失效"];
        return;
    }
    webVC.url = [NSString stringWithString:url];
    
    
    
    webVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - 添加刷新控件
- (void)addRefresh {
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
//        [self.dataArray removeAllObjects];
        _size = 10;
        [self getDataWithSize:_size];
    
    }];
    
    //
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        _size += 10;
        [self getDataWithSize:_size];
        
    }];
}

@end
