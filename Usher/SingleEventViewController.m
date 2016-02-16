//
//  SingleEventViewController.m
//  Usher
//
//  Created by Asad Khaliq on 11/20/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "SingleEventViewController.h"
#import "NSObject+DBManager.h"
#import "MyListViewController.h"
#import "AppDelegate.h"
#import "NSObject+MyManager.h"

@interface SingleEventViewController () {
    @public NSString *selected_name;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addEvent;
@property (weak, nonatomic) IBOutlet UILabel *mainDescription;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectorImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *timingIcon;
@property (weak, nonatomic) IBOutlet UIImageView *priceIcon;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation SingleEventViewController {
    DBManager *database;
    NSMutableArray *my_list;
    
    NSString *eventid;
    NSString *name;
    NSString *rating;
    NSString *address;
    NSString *description;
    NSString *distance;
    NSString *tag;
    NSString *phone;
    NSString *hours;
    NSString *price;
    NSInteger *page;
    
    NSString *buttonText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    page = 1;

    
    database = [[MyManager sharedManager] get_db];
    my_list = [[MyManager sharedManager] get_list];
    
    [_imageView setUserInteractionEnabled:YES];
    
    if (selected_name != NULL) {
        
        if ([my_list containsObject:selected_name]) {
            //buttonText = @"SET ACTIVITY";
            [_addEvent setTitle:@"SET ACTIVITY" forState:UIControlStateNormal];
        } else {
            //buttonText = @"ADD TO MY LIST";
            [_addEvent setTitle:@"ADD TO MY LIST" forState:UIControlStateNormal];

        }
        
        if ([[[MyManager sharedManager]get_must_do] containsObject:selected_name]) {
            _typeLabel.text = @"must-do";
        } else if ([[[MyManager sharedManager]get_list] containsObject:selected_name]) {
            _typeLabel.text = @"my list";
        } else {
            _typeLabel.text = @"";
        }
        
        /* There is an error when Name contains a single quote. */
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM Item WHERE Name = \"%@\"", selected_name];
        NSArray *results = [[NSArray alloc] initWithArray:[database loadDataFromDB:query]];
        
        eventid = [[results objectAtIndex:0] objectAtIndex:0];
        name = [[results objectAtIndex:0] objectAtIndex:1];
        rating = [[results objectAtIndex:0] objectAtIndex:2];
        address = [[results objectAtIndex:0] objectAtIndex:3];
        description = [[results objectAtIndex:0] objectAtIndex:4];
        distance = [[results objectAtIndex:0] objectAtIndex:5];
        tag = [[results objectAtIndex:0] objectAtIndex:6];
        phone = [[results objectAtIndex:0] objectAtIndex:7];
        hours = [[results objectAtIndex:0] objectAtIndex:8];
        price = [[results objectAtIndex:0] objectAtIndex:9];
        
        if ([phone length] == 0) phone = @"N/A";
        if ([hours length] == 0) hours = @"N/A";
        if ([price length] == 0) {
            price = @"Free";
        } else {
            NSInteger count = [price intValue];
            price = [@"" stringByPaddingToLength:count withString: @"$" startingAtIndex:0];
        }
        
        NSString *uppercase = [name uppercaseString];
        _nameLabel.text = uppercase;

        
        _distanceLabel.text = [NSString stringWithFormat:@"%@ km away", distance];
        _mainDescription.text = description;
        
//      NEED TO MODIFY ratingLabel to display the stars, depending on the rating
        NSString *ratingWithStars = rating;
        ratingWithStars = [ratingWithStars stringByAppendingString:@" stars"];
        _ratingLabel.text = ratingWithStars;
        
        NSString *img_file = [NSString stringWithFormat:@"%@.jpg", eventid];
        UIImage *image = [UIImage imageNamed: img_file];
        [_imageView setImage:image];

    }
    

    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    [super viewDidLoad];
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *) sender
{
    if (page == 1) {
               if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
                    {
                            _mainDescription.text = tag;
                UIImage *image = [UIImage imageNamed: @"page2.png"];
                [_selectorImage setImage:image];
                    _headerLabel.text = @"Here's what people say...";
                _addressLabel.text = @"";
                _phoneLabel.text = @"";
                _timingLabel.text = @"";
                _priceLabel.text = @"";
                UIImage *imageicon1 = [UIImage imageNamed: @"blank.png"];
                [_timingIcon setImage:imageicon1];
                UIImage *imageicon2 = [UIImage imageNamed: @"blank.png"];
                [_phoneIcon setImage:imageicon2];
                UIImage *imageicon3 = [UIImage imageNamed: @"blank.png"];
                [_priceIcon setImage:imageicon3];
                UIImage *imageicon4 = [UIImage imageNamed: @"blank.png"];
                [_addressIcon setImage:imageicon4];

                            page = 2;

                        }
            }
        else if (page == 2) {
                if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
                    {
                            _mainDescription.text = @"";
                UIImage *image = [UIImage imageNamed: @"page3.png"];
                [_selectorImage setImage:image];
                _headerLabel.text = @"Details";
                _addressLabel.text = address;
                _phoneLabel.text = phone;
                _timingLabel.text = hours;
                _priceLabel.text = price;
                UIImage *imageicon1 = [UIImage imageNamed: @"clock.png"];
                [_timingIcon setImage:imageicon1];
                UIImage *imageicon2 = [UIImage imageNamed: @"phone.png"];
                [_phoneIcon setImage:imageicon2];
                UIImage *imageicon3 = [UIImage imageNamed: @"pricetag.png"];
                [_priceIcon setImage:imageicon3];
                UIImage *imageicon4 = [UIImage imageNamed: @"map_marker-50.png"];
                [_addressIcon setImage:imageicon4];                            page = 3;

                            
                        }
                if(sender.direction == UISwipeGestureRecognizerDirectionRight)
                    {
                            _mainDescription.text = description;
                UIImage *image = [UIImage imageNamed: @"page1.png"];
                [_selectorImage setImage:image];
                _headerLabel.text = @"Description";
                _addressLabel.text = @"";
                _phoneLabel.text = @"";
                _timingLabel.text = @"";
                _priceLabel.text = @"";
                UIImage *imageicon1 = [UIImage imageNamed: @"blank.png"];
                [_timingIcon setImage:imageicon1];
                UIImage *imageicon2 = [UIImage imageNamed: @"blank.png"];
                [_phoneIcon setImage:imageicon2];
                UIImage *imageicon3 = [UIImage imageNamed: @"blank.png"];
                [_priceIcon setImage:imageicon3];
                UIImage *imageicon4 = [UIImage imageNamed: @"blank.png"];
                [_addressIcon setImage:imageicon4];
                            page = 1;

                            
                        }
            } else if (page == 3) {
                    
                    if(sender.direction == UISwipeGestureRecognizerDirectionRight)
                        {
                                _mainDescription.text = tag;
                                        UIImage *image = [UIImage imageNamed: @"page2.png"];
                    [_selectorImage setImage:image];
                    _headerLabel.text = @"Here's what people say...";
                    _addressLabel.text = @"";
                    _phoneLabel.text = @"";
                    _timingLabel.text = @"";
                    _priceLabel.text = @"";
                    UIImage *imageicon1 = [UIImage imageNamed: @"blank.png"];
                    [_timingIcon setImage:imageicon1];
                    UIImage *imageicon2 = [UIImage imageNamed: @"blank.png"];
                    [_phoneIcon setImage:imageicon2];
                    UIImage *imageicon3 = [UIImage imageNamed: @"blank.png"];
                    [_priceIcon setImage:imageicon3];
                    UIImage *imageicon4 = [UIImage imageNamed: @"blank.png"];
                    [_addressIcon setImage:imageicon4];                                page = 2;
                                
                            }
                }}

- (IBAction)getText:(id)sender {
//    AppDelegate *del = [[UIApplication sharedApplication] delegate];
//    
//    NSLog(@"%@\n", del->myControllerRef);
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"changeList" sender:self];
}


- (void)setName: (NSString*)name_ {
    self->selected_name = name_;
//    AppDelegate *del = [[UIApplication sharedApplication] delegate];
//    [del->myControllerRef addEvent:name_];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addEventClied:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"changeList"]){
        MyListViewController *destViewController = (MyListViewController *)segue.destinationViewController;
        if ([[_addEvent titleLabel] text] == @"SET ACTIVITY") {
            [[MyManager sharedManager] change_activity: selected_name];
        } else {
            [destViewController addEvent: selected_name];
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
