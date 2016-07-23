//
//  WJFMDBManager.m
//  TheMoment
//
//  Created by 王钧 on 16/7/4.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "WJFMDBManager.h"
#import "WJTime.h"

@interface WJFMDBManager () {
    
    FMDatabase *_dataBase;
    NSInteger _dataId;
    NSInteger _tempId;
}


@end

@implementation WJFMDBManager

+ (WJFMDBManager *)defaultManager {
    
    static WJFMDBManager *manager =nil;
    if (!manager) {
        manager = [[WJFMDBManager alloc] init];
    }
    return manager;
}

#pragma mark - 重写init方法
- (instancetype)init {
    
    if (self = [super init]) {
        // 1.打开数据库
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WJDataBase.db"];
        NSLog(@"path:%@", path);
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        BOOL ret = [_dataBase open];
        
        if (ret) {
            NSLog(@"数据库打开成功");
            [self creatTable];
        }
        else {
            NSLog(@"数据库打开失败");
        }
    }
    return self;
}

//- (void)openDataBase {
//
//    // 1.打开数据库
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WJDataBase.db"];
//    NSLog(@"path:%@", path);
//    _dataBase = [[FMDatabase alloc] initWithPath:path];
//    BOOL ret = [_dataBase open];
//    
//    if (ret) {
//        NSLog(@"数据库打开成功");
//        [self creatTable];
//        _dataId = 1;
//    }
//    else {
//        NSLog(@"数据库打开失败");
//    }
//}

#pragma mark - 创建表
- (void)creatTable {
    [_dataBase open];
    // 1.创建sql语句
//    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_TheMoment (id integer PRIMARY KEY AUTOINCREMENT, textContent text, isCircle text DEFAULT NO);";
    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_TheMoment (id integer PRIMARY KEY AUTOINCREMENT, textContent text, dataId text, noteTime text);";
//    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_TheMoment (id integer PRIMARY KEY AUTOINCREMENT, name text UNIQUE, age integer DEFAULT 18, sex text DEFAULT 'not clear');";
    // 2.
    if ([_dataBase executeUpdate:sql]) {
        NSLog(@"表创建成功");
        
    }
    else {
        NSLog(@"表创建失败");
    }
    [_dataBase close];
}

#pragma mark - 插入数据
- (void)insertDataWithText:(NSString *)text {
//- (void)insertData {
    if (!_dataBase) {
        _dataId = 1;
        
    } else {
        NSString *idStr = [[WJFMDBManager defaultManager] selectDataWithId];
        _dataId = idStr.integerValue + 1;
    }
    [_dataBase open];
    NSString *Id = [NSString stringWithFormat:@"%ld", _dataId];
    
    // 获得当前时间
    WJTime *time = [[WJTime alloc] init];
    NSString *stamp = [time getTimeStampWithTime:[NSDate date]];
    NSString *timeNow = [time getTimeWithTimeStamp:stamp];
    
    // 1.sql语句
    NSString *sql = @"INSERT INTO t_TheMoment(textContent, dataId, noteTime) VALUES (?, ?, ?);";
    //    NSString *sql = @"INSERT INTO t_TheMoment(name, age, sex) VALUES('wangjun', 20, 'male');";
    
    // 2.执行sql语句
    if ([_dataBase executeUpdate:sql, text, Id, timeNow]) {//
        NSLog(@"数据插入成功");
        
        
    }
    else {
        NSLog(@"数据插入失败");
    }
    [_dataBase close];
    
}

