// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PTHole.m instead.

#import "_PTHole.h"

const struct PTHoleAttributes PTHoleAttributes = {
	.id = @"id",
	.number = @"number",
};

const struct PTHoleRelationships PTHoleRelationships = {
	.putts = @"putts",
	.round = @"round",
};

const struct PTHoleFetchedProperties PTHoleFetchedProperties = {
};

@implementation PTHoleID
@end

@implementation _PTHole

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PTHole" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PTHole";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PTHole" inManagedObjectContext:moc_];
}

- (PTHoleID*)objectID {
	return (PTHoleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"numberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"number"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;






@dynamic number;



- (int16_t)numberValue {
	NSNumber *result = [self number];
	return [result shortValue];
}

- (void)setNumberValue:(int16_t)value_ {
	[self setNumber:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNumberValue {
	NSNumber *result = [self primitiveNumber];
	return [result shortValue];
}

- (void)setPrimitiveNumberValue:(int16_t)value_ {
	[self setPrimitiveNumber:[NSNumber numberWithShort:value_]];
}





@dynamic putts;

	
- (NSMutableSet*)puttsSet {
	[self willAccessValueForKey:@"putts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"putts"];
  
	[self didAccessValueForKey:@"putts"];
	return result;
}
	

@dynamic round;

	






@end
