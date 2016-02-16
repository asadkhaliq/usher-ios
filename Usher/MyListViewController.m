//
//  MyListViewController.m
//  Usher
//
//  Created by Ji Young Park on 11/19/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "MyListViewController.h"
#import "NSObject+DBManager.h"
#import "CustomTableCell.h"
#import "AppDelegate.h"
#import "SingleEventViewController.h"
#import "NSObject+MyManager.h"
#import "AddViewController.h"

@interface MyListViewController() {
    //@public NSString *add_event;
}
    @property (nonatomic, strong) NSArray *arrayItems;
    @property (nonatomic, strong) NSArray *arrayPhotos;

@end

@implementation MyListViewController
{
    DBManager *database;
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
    NSMutableArray *my_list;
    NSArray *search_result;
    NSInteger segueInt;
    NSIndexPath *index_path;

}

- (void)addEvent: (NSString*)name {
    //self->add_event = name;
    my_list = [[MyManager sharedManager] get_list];
    [my_list addObject: name];
}

- (void) viewDidAppear:(BOOL)animated {
//    NSLog(@"load data called");
}


- (void) viewDidLoad
{
    [super viewDidLoad];


    
    database = [[MyManager sharedManager] get_db];
    my_list = [[MyManager sharedManager] get_list];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [search_result count];
        
    } else {
        return [my_list count];
    }
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Item WHERE Name = \"%@\"", [my_list objectAtIndex:indexPath.row]];
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
    
    
    CustomTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    
    // Configure the cell...
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomTableCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.nameLabel.text = [search_result objectAtIndex:indexPath.row];
        NSString *distancePlus = distance;
        distancePlus = [distancePlus stringByAppendingString:@" km away"];
        cell.distanceLabel.text = distancePlus;
        
        NSString *starsPlus = rating;
        starsPlus = [starsPlus stringByAppendingString:@" stars"];
        cell.starsLabel.text = starsPlus;
        
        if ([[[MyManager sharedManager] get_completed_activities] containsObject:cell.nameLabel.text]) {
            cell.buttonImage.alpha = 1.0;
        } else {
            cell.buttonImage.alpha = 0.2;
        }
    } else {
        cell.nameLabel.text = [my_list objectAtIndex:indexPath.row];
        NSString *distancePlus = distance;
        distancePlus = [distancePlus stringByAppendingString:@" km away"];
        cell.distanceLabel.text = distancePlus;
        NSString *starsPlus = rating;
        starsPlus = [starsPlus stringByAppendingString:@" stars"];
        cell.starsLabel.text = starsPlus;
        
        if ([[[MyManager sharedManager] get_completed_activities] containsObject:cell.nameLabel.text]) {
            cell.buttonImage.alpha = 1.0;
        } else {
            cell.buttonImage.alpha = 0.2;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableSet *set = [[MyManager sharedManager] get_completed_activities];
        [set removeObject:[my_list objectAtIndex:indexPath.row]];
        [my_list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    search_result = [my_list filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [my_list exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index_path = indexPath;
    [self performSegueWithIdentifier:@"singleEventView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"listToSearch"]) {
        [[MyManager sharedManager] set_origin:@"LIST"];
    } else if([segue.identifier isEqualToString:@"singleEventView"]) {
        SingleEventViewController *destViewController = (SingleEventViewController *)segue.destinationViewController;
        NSString *selected_name;
        if (self.tableView == self.searchDisplayController.searchResultsTableView) { // Currently searching
            selected_name = [search_result objectAtIndex:index_path.row];
        } else { // Currently not searching
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            selected_name = [my_list objectAtIndex:indexPath.row];
        }
        [destViewController setName: selected_name];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

// Add this at the end of your .m file. It returns a customized snapshot of a given view.
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end