#import "_PTPutt.h"
#import "NSManagedObject+CoreData.h"

@interface PTPutt : _PTPutt {}

@property (readonly) NSString *numberAsString;

+ (NSInteger) nextAvailableNumberForHole:(PTHole*)hole;

+ (NSString*) descriptionForZone:(NSInteger)zone;

@end
