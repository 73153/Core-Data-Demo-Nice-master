#import "UIViewController+CoreData.h"
#import "NSObject+Alerts.h"
#import "NSObject+CoreData.h"

@implementation UIViewController (CoreData)

- (void)save {
	[self.appDelegate saveContext];
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request {
	NSManagedObjectContext *context = self.managedObjectContext;
	NSString *sectionNameKeyPath = nil;
	NSString *cacheName = nil;
	
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
	
	return fetchedResultsController;
}

@end
