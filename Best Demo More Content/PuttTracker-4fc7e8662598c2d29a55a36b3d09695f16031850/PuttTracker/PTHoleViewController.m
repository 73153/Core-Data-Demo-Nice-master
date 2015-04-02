#import "PTHoleViewController.h"
#import "PTHole.h"
#import "PTPuttCell.h"
#import "UIViewController+CoreData.h"
#import "NSObject+Alerts.h"
#import "PTPutt.h"
#import "PTPuttViewController.h"

@interface PTHoleViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) BOOL shouldCheckForPutts;

@end

@implementation PTHoleViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.shouldCheckForPutts = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self checkForPutts];
}

- (void) checkForPutts {
	if (self.shouldCheckForPutts) {
		if (self.hole.putts.count == 0) {
			self.shouldCheckForPutts = NO;
			PTPuttViewController *puttViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PTPuttViewController class])];
			puttViewController.hole = self.hole;
			[self.navigationController pushViewController:puttViewController animated:NO];
		}
	}
}

- (void)setHole:(PTHole *)hole {
	_hole = hole;
	[self performFetch];
	[self updateUI];
}

#pragma mark - seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[PTPuttViewController class]]) {
		if ([segue.identifier isEqualToString:@"AddPuttSegueIdentifier"]) {
			PTPuttViewController *puttViewController = segue.destinationViewController;
			puttViewController.hole = self.hole;
		} else if ([segue.identifier isEqualToString:@"EditPuttSegueIdentifier"]) {
			PTPuttCell *puttCell = sender;
			PTPuttViewController *puttViewController = segue.destinationViewController;
			puttViewController.hole = self.hole;
			puttViewController.putt = puttCell.putt;
		}
	}
}

#pragma mark - updateUI

- (void) updateUI {
	self.title = [NSString stringWithFormat:@"%@: Putts", self.hole.description];
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
	PTPuttCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PTPuttCell class])];
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
	PTPutt *putt = [self.fetchedResultsController objectAtIndexPath:indexPath];
	PTPuttCell *puttCell = (PTPuttCell*)cell;
	puttCell.putt = putt;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		PTPutt *putt = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[putt delete];
    }
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController == nil) {
		NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PTPutt class])];
		
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
		NSArray *sortDescriptors = @[sortDescriptor];
		request.sortDescriptors = sortDescriptors;
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hole == %@", self.hole];
		request.predicate = predicate;
		
		_fetchedResultsController = [self fetchedResultsControllerWithRequest:request];
		_fetchedResultsController.delegate = self;
	}
	
	return _fetchedResultsController;
}

- (void) performFetch {
	NSError *error;
	[self.fetchedResultsController performFetch:&error];
	if (error) {
		[self showAlertForError:error];
	}
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
