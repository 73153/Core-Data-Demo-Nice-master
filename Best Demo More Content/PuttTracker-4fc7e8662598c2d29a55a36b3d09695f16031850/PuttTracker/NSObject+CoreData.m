#import "NSObject+CoreData.h"

@implementation NSObject (CoreData)

- (PTAppDelegate *)appDelegate {
	UIApplication *application = [UIApplication sharedApplication];
	PTAppDelegate *appDelegate = application.delegate;
	return appDelegate;
}

- (NSManagedObjectContext *)managedObjectContext {
	return self.appDelegate.managedObjectContext;
}


@end
