//
//  AddViewController.m
//  Usher
//
//  Created by Asad Khaliq on 11/20/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "AddViewController.h"
#import "NSObject+DBManager.h"
#import "SingleEventViewController.h"
#import "NSObject+MyManager.h"

@interface AddViewController ()
@property (nonatomic, strong) NSArray *arrayItems;
@property (nonatomic, strong) NSArray *arrayPhotos;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

-(void)loadData;
@end

@implementation AddViewController

{
    DBManager *database;
    NSArray *total_list;
    NSMutableArray *list;
    NSArray *search_result;
    NSString *selected;
    NSInteger number;
    NSIndexPath *index_path;
}



- (void) viewDidLoad
{
    [super viewDidLoad];
    
    database = [[MyManager sharedManager] get_db];
    
    list = [[NSMutableArray alloc] init];
    total_list = [NSArray arrayWithObjects:nil];
    
    [self getList];
    number = 1;
    //    [self loadData];
    //
    //    NSString *place = @"The Counter";
    //    [self loadPlaceData:place];
    //    [self loadPhotoData:place];
    
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
        return [total_list count];
    }
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [search_result objectAtIndex:indexPath.row];
    } else {
//        cell.textLabel.text = [total_list objectAtIndex:indexPath.row];
//        cell.detailTextLabel.text = [[list objectAtIndex:indexPath.row] objectAtIndex:1];
    }
    
    return cell;
}



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    search_result = [list filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

/* Initially gets all the names from the database. */
- (void) getList
{
    NSString *query = @"select Name from Item order by Name";
    NSArray *results = [[NSArray alloc] initWithArray:[database loadDataFromDB:query]];
    
    for (NSArray* result in results)
    {
        [list addObject:[result objectAtIndex:0]];
    }
    
    [self.tableView reloadData];
}


-(void)loadData{
    
    NSString *query = @"select * from Item";
    
    // Get the results.
    if (self.arrayItems != nil) {
        self.arrayItems = nil;
    }
    
    NSLog(@"Result is : %@", self.arrayItems);
    
    // Reload the table view.
    [self.tableView reloadData];
}

-(void)loadPlaceData:(NSString *)place{
    
    NSString *query = [NSString stringWithFormat:@"select * from Item where Name = '%@'", place];
    
    // Get the results.
    if (self.arrayItems != nil) {
        self.arrayItems = nil;
    }
    
    NSString *name = [[self.arrayItems objectAtIndex:0] objectAtIndex:1];
    NSString *rating = [[self.arrayItems objectAtIndex:0] objectAtIndex:2];
    NSString *address = [[self.arrayItems objectAtIndex:0] objectAtIndex:3];
    
    // TO-DO: DO SOMETHING WITH DATA HERE!
    
    NSLog(@"Name : %@", name);
    NSLog(@"Rating : %@", rating);
    NSLog(@"Address : %@", address);
    
    // Reload the table view.
    [self.tableView reloadData];
}

-(void)loadPhotoData:(NSString *)place{
    
    NSString *query = [NSString stringWithFormat:@"select Url from Item, Photo where Item.ItemID = Photo.ItemID and Name = '%@'", place];
    
    // Get the results.
    if (self.arrayPhotos != nil) {
        self.arrayPhotos = nil;
    }

    NSInteger len = self.arrayPhotos.count;
    
    for (int i = 0; i < len; i++) {
        // TO-DO: DO SOMETHING WITH DATA HERE! Photo url is can be accessed at [[self.arrayPhotos objectAtIndex:i] objectAtIndex:0]
        NSLog(@"URL : %@", [[self.arrayPhotos objectAtIndex:i] objectAtIndex:0]);
    }
    
    // Reload the table view.
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index_path = indexPath;
    [self performSegueWithIdentifier:@"addEventView" sender:self];
}

- (IBAction)cancelClicked:(id)sender {
    if ( [[MyManager sharedManager] get_origin] == @"HOME")
    {
        [self performSegueWithIdentifier: @"cancelToHome" sender: sender];
    }
    else
    {
        [self performSegueWithIdentifier: @"cancelToList" sender: sender];
    }

}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"addEventView"]){
        NSString *selected_name = [search_result objectAtIndex:index_path.row];
        SingleEventViewController *destViewController = (SingleEventViewController *)segue.destinationViewController;
        [destViewController setName: selected_name];
    }
}




@end