//
//  NSObject+DBManager.h
//  SQLite3DBSample
//
//  Created by Edwin Park on 11/18/14.
//  Copyright (c) 2014 Edwin Park. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

    @property (nonatomic, strong) NSMutableArray *arrColumnNames;

    @property (nonatomic) int affectedRows;

    @property (nonatomic) long long lastInsertedRowID;

    -(NSArray *)loadDataFromDB:(NSString *)query;

    -(void)executeQuery:(NSString *)query;
@end
