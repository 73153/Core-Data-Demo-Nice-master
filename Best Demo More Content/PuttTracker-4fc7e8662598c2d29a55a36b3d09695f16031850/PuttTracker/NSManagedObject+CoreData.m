#import "NSManagedObject+CoreData.h"
#import "NSObject+CoreData.h"
#import "NSObject+Alerts.h"

@implementation NSManagedObject (CoreData)

+ (NSArray *)allObjects {
	return [self allObjectsWithPredicate:nil sortDescriptor:nil];
}

+ (NSArray *)allObjectsWithPredicate:(NSPredicate*)predicate sortDescriptor:(NSSortDescriptor*)sortDescriptor {
	NSString *entityName = NSStringFromClass([self class]);
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
	request.predicate = predicate;
	request.sortDescriptors = @[sortDescriptor];
	NSManagedObjectContext *context = [self managedObjectContext];
	NSError *error;
	NSArray *objects = [context executeFetchRequest:request error:&error];
	if (error) {
		[self showAlertForError:error];
	}
	
	return objects;
}

+ (id)newEntity {
	NSString *entityName = NSStringFromClass([self class]);
	NSManagedObjectContext *context = self.managedObjectContext;
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}

- (void)delete {
	[self.managedObjectContext deleteObject:self];
	[self.appDelegate saveContext];
}

@end
