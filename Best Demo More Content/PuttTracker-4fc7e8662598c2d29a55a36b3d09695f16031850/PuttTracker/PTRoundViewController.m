#import "PTRoundViewController.h"
#import "PTRound.h"
#import "PTHoleCell.h"
#import "UIViewController+CoreData.h"
#import "PTHole.h"
#import "NSObject+Alerts.h"
#import "PTHoleViewController.h"

@interface PTRoundViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PTRoundViewController

- (void)setRound:(PTRound *)round {
	_round = round;
	[self performFetch];
	[self updateUI];
}

#pragma mark - notifications

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHole:) name:@"NOTIFICATION_SHOW_HOLE" object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTIFICATION_SHOW_HOLE" object:nil];
}

- (void) showHole:(NSNotification*)notification {
	PTHole *hole = notification.object;
	PTHoleCell *cell = [[PTHoleCell alloc] init];
	cell.hole = hole;
	[self.navigationController popToViewController:self animated:NO];
	[self performSegueWithIdentifier:@"ShowHoleViewController" sender:cell];
}

#pragma mark - seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[PTHoleViewController class]]) {
		PTHoleCell *holeCell = sender;
		
		PTHoleViewController *holeViewController = segue.destinationViewController;
		holeViewController.hole = holeCell.hole;
	}
}

#pragma mark - updateUI

- (void) updateUI {
	self.title = self.round.location;
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
	PTHoleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PTHoleCell class])];
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
	PTHole *hole = [self.fetchedResultsController objectAtIndexPath:indexPath];
	PTHoleCell *roundCell = (PTHoleCell*)cell;
	roundCell.hole = hole;
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController == nil) {
		NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([PTHole class])];
		
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
		NSArray *sortDescriptors = @[sortDescriptor];
		request.sortDescriptors = sortDescriptors;
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"round == %@", self.round];
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
