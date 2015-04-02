#import "PTAppDelegate.h"
#import "NSObject+CoreData.h"

@interface UIViewController (CoreData)

- (void) save;
- (NSFetchedResultsController*) fetchedResultsControllerWithRequest:(NSFetchRequest*)request;

@end
