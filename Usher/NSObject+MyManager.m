//
//  NSObject+MyList.m
//  Usher
//
//  Created by Edwin Park on 12/7/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "NSObject+MyManager.h"

@implementation MyManager : NSObject

@synthesize my_list;

+ (id) sharedManager {
    static MyManager *sharedMyList = nil;
    @synchronized(self) {
        if (sharedMyList == nil) {
            sharedMyList = [[self alloc] init];
            sharedMyList->my_list = [[NSMutableArray alloc] init];
            sharedMyList->must_do = [[NSMutableArray alloc] init];
            sharedMyList->completed_activities = [[NSMutableSet alloc] init];
            sharedMyList->num_completed = 0;
            sharedMyList->database = [[DBManager alloc] initWithDatabaseFilename:@"Database.db"];
            sharedMyList->tutorial = YES;
            [sharedMyList->my_list addObject:@"Pantheon"];
            [sharedMyList->my_list addObject:@"Arc de Triomphe"];
            [sharedMyList->my_list addObject:@"Jardin des Tuileries"];
            [sharedMyList->my_list addObject:@"Bristol Paris"];
            sharedMyList->current_activity = @"";
        }
    }
    return sharedMyList;
}

- (NSMutableArray *)get_list {
    return my_list;
}

- (DBManager *)get_db {
    return database;
}

- (NSString *)get_current_activity {
    return current_activity;
}

- (void)change_activity: (NSString *)new_activity {
    current_activity = new_activity;
}

- (NSString *)get_current_activity_img {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Item WHERE Name = \"%@\"", current_activity];
    NSArray *results = [[NSArray alloc] initWithArray:[database loadDataFromDB:query]];
    if ([results count] == 0)
        return @"";
    
    NSString *eventid = [[results objectAtIndex:0] objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@.jpg", eventid];
}

- (NSMutableArray *)get_must_do {
    return must_do;
}

- (BOOL)is_tutorial {
    return tutorial;
}

- (NSInteger) get_num_completed {
    return num_completed;
}

- (void)num_completed_increment_by: (NSInteger) num {
    num_completed += num;
}

- (NSString *)get_origin {
    return search_origin;
}

- (void)set_origin: (NSString *)new_origin {
    search_origin = new_origin;
}

- (void)tutorial_flag: (BOOL) flag {
    tutorial = flag;
}

- (NSMutableSet *) get_completed_activities {
    return completed_activities;
}


@end
