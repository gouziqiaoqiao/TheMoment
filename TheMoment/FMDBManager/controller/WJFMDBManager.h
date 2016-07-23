//
//  WJFMDBManager.h
//  TheMoment
//
//  Created by 王钧 on 16/7/4.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJFMDBManager : NSObject

+ (WJFMDBManager *)defaultManager;

//- (void)openDataBase;

- (void)creatTable;

- (void)insertDataWithText:(NSString *)text;

//- (void)insertData;
- (NSMutableArray *)selectAllData;
- (NSString *)selectDataWithId;
- (NSMutableArray *)selectDataWithTextContent;

//- (void)updateData;

- (void)deleteDataWithId:(NSInteger)Id;
@end
