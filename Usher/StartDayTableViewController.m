//
//  MyListViewController.m
//  Usher
//
//  Created by Ji Young Park on 11/19/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "StartDayTableViewController.h"
#import "MyListViewController.h"
#import "NSObject+DBManager.h"
#import "CustomTableCell.h"
#import "AppDelegate.h"
#import "SingleEventViewController.h"
#import "NSObject+MyManager.h"



@interface StartDayTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *startDayTable;
@property (nonatomic, strong) NSArray *arrayItems;
@end

@implementation StartDayTableViewController
{
        DBManager *database;
        NSMutableArray *my_list;
        NSMutableArray *must_do;
    
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
        must_do = [[MyManager sharedManager] get_must_do];
        
        if ([must_do count] > 0) {
            [must_do removeAllObjects];
        }
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//                                                   initWithTarget:self action:@selector(longPressGestureRecognized:)];
//        [self.tableView addGestureRecognizer:longPress];
        
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
        
        
        
        static NSString *CellIdentifier = @"ListCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            cell.textLabel.text = [search_result objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = [my_list objectAtIndex:indexPath.row];

        }
        
        return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];*/
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
     if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
         cell.accessoryType = UITableViewCellAccessoryNone;
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         [must_do removeObject:[my_list objectAtIndex:indexPath.row]];
     }
     else {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         [must_do addObject:[my_list objectAtIndex:indexPath.row]];
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
    
    -(void)loadData{
        
        NSString *query = @"select * from Item";
        
        // Get the results.
        if (self.arrayItems != nil) {
            self.arrayItems = nil;
        }
        self.arrayItems = [[NSArray alloc] initWithArray:[database loadDataFromDB:query]];
        
        NSLog(@"Result is : %@", self.arrayItems);
        
        // Reload the table view.
        [self.tableView reloadData];
    }


@end