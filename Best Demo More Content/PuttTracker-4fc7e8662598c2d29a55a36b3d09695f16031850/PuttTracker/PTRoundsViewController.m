#import "PTRoundsViewController.h"
#import "PTRoundCell.h"
#import "PTRound.h"
#import "UIViewController+CoreData.h"
#import "NSObject+Alerts.h"
#import "PTRoundViewController.h"

@interface PTRoundsViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PTRoundsViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	[self performFetch];
	self.title = NSLocalizedString(@"Rounds", nil);
}

- (void) performFetch {
	NSError *error;
	[self.fetchedResultsController performFetch:&error];
	if (error) {
		[self showAlertForError:error];
	}
}

#pragma mark - seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[PTRoundViewController class]]) {
		PTRoundCell *roundCell = sender;
		
		PTRoundViewController *roundViewController = segue.destinationViewController;
		roundViewController.round = roundCell.round;
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	return sectionInfo.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PTRoundCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PTRoundCell class])];
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
	PTRound *round = [self.fetchedResultsController objectAtIndexPath:indexPath];
	PTRoundCell *roundCell = (PTRoundCell*)cell;
	roundCell.round = round;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		PTRound *round = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[round delete];
    }
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController == nil) {
		NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PTRound class])];
		
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
		NSArray *sortDescriptors = @[sortDescriptor];
		request.sortDescriptors = sortDescriptors;
		
		_fetchedResultsController = [self fetchedResultsControllerWithRequest:request];
		_fetchedResultsController.delegate = self;
	}
	
	return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
					atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
