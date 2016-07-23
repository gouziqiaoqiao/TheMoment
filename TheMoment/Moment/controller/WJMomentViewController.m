//
//  WJMomentViewController.m
//  TheMoment
//
//  Created by 王钧 on 16/6/30.
//  Copyright (c) 2016年 wangjun. All rights reserved.
//

#import "WJMomentViewController.h"
#import "WJRandomShowView.h"
#import "WJMineViewController.h"
#import "WJFocusController.h"
#import "AppDelegate.h"
#import "WJTextAdd.h"
#import "WJDataCell.h"


@interface WJMomentViewController ()<UITableViewDelegate, UITableViewDataSource,TextAddDelegate,UIGestureRecognizerDelegate> {
    
    WJRandomShowView *view;
    
    // 手势 轻点让键盘消失
    UITapGestureRecognizer *tap;
    
    // 写入的数据的id
    NSInteger noteId;
    
    // 创建一个临时变量
    NSString *tempDataPass;
}

@property (nonatomic, strong) UIScrollView *scrollView;

// tableView
@property (nonatomic, strong) UITableView *tableView;

// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;

// 随机展示数据源
@property (nonatomic, strong) NSMutableArray *textDataArray;

// 数据库
@property (nonatomic, strong) FMDatabase *dataBase;

@property (nonatomic, strong) WJTextAdd *textAddView;

@property (nonatomic, strong) WJRandomShowView *randomView;

// 随机展示的字符串
@property (nonatomic, copy) NSString *randomStr;

@property (nonatomic, strong) NSMutableArray *randomStrArray;

@end

@implementation WJMomentViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.bounds = [UIScreen mainScreen].bounds;

    // 拿到数据
    [self getData];
    [self getDataWithRandomShow];
    
    
    // 创建界面
    if (!self.dataArray.count) {
        [self creatUI];
    }
    else {
        [self creatDataInsertUI];
    }
    
    [self addGesture];
    
//    // 手势的添加
//    if (!self.textAddView.textField.isEditing) {
//        [self.scrollView removeGestureRecognizer:tap];
//    }
//    if (self.tableView.hidden == YES) {
//        [self.scrollView addGestureRecognizer:tap];
//    }
    
    // 建表
    [[WJFMDBManager defaultManager] creatTable];
    
    [_tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)textDataArray {
    
    if (!_textDataArray) {
        _textDataArray = [NSMutableArray new];
    }
    return _textDataArray;
}

- (NSMutableArray *)randomStrArray {
    
    if (!_randomStrArray) {
        _randomStrArray = [NSMutableArray new];
    }
    return _randomStrArray;
}

- (WJTextAdd *)textAddView {
    if (!_textAddView) {
        _textAddView = [[WJTextAdd alloc] initWithFrame:CGRectMake(10, -44, self.view.frame.size.width - 20, 44)];
        _textAddView.delegate = self;
        
    }
    return _textAddView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height+1);
    }
    return _scrollView;
}


#pragma mark - 拿到数据源
// 拿到数据库的数据
- (void)getData {
    if (!_dataArray.count) {

        NSMutableArray *pathList = [NSMutableArray new];
        // 专门用于存储模型的数组
        NSMutableArray *mdataArray = [NSMutableArray new];
        pathList = [[WJFMDBManager defaultManager] selectAllData];
        
        for (NSDictionary *dict in pathList) {
            WJDataModel *dataModel = [[WJDataModel alloc] initWithDict:dict];
            [mdataArray addObject:dataModel];
        }
        
        // 把plist的数据源加载到数据源数组中
        [self.dataArray addObjectsFromArray:mdataArray];
    }
}


// 拿到随机展示的数据源
- (void)getDataWithRandomShow {
    // 只有当数据库的数据不存在的时候,这里的数据才展示到界面上
    if (!_dataArray.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"RandomShow.plist" ofType:nil];
        NSArray *pathList = [NSArray arrayWithContentsOfFile:path];
        
        for (NSDictionary * dic in pathList) {
            WJRandomShowModel *model = [[WJRandomShowModel alloc] init];
            model.Action = dic[@"Action"];
            model.desc = dic[@"description"];
            model.name = dic[@"name"];
            model.writer = dic[@"writer"];

            // 将模型添加到数据源数组中
            [self.textDataArray addObject:model];
        }
    }
}


