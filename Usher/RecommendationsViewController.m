//
//  RecommendationsViewController.m
//  Usher
//
//  Created by Asad Khaliq on 12/3/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "RecommendationsViewController.h"
#import "NSObject+MyManager.h"

@interface RecommendationsViewController () {
@public NSMutableArray *display_list;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *setActivity;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainDescription;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *priceIcon;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timingIcon;
@property (weak, nonatomic) IBOutlet UILabel *timingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectorImage;

@end

@implementation RecommendationsViewController {
    DBManager *database;
    NSMutableArray *my_list;
    NSMutableArray *must_do;
    
    NSInteger list_index;
    NSInteger nearby_count;
    
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
    
    NSInteger page;
}

- (void)viewDidLoad {
    {
        if ([[MyManager sharedManager] is_tutorial] == TRUE) {
            UIAlertView *messageAlert = [[UIAlertView alloc]
                                         initWithTitle:@"A quick word..." message:@"Welcome to recommendations! Swipe up or down to scroll through different attractions, or swipe left/right to view more details about items." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            // Display Alert Message
            [messageAlert show];
            [[MyManager sharedManager] tutorial_flag: FALSE];
        }
        

        [super viewDidLoad];
        
        
        
        database = [[MyManager sharedManager] get_db];
        my_list = [[MyManager sharedManager] get_list];
        must_do = [[MyManager sharedManager] get_must_do];
        
        page = 1;
        
        [_imageView setUserInteractionEnabled:YES];
        
        if (list_index < [my_list count]) {
            NSInteger index = list_index;
            NSString *selected_name = [my_list objectAtIndex:index];
           
            if ([must_do containsObject:selected_name])
                _typeLabel.text = @"must-do";
            else
                _typeLabel.text = @"my list";
            
            
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
            
            NSString *ratingWithStars = rating;
            ratingWithStars = [ratingWithStars stringByAppendingString:@" stars"];
            _ratingLabel.text = ratingWithStars;
            
            NSString *img_file = [NSString stringWithFormat:@"%@.jpg", eventid];
            UIImage *image = [UIImage imageNamed: img_file];
            [_imageView setImage:image];
            
        } else {
            _typeLabel.text = @"nearby";
            
            /* Results Query */
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM Item WHERE Distance < 1.4 ORDER BY Distance, Name"];
            NSArray *results = [[NSArray alloc] initWithArray:[database loadDataFromDB:query]];
            
            NSInteger index = list_index - [my_list count];
            
            eventid = [[results objectAtIndex:index] objectAtIndex:0];
            name = [[results objectAtIndex:index] objectAtIndex:1];
            rating = [[results objectAtIndex:index] objectAtIndex:2];
            address = [[results objectAtIndex:index] objectAtIndex:3];
            description = [[results objectAtIndex:index] objectAtIndex:4];
            distance = [[results objectAtIndex:index] objectAtIndex:5];
            tag = [[results objectAtIndex:index] objectAtIndex:6];
            phone = [[results objectAtIndex:index] objectAtIndex:7];
            hours = [[results objectAtIndex:index] objectAtIndex:8];
            price = [[results objectAtIndex:index] objectAtIndex:9];
            
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

}




-(void)handleSwipeFrom:(UISwipeGestureRecognizer *) sender
{
    //Gesture detect - swipe up/down , can be recognized direction
    if(sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        if (list_index < [my_list count] + 8 - 1) {
            list_index++;
        }
        
        _mainDescription.text = [NSString stringWithFormat: @"%ld", (long)list_index];
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
        [self viewDidLoad];
    }
    if(sender.direction == UISwipeGestureRecognizerDirectionDown)
    {
        
        if (list_index > 0) {
            list_index--;
        }
        _mainDescription.text = [NSString stringWithFormat: @"%ld", (long)list_index];
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
        [self viewDidLoad];

    }
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
    }
}

-(void)swipeBottomBar:(UISwipeGestureRecognizer *)swipeRecognizer
{
    
    if (swipeRecognizer.direction & UISwipeGestureRecognizerDirectionLeft) {
        _mainDescription.text = @"left";
    }
    if (swipeRecognizer.direction & UISwipeGestureRecognizerDirectionRight) {
        _mainDescription.text = @"right";
    }
    
}


- (void)setList: (NSMutableArray*) list {
    self->display_list = list;
}

- (void)setIndex: (NSInteger) index {
    self->list_index = index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"setActivity"]){
        [[MyManager sharedManager] change_activity: name];
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
