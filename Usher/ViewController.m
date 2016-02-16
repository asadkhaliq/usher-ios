//
//  ViewController.m
//  Usher
//
//  Created by Asad Khaliq on 11/17/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+MyManager.h"
#import "AddViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UILabel *listCompleted;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

@implementation ViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *current_activity = [[MyManager sharedManager] get_current_activity];
    if ([current_activity length] == 0) {
        _activityLabel.text = @"START YOUR DAY";
        _subLabel.text = @"NO CURRENT ACTIVITY";
    } else {
        NSString *activity = @"CURRENT ACTIVITY: ";
        _subLabel.text = [activity stringByAppendingString:[current_activity uppercaseString]];
        _activityLabel.text = @"FIND SOMETHING TO DO NEXT";
        NSString *imageName = [[MyManager sharedManager] get_current_activity_img];
        UIImage *buttonImage = [UIImage imageNamed:imageName];
        [_activityButton setBackgroundImage:buttonImage forState:UIControlStateNormal];

    }
    
    
    NSMutableSet *completed_list = [[MyManager sharedManager] get_completed_activities];
    NSMutableArray *my_list = [[MyManager sharedManager] get_list];
    
    _listCompleted.text = [NSString stringWithFormat:@"%lu/%lu DONE", [completed_list count], [my_list count]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)activityClicked:(id)sender {
        NSString *current_activity = [[MyManager sharedManager] get_current_activity];
        if ([current_activity length] == 0)
        {
            [self performSegueWithIdentifier: @"startDaySegue" sender: sender];
        }
        else
        {
            [self performSegueWithIdentifier: @"nextActivitySegue" sender: sender];
        }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"homeToSearch"]) {
        [[MyManager sharedManager] set_origin:@"HOME"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)bgClicked:(id)sender {
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Under Construction" message:@"Sorry! That feature hasn't been implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];
}

- (IBAction)weatherClicked:(id)sender {
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Under Construction" message:@"Sorry! That feature hasn't been implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];
}


@end
