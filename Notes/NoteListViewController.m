//
//  NoteListViewController.m
//  Notes
//
//  Created by Marius Horga on 1/9/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import "NoteListViewController.h"
#import "CoreDataStack.h"
#import "Note.h"
#import "ViewController.h"
#import "Constants.h"

@interface NoteListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *resultsArray;

@end

@implementation NoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isPhone) {
        NSLog(@"iPhone");
    } else {
        NSLog(@"iPad");
    }
    
    self.resultsArray = [NSMutableArray arrayWithCapacity:self.fetchedResultsController.sections.count];
    [self.fetchedResultsController performFetch:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        ViewController *viewController = (ViewController *)navigationController.topViewController;
        viewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self noteListFetchRequest];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (NSFetchRequest *)noteListFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastModified" ascending:NO]];
    return fetchRequest;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.resultsArray count];
    } else {
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    Note* entry;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        entry = [self.resultsArray objectAtIndex:indexPath.row];
    } else {
        entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    cell.textLabel.text = entry.title;
    cell.detailTextLabel.text = entry.text;
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark Content Filtering and UISearchDisplayController delegate methods

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.resultsArray removeAllObjects];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:coreDataStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[c] %@) OR (text CONTAINS[c] %@)", searchText, searchText];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray* loadedEntities = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.resultsArray = [[NSMutableArray alloc] initWithArray:loadedEntities];
    [self.tableView reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

@end