#pragma mark - 获取到所有的数据库数据
- (NSMutableArray *)selectAllData {
    NSMutableArray *marray = [NSMutableArray new];
    [_dataBase open];
//        NSString *sql = @"select * from t_TheMoment where  dataId > 0";
    NSString *sql = @"select * from t_TheMoment ORDER BY dataId DESC;";
    FMResultSet *set = [_dataBase executeQuery:sql];
    
    if (set) {
        while ([set next]) {
            NSString *textContent = [set objectForColumnName:@"textContent"];
            NSString *Id = [set objectForColumnName:@"dataId"];
            NSString *noteTime = [set objectForKeyedSubscript:@"noteTime"];
            NSDictionary *dict = @{@"textContent":textContent, @"dataId":Id, @"noteTime":noteTime};
            [marray addObject:dict];
        }
    }
    [_dataBase close];
    return marray;
}
// 以dataId进行查询
- (NSString *)selectDataWithId {
    NSMutableArray *dataIdArray = [NSMutableArray new];
    [_dataBase open];
    //        NSString *sql = @"select * from t_TheMoment where  dataId > 0";
    NSString *sql = @"select * from t_TheMoment where dataId > 0;";
    FMResultSet *set = [_dataBase executeQuery:sql];
    
    if (set) {
        while ([set next]) {
            NSString *Id = [set objectForColumnName:@"dataId"];
            [dataIdArray addObject:Id];
        }
    }
    [_dataBase close];
    return dataIdArray.lastObject;
}

- (NSMutableArray *)selectDataWithTextContent {
    NSMutableArray *contentArray = [NSMutableArray new];
    [_dataBase open];

    NSString *sql = @"select textContent from t_TheMoment;";
    FMResultSet *set = [_dataBase executeQuery:sql];
    
    if (set) {
        while ([set next]) {
            NSString *content = [set objectForColumnName:@"textContent"];
            [contentArray addObject:content];
        }
    }
    [_dataBase close];
    return contentArray;
}


#pragma mark - 更新数据
- (void)updateDataWithText:(NSString *)text {
    
    [_dataBase open];
    
    NSString *sql = @"UPDATE t_TheMoment SET textContent = ?;";
    
    BOOL ret = [_dataBase executeUpdate:sql, text];
    
    if (ret) {
        NSLog(@"更新成功");
    }
    else {
        NSLog(@"更新失败");
    }
    [_dataBase close];
}



#pragma mark - 删除数据
- (void)deleteDataWithId:(NSInteger)Id {
    
    [_dataBase open];
    
    NSString *sql = @"DELETE FROM t_TheMoment WHERE dataId = ?;";
    
    NSString *ID = [NSString stringWithFormat:@"%ld",Id];
    
    BOOL ret = [_dataBase executeUpdate:sql, ID];
    
    if (ret) {
        NSLog(@"删除成功");
    }
    else {
        NSLog(@"删除失败");
    }
        
    [_dataBase close];
}




/**
 *  //#pragma mark - 数据库操作
 - (void)openDataBase {
 
     // 1.打开数据库
     NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WJDataBase.db"];
     NSLog(@"path:%@", path);
     _dataBase = [[FMDatabase alloc] initWithPath:path];
     BOOL ret = [_dataBase open];
 
     if (ret) {
         NSLog(@"数据库打开成功");
         [self creatTable];
     }
     else {
         NSLog(@"数据库打开失败");
     }
 }
 
 #pragma mark - 创建表
 - (void)creatTable {
 
     // 1.创建sql语句
     NSString *sql = @"CREATE TABLE IF NOT EXISTS t_TheMoment (id integer PRIMARY KEY AUTOINCREMENT, textContent text);";
     //    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_TheMoment (id integer PRIMARY KEY AUTOINCREMENT, name text UNIQUE, age integer DEFAULT 18, sex text DEFAULT 'not clear');";
     // 2.
     BOOL ret = [_dataBase executeUpdate:sql];
 
     if (ret) {
         NSLog(@"表创建成功");
     }
     else {
         NSLog(@"表创建失败");
     }
 }
 
 #pragma mark - 插入数据
 - (void)insertDataWithText:(NSString *)text {
     //- (void)insertData {
 
     // 1.sql语句
     NSString *sql = @"INSERT INTO t_TheMoment(textContent) VALUES (?);";
     //    NSString *sql = @"INSERT INTO t_TheMoment(name, age, sex) VALUES('wangjun', 20, 'male');";
     // 2.执行sql语句
 
     BOOL ret = [_dataBase executeUpdate:sql, text];
 
     if (ret) {//
         NSLog(@"数据插入成功");
     }
     else {
         NSLog(@"数据插入失败");
     }
 }
 */

@end
