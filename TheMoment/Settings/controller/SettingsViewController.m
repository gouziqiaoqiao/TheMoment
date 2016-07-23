//
//  SettingsViewController.m
//  TheMoment
//
//  Created by zeb on 16/7/2.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    UITableViewCell *cell;
    NSInteger currentIndexRow;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor colorWithWhite:0.125 alpha:1.0];
    _tableView.backgroundColor = [UIColor colorWithWhite:0.125 alpha:1.0];
    [self setNavigationBar];
    
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    _tableView.backgroundColor = [UIColor colorWithWhite:0.125 alpha:1.0];

}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


#pragma mark - 设置导航栏
- (void)setNavigationBar {
    
    self.navigationItem.title = @"设置";
    
    // 设置右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    
    // 设置返回按钮的点击事件
    [rightBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightBtn setImage:[UIImage imageNamed:@"dx_back"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.leftBarButtonItem = backItem;
}


#pragma mark - 返回按钮的点击事件
- (void)backClick:(UIButton *)backBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 创建界面
- (void)creatUI {
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _tableView.scrollEnabled = NO;
    
    [_tableView reloadData];
}

#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        return 3;
    }
    else if (section == 2) {
        return 1;
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
   
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        cell.textLabel.text = @"开启夜间模式";
        
        UISwitch *switchBtn = [[UISwitch alloc]init];
        switchBtn.on = NO;
        cell.accessoryView = switchBtn;
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:0.125 alpha:1.0];
//    cell.textLabel.text = title[indexPath.row];
    
    if (indexPath.section == 0) {
        
        NSArray *array = @[@"正常", @"重复三次", @"重复五次"];
        cell.textLabel.text = array[indexPath.row];
    }

    if (indexPath.section == 1) {
        NSArray *array = @[@"5min", @"15min", @"30min"];
        cell.textLabel.text = array[indexPath.row];
        cell.tag = 1 + indexPath.row;
    }
    
    if (indexPath.section == 3) {
        cell.textLabel.text = @"开始计划今天的日程吧";
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.tintColor = [UIColor lightGrayColor];
    }
//
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *title = @[@"通知声音重复", @"推迟时间", @"夜间模式", @"每日计划开始时间"];
    return title[section];
}


#pragma mark - cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"123");
    
    // 在三个里面只有一个被选中
    if (indexPath.section == 1) {
        currentIndexRow = indexPath.row;
        [self.tableView reloadData];
    }
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if(currentIndexRow == indexPath.row ) {//&& !currentIndexRow
            return UITableViewCellAccessoryCheckmark;
        }
        else {
            return UITableViewCellAccessoryNone;
        }
    }
    return UITableViewCellAccessoryNone;
}


/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
 {
 current=indexPath.row;
 [self.tableView reloadData];
 }
 - (UITableViewCellAccessoryType)tableView:(UITableView*)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath
 {
 if(current==indexPath.row&&current!=nil)
 {
 return UITableViewCellAccessoryCheckmark;
 }
 else
 {
 return UITableViewCellAccessoryNone;
 }
 }

 */



@end