#pragma mark - 创建界面
// 创建界面的时候首先查询数据库的数据是否存在,如果存在就直接展示tableView,如果不存在就展示随机数据
- (void)creatUI {
    
    if (!self.dataArray.count) {
        
        view = [[WJRandomShowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSArray *array = view.subviews;
        NSLog(@"%@",array);
        
        addBtn = view.subviews.lastObject;
        [addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
       
        view.model = _textDataArray[arc4random() % _textDataArray.count];
        [self.view addSubview:view];
        
    }
}

// 写入数据的界面
- (void)creatDataInsertUI {
    if (self.dataArray) {
        
        // 关闭自动布局
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        // 创建tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        
        //_tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dx_background"]];
        
        // 设置代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 分割线的样式
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 添加到视图上
        [self.scrollView addSubview:self.textAddView];
        
        [self.scrollView addSubview:_tableView];
        
        [self.view addSubview:self.scrollView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"WJDataCell" bundle:nil] forCellReuseIdentifier:@"dataCell"];
    }
}


#pragma mark - 点击加入随机数据
- (void)addClick:(UIButton *)btn {
    NSLog(@"123");
    //[_dataArray addObjectsFromArray:_textDataArray];
    
    
    NSInteger i = 1;
    NSString *ID = [NSString stringWithFormat:@"%ld",i];
    // 获得当前时间
    WJTime *time = [[WJTime alloc] init];
    NSString *stamp = [time getTimeStampWithTime:[NSDate date]];
    NSString *timeNow = [time getTimeWithTimeStamp:stamp];
    
    // 设置随机展示页面的加入项到数据源数组和数据库中
    NSString *textRandom = [NSString stringWithFormat:@"%@ %@",view.model.Action[@"zh-Hans"], view.model.name[@"zh-Hans"]];
    
    NSDictionary *dict = @{@"textContent":textRandom ,@"dataId":ID, @"noteTime":timeNow};
    
    WJDataModel *dataModel = [[WJDataModel alloc] initWithDict:dict];
    
    [self.dataArray addObject:dataModel];
    
    
    [[WJFMDBManager defaultManager] insertDataWithText:textRandom];
    [self.tableView reloadData];
    
    // 展示插入数据的界面
    [self creatDataInsertUI];
    
}


#pragma mark - 添加手势
- (void)addGesture {
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    tap.delegate = self;
    
    [self.scrollView addGestureRecognizer:tap];
}

// 添加tap手势实现键盘的收回和textField的收起以及tableview的显示
- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.tableView.hidden = NO;
    self.textAddView.textField.text = nil;
    [self.textAddView.textField resignFirstResponder];
    
}

#pragma mark - 手势的代理的方法
// 手势拦截
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 输出点击的view的类名
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - data source协议
// tableView下拉添加数据的时候的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -44) {
        // textFiled已经在编辑的状态的时候就不需要再执行该方法了
        if (self.textAddView.textField.isEditing) {
            return;
        }
        
        // 隐藏tableview
        _tableView.hidden = YES;
        view.hidden = YES;
        scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        scrollView.contentOffset = CGPointZero;
        [self.textAddView beginEditing];
    } else {
        // 结束编辑的时候显示tableview
        _tableView.hidden = NO;
        [self.textAddView endEditing];
    }
}

#pragma mark - 代理 WJMomentViewControllerDelegate


#pragma mark - 点击键盘返回按钮的事件
// 实现对写入数据的插入
- (BOOL)WJTextAddShouldReturn:(WJTextAdd *)textAdd {

    [[WJFMDBManager defaultManager] insertDataWithText:textAdd.textField.text];
    NSLog(@"<<>>>>>>><<<<<<<<>>>>>%@",textAdd.textField.text);
    tempDataPass = [NSString stringWithString:textAdd.textField.text];
    
    NSLog(@"<<>>>>>>><<<<<<<<>>>>>%@",tempDataPass);
    
    if (!self.dataArray) {
        noteId = 1;
    }else {
//        noteId = [self.dataArray.firstObject[@"dataId"] integerValue] + 1;
        noteId = [[WJFMDBManager defaultManager] selectDataWithId].integerValue;
    }
    
    // 获得当前时间
    WJTime *time = [[WJTime alloc] init];
    NSString *stamp = [time getTimeStampWithTime:[NSDate date]];
    NSString *timeNow = [time getTimeWithTimeStamp:stamp];
    
    NSString *ID = [NSString stringWithFormat:@"%ld",noteId];
    NSDictionary *dict = @{@"textContent":textAdd.textField.text,@"dataId":ID, @"noteTime":timeNow};
    
    // 传值
    WJDataModel * dataModel = [[WJDataModel alloc] initWithDict:dict];
    
    [self.dataArray insertObject:dataModel atIndex:0];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    
    // 输入完成后需要使输入框的内容清空
    _textAddView.textField.text = nil;
    
    return YES;
}


// 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

// tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WJDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    // 获取数据
    [self getData];

    cell.model = self.dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 返回
    return cell;
}


#pragma mark - 设置delegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;

}

// cell的点击事件进行分享
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"1243");
    
    WJDataModel *model = [[WJDataModel alloc] init];
    model = self.dataArray[indexPath.row];
    NSString *cellText = model.textContent;

    WJFocusController *focus = [[WJFocusController alloc] init];
    focus.text = cellText;
    
    NSLog(@"ccccccccc%@",focus.text);
    
    // 点击cell可以进行分享
//    [UMSocialData defaultData].extConfig.title = @"分享的title";
//    [UMSocialData defaultData].extConfig.qqData.title = @"记录当下你所想--分享";
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
//    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMengKey
//                                      shareText:cellText
//                                     shareImage:[UIImage imageNamed:@"icon"]
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
//                                       delegate:nil];
    
    focus.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:focus animated:YES];
    
    
}

#pragma mark - 删除备忘录
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){ //删除模式

        // 取出数据源数组中的dataId
        WJDataModel *model = [[WJDataModel alloc] init];
        model = self.dataArray[indexPath.row];
        NSLog(@"%@",model.dataId);
        NSInteger ID = [model.dataId integerValue];
        
        [[WJFMDBManager defaultManager] deleteDataWithId:ID];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
        
        
    }
}


#pragma mark - 自定义左滑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}


@end