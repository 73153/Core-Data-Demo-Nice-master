// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PTPutt.h instead.

#import <CoreData/CoreData.h>


extern const struct PTPuttAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *number;
	__unsafe_unretained NSString *result;
} PTPuttAttributes;

extern const struct PTPuttRelationships {
	__unsafe_unretained NSString *hole;
} PTPuttRelationships;

extern const struct PTPuttFetchedProperties {
} PTPuttFetchedProperties;

@class PTHole;





@interface PTPuttID : NSManagedObjectID {}
@end

@interface _PTPutt : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PTPuttID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* number;



@property int16_t numberValue;
- (int16_t)numberValue;
- (void)setNumberValue:(int16_t)value_;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* result;



@property int16_t resultValue;
- (int16_t)resultValue;
- (void)setResultValue:(int16_t)value_;

//- (BOOL)validateResult:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) PTHole *hole;

//- (BOOL)validateHole:(id*)value_ error:(NSError**)error_;





@end

@interface _PTPutt (CoreDataGeneratedAccessors)

@end

@interface _PTPutt (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveNumber;
- (void)setPrimitiveNumber:(NSNumber*)value;

- (int16_t)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(int16_t)value_;




- (NSNumber*)primitiveResult;
- (void)setPrimitiveResult:(NSNumber*)value;

- (int16_t)primitiveResultValue;
- (void)setPrimitiveResultValue:(int16_t)value_;





- (PTHole*)primitiveHole;
- (void)setPrimitiveHole:(PTHole*)value;


@end
