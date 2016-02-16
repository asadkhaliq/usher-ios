//
//  AppDelegate.h
//  Usher
//
//  Created by Asad Khaliq on 11/17/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyListViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    @public MyListViewController *myControllerRef;

}

@property (nonatomic, strong) MyListViewController *myControllerRef;
@property (strong, nonatomic) UIWindow *window;

@end

