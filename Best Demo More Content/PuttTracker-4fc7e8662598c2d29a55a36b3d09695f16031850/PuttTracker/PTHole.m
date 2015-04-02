#import "PTHole.h"


@interface PTHole ()

@end


@implementation PTHole

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Hole", nil), self.numberValue];
}

@end
