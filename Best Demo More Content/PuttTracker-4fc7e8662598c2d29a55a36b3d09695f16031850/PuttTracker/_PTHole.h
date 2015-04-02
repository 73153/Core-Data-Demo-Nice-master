// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PTHole.h instead.

#import <CoreData/CoreData.h>


extern const struct PTHoleAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *number;
} PTHoleAttributes;

extern const struct PTHoleRelationships {
	__unsafe_unretained NSString *putts;
	__unsafe_unretained NSString *round;
} PTHoleRelationships;

extern const struct PTHoleFetchedProperties {
} PTHoleFetchedProperties;

@class PTPutt;
@class PTRound;




@interface PTHoleID : NSManagedObjectID {}
@end

@interface _PTHole : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PTHoleID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* number;



@property int16_t numberValue;
- (int16_t)numberValue;
- (void)setNumberValue:(int16_t)value_;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *putts;

- (NSMutableSet*)puttsSet;




@property (nonatomic, strong) PTRound *round;

//- (BOOL)validateRound:(id*)value_ error:(NSError**)error_;





@end

@interface _PTHole (CoreDataGeneratedAccessors)

- (void)addPutts:(NSSet*)value_;
- (void)removePutts:(NSSet*)value_;
- (void)addPuttsObject:(PTPutt*)value_;
- (void)removePuttsObject:(PTPutt*)value_;

@end

@interface _PTHole (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveNumber;
- (void)setPrimitiveNumber:(NSNumber*)value;

- (int16_t)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(int16_t)value_;





- (NSMutableSet*)primitivePutts;
- (void)setPrimitivePutts:(NSMutableSet*)value;



- (PTRound*)primitiveRound;
- (void)setPrimitiveRound:(PTRound*)value;


@end
