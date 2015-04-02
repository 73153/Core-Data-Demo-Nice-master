@interface NSManagedObject (CoreData)

+ (NSArray*) allObjects;
+ (NSArray *)allObjectsWithPredicate:(NSPredicate*)predicate sortDescriptor:(NSSortDescriptor*)sortDescriptor;

+ (id) newEntity;

- (void) delete;

@end
