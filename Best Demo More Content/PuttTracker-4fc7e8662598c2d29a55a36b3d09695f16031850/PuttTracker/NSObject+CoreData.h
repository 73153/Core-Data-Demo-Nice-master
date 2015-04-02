#import "PTAppDelegate.h"

@interface NSObject (CoreData)

- (PTAppDelegate *) appDelegate;
- (NSManagedObjectContext *) managedObjectContext;

@end
