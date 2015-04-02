// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PTRound.m instead.

#import "_PTRound.h"

const struct PTRoundAttributes PTRoundAttributes = {
	.date = @"date",
	.id = @"id",
	.location = @"location",
};

const struct PTRoundRelationships PTRoundRelationships = {
	.holes = @"holes",
};

const struct PTRoundFetchedProperties PTRoundFetchedProperties = {
};

@implementation PTRoundID
@end

@implementation _PTRound

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PTRound" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PTRound";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PTRound" inManagedObjectContext:moc_];
}

- (PTRoundID*)objectID {
	return (PTRoundID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic date;






@dynamic id;






@dynamic location;






@dynamic holes;

	
- (NSMutableSet*)holesSet {
	[self willAccessValueForKey:@"holes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"holes"];
  
	[self didAccessValueForKey:@"holes"];
	return result;
}
	






@end
