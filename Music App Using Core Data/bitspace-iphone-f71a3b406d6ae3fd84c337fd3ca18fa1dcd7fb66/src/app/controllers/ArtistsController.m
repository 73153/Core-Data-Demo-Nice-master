//
//  ArtistsController.m
//  bitspace-iphone
//
//  Created by Niklas Holmgren on 2010-07-13.
//  Copyright 2010 Koneko Collective Ltd. All rights reserved.
//

#import "ArtistsController.h"
#import "AppDelegate.h"
#import "Artist.h"
#import "ArtistController.h"
#import "Theme.h"


@implementation ArtistsController

@synthesize appDelegate, fetchedResultsController;
@synthesize navigationBar;
@synthesize searchResultsController;
@synthesize searchBar, searchController;


#pragma mark -
#pragma mark Pull to refresh

- (void)reloadTableViewDataSource {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ForceSynchronization" object:nil];
}


- (void)synchronizationDidFinish {
	[self dataSourceDidFinishLoadingNewData];
	self.refreshHeaderView.lastUpdatedDate = self.appDelegate.lastSynchronizationDate;
}


#pragma mark -
#pragma mark Reset view

- (void)resetView {
	
	// Reset the view
	[self.navigationController popToRootViewControllerAnimated:NO];
	[self.searchController setActive:NO];
	[self.searchBar setText:@""];
	
	// Reset the last updated date
	self.refreshHeaderView.lastUpdatedDate = nil;
}

- (void)resetAppState {
	[fetchedResultsController release]; fetchedResultsController = nil;
	[searchResultsController release]; searchResultsController = nil;
	[self.fetchedResultsController performFetch:nil];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationBar.tintColor = [Theme navigationBarColor];
	
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
	searchBar.delegate = self;
	self.tableView.tableHeaderView = searchBar;
	
	searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.delegate = self;
	searchController.searchResultsDataSource = self;
	searchController.searchResultsDelegate = self;
	
	
	// Watch for reset app state events
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(resetAppState) 
												 name:@"ResetAppState" 
											   object:nil];
	
	// Watch for reset app state events
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(synchronizationDidFinish) 
												 name:@"ReleasesSynchronizationDidFinish" 
											   object:nil];
	
	[self.fetchedResultsController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
	
	self.refreshHeaderView.lastUpdatedDate = self.appDelegate.lastSynchronizationDate;
	
	if(self.tableView.contentOffset.y == 0) {
		self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height);
	}
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(tableView == searchController.searchResultsTableView) {
		return [[searchResultsController sections] count];
	} else {
		return [[fetchedResultsController sections] count];
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == searchController.searchResultsTableView) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[searchResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	} else {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
	if(tableView == searchController.searchResultsTableView) {
		Artist *artist = (Artist *)[searchResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text = artist.name;
	} else {
		Artist *artist = (Artist *)[fetchedResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text = artist.name;
	}
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(tableView == searchController.searchResultsTableView) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[searchResultsController sections] objectAtIndex:section];
		return [sectionInfo name];
	} else {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo name];	
	}
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if(tableView == searchController.searchResultsTableView) {
		return [searchResultsController sectionIndexTitles];
	} else {
		return [fetchedResultsController sectionIndexTitles];
	}
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	if(tableView == searchController.searchResultsTableView) {
		return [searchResultsController sectionForSectionIndexTitle:title atIndex:index];
	} else {
		return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Artist *artist;
	
	if(tableView == searchController.searchResultsTableView) {
		artist = [self.searchResultsController objectAtIndexPath:indexPath];
	} else {
		artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
	}
	
	ArtistController *artistController = [[ArtistController alloc] initWithNibName:@"Artist" bundle:nil];
	artistController.appDelegate = self.appDelegate;
	artistController.theArtist = artist;
	[self.navigationController pushViewController:artistController animated:YES];
	[artistController release];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.appDelegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort keys as appropriate.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortName" ascending:YES selector:@selector(compare:)];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the filter predicate as appropriate.
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"archived == NO"];
		[fetchRequest setPredicate:predicate];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.appDelegate.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return fetchedResultsController;
}


- (NSFetchedResultsController *)searchResultsController {
    // Set up the search results controller if needed.
    if (searchResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:self.appDelegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortName" ascending:YES selector:@selector(compare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
		
		// Edit the filter predicate as appropriate.
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"archived == NO"];
		[fetchRequest setPredicate:predicate];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aSearchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.appDelegate.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
        aSearchResultsController.delegate = self;
        self.searchResultsController = aSearchResultsController;
        
        [aSearchResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	
	return searchResultsController;
}


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	if(controller == searchResultsController) {
		[searchController.searchResultsTableView beginUpdates];
	} else {
		[self.tableView beginUpdates];
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView;
	
	if(controller == searchResultsController) {
		tableView = searchController.searchResultsTableView;
	} else {
		tableView = self.tableView;
	}
	
	UITableViewCell *cell;
	Artist *artist;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			cell = [tableView cellForRowAtIndexPath:indexPath];
			artist = (Artist *)[controller objectAtIndexPath:indexPath];
			cell.textLabel.text = artist.name;
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	UITableView *tableView;
	
	if(controller == searchResultsController) {
		tableView = searchController.searchResultsTableView;
	} else {
		tableView = self.tableView;
	}
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	if(controller == searchResultsController) {
		[searchController.searchResultsTableView endUpdates];
	} else {
		[self.tableView endUpdates];
	}
}


#pragma mark -
#pragma mark <UISearchDisplayDelegate> Implementation

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self.searchResultsController.fetchRequest setPredicate:nil];
	
    NSError *error = nil;
    if (![self.searchResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString*)searchString searchScope:(NSInteger)searchOption {
	
	NSPredicate *predicate = nil;
	if ([searchString length]) {
		predicate = [NSPredicate predicateWithFormat:@"archived == NO AND name contains[cd] %@", searchString];
	}
	[self.searchResultsController.fetchRequest setPredicate:predicate];
	
    NSError *error = nil;
    if (![self.searchResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }           
	
	return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	NSInteger searchOption = controller.searchBar.selectedScopeButtonIndex;
	return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	NSString* searchString = controller.searchBar.text;
	return [self searchDisplayController:controller shouldReloadTableForSearchString:searchString searchScope:searchOption];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
    [super dealloc];
}


@end

