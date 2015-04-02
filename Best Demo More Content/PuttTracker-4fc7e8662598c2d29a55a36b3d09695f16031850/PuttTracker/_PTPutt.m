// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PTPutt.m instead.

#import "_PTPutt.h"

const struct PTPuttAttributes PTPuttAttributes = {
	.id = @"id",
	.number = @"number",
	.result = @"result",
};

const struct PTPuttRelationships PTPuttRelationships = {
	.hole = @"hole",
};

const struct PTPuttFetchedProperties PTPuttFetchedProperties = {
};

@implementation PTPuttID
@end

@implementation _PTPutt

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PTPutt" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PTPutt";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PTPutt" inManagedObjectContext:moc_];
}

- (PTPuttID*)objectID {
	return (PTPuttID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"numberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"number"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"resultValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"result"];
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





@dynamic result;



- (int16_t)resultValue {
	NSNumber *result = [self result];
	return [result shortValue];
}

- (void)setResultValue:(int16_t)value_ {
	[self setResult:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveResultValue {
	NSNumber *result = [self primitiveResult];
	return [result shortValue];
}

- (void)setPrimitiveResultValue:(int16_t)value_ {
	[self setPrimitiveResult:[NSNumber numberWithShort:value_]];
}





@dynamic hole;

	






@end
