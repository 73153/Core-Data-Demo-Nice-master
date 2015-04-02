#import "PTRound.h"
#import "PTHole.h"
#import "NSObject+CoreData.h"

@interface PTRound ()

@end


@implementation PTRound

- (void) initializeHoles {
	if (self.holes != nil && self.holes.count == 0) {
		for (NSInteger i = 1; i <= 18; i++) {
			PTHole *hole = [PTHole insertInManagedObjectContext:self.managedObjectContext];
			hole.round = self;
			hole.numberValue = i;
			[self addHolesObject:hole];
		}
	}
}

+ (id)newEntity {
	PTRound *round = [super newEntity];
	[round initializeHoles];
	return round;
}

@end
