//
//  FMDBManager.m
//  QingDianDemo
//
//  Created by 杨兆欣 on 2016/11/15.
//  Copyright © 2016年 轻点儿. All rights reserved.
//

#import "FMDBManager.h"
#import "QDRBookViewModel.h"
#import "FMDatabaseAdditions.h"

static FMDBManager *manager = nil;

@interface FMDBManager ()<NSCopying, NSMutableCopying>{
    FMDatabase *_db;
}

@end

@implementation FMDBManager

+ (instancetype)sharedFMDBManager{
    if (!manager) {
        manager = [[FMDBManager alloc] init];
        [manager initDataBase];
    }
    return manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (manager == nil) {
        manager = [super allocWithZone:zone];
    }
    return manager;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

-(void)initDataBase{
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    // 初始化数据表
    NSString *bookViewSql = @"CREATE TABLE 'QDRBookViewModel' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'QDRBookViewModel_id' VARCHAR(255),'QDRBookViewModel_userUUID' VARCHAR(255),'QDRBookViewModel_url' VARCHAR(255),'QDRBookViewModel_imageData'VARCHAR(255),'QDRBookViewModel_titleData'VARCHAR(255),'QDRBookViewModel_titlestr'VARCHAR(255),'QDRBookViewModel_superCode'VARCHAR(255)); ";
    // ,'QDRBookViewModel_superCode'VARCHAR(255))
    if ([_db open]) {
//        NSString *bookViewSql = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREM ENT NOT NULL, age integer NOT NULL);"
        ;
        BOOL result = [_db executeUpdate:bookViewSql];
        if (result) {
            NSLog(@"创建表成功");
        }
    }
    [_db close];
}

- (BOOL)addBookView:(QDRBookViewModel *)model{
    [_db open];
//    if (![_db columnExists:@"QDRBookViewModel_superCode" inTableWithName:@"QDRBookViewModel"]){
//        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"QDRBookViewModel",@"QDRBookViewModel_superCode"];
//        BOOL worked = [_db executeUpdate:alertStr];
//        if(worked){
//            NSLog(@"QDRBookViewModel_superCode 插入成功");
//        }else{
//            NSLog(@"QDRBookViewModel_superCode 插入失败");
//        }
//    }
    NSNumber *maxID = @(0);
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM QDRBookViewModel"];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"QDRBookViewModel_id"] integerValue]) {
            maxID = @([[res stringForColumn:@"QDRBookViewModel_id"] integerValue] ) ;
        }
    }
    maxID = @([maxID integerValue] + 1);
    BOOL judge = [_db executeUpdate:@"INSERT INTO QDRBookViewModel(QDRBookViewModel_id,QDRBookViewModel_userUUID,QDRBookViewModel_url,QDRBookViewModel_imageData,QDRBookViewModel_titleData,QDRBookViewModel_titlestr,QDRBookViewModel_superCode)VALUES(?,?,?,?,?,?,?)",maxID, model.userUUID, model.url, model.imageData, model.titleData, model.titlestr, model.superCode];
    NSLog(@"向数据库中添加元素 %d", judge);
    [_db close];
    return judge;
}

- (BOOL)deleteBookView:(QDRBookViewModel *)model{
    [_db open];
    BOOL judge = [_db executeUpdate:@"DELETE FROM QDRBookViewModel WHERE QDRBookViewModel_id = ?", model.ID];
    NSLog(@"从数据库中删除元素  %d", judge);
    [_db close];
    return judge;
}

- (BOOL)updateBookView:(QDRBookViewModel *)model{
    [_db open];
    BOOL judge = NO;
    judge = [_db executeUpdate:@"UPDATE 'QDRBookViewModel' SET QDRBookViewModel_userUUID = ?  WHERE QDRBookViewModel_id = ? ",model.userUUID,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'QDRBookViewModel' SET QDRBookViewModel_url = ?  WHERE QDRBookViewModel_id = ? ",model.url,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'QDRBookViewModel' SET QDRBookViewModel_imageData = ?  WHERE QDRBookViewModel_id = ? ",model.imageData,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'QDRBookViewModel' SET QDRBookViewModel_titleData = ?  WHERE QDRBookViewModel_id = ? ",model.titleData,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'QDRBookViewModel' SET QDRBookViewModel_titlestr = ?  WHERE QDRBookViewModel_id = ? ",model.titlestr,model.ID];
    judge = [_db executeUpdate:@"UPDATE 'QDRBookViewModel' SET QDRBookViewModel_superCode = ?  WHERE QDRBookViewModel_id = ? ",model.superCode,model.ID];
    [_db close];
    return judge;
}

- (NSMutableArray *)getAllBookView{
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM QDRBookViewModel"];
    while ([res next]) {
        QDRBookViewModel *model = [[QDRBookViewModel alloc] init];
        model.ID = @([[res stringForColumn:@"QDRBookViewModel_id"] integerValue]);
        model.userUUID = [res stringForColumn:@"QDRBookViewModel_userUUID"];
        model.url = [res stringForColumn:@"QDRBookViewModel_url"];
        model.imageData = [res stringForColumn:@"QDRBookViewModel_imageData"];
        model.titleData = [res stringForColumn:@"QDRBookViewModel_titleData"];
        model.titlestr = [res stringForColumn:@"QDRBookViewModel_titlestr"];
        model.superCode = [res stringForColumn:@"QDRBookViewModel_superCode"];
        [dataArray addObject:model];
    }
    
    [_db close];
    return dataArray;
}

@end
