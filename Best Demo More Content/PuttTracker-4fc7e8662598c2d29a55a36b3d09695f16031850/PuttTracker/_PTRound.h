// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PTRound.h instead.

#import <CoreData/CoreData.h>


extern const struct PTRoundAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *location;
} PTRoundAttributes;

extern const struct PTRoundRelationships {
	__unsafe_unretained NSString *holes;
} PTRoundRelationships;

extern const struct PTRoundFetchedProperties {
} PTRoundFetchedProperties;

@class PTHole;





@interface PTRoundID : NSManagedObjectID {}
@end

@interface _PTRound : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PTRoundID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *holes;

- (NSMutableSet*)holesSet;





@end

@interface _PTRound (CoreDataGeneratedAccessors)

- (void)addHoles:(NSSet*)value_;
- (void)removeHoles:(NSSet*)value_;
- (void)addHolesObject:(PTHole*)value_;
- (void)removeHolesObject:(PTHole*)value_;

@end

@interface _PTRound (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;





- (NSMutableSet*)primitiveHoles;
- (void)setPrimitiveHoles:(NSMutableSet*)value;


@end
