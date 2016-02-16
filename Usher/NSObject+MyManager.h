//
//  NSObject+MyList.h
//  Usher
//
//  Created by Edwin Park on 12/7/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DBManager.h"

@interface MyManager : NSObject {
    NSMutableArray *my_list;
    DBManager *database;
    NSString *current_activity;
    NSMutableArray *must_do;
    BOOL tutorial;
    NSInteger num_completed;
    NSString *search_origin;
    NSMutableSet *completed_activities;
}

@property (nonatomic, retain) NSMutableArray *my_list;

+ (id)sharedManager;
- (NSMutableArray *)get_list;
- (DBManager *)get_db;
- (NSString *)get_current_activity;
- (void)change_activity: (NSString *)new_activity;
- (NSMutableArray *)get_must_do;
- (BOOL)is_tutorial;
- (NSInteger) get_num_completed;
- (void)num_completed_increment_by: (NSInteger) num;
- (NSString *)get_origin;
- (void)set_origin: (NSString *)new_origin;
- (NSString *)get_current_activity_img;
- (void)tutorial_flag: (BOOL) flag;
- (NSMutableSet *) get_completed_activities;

@end
