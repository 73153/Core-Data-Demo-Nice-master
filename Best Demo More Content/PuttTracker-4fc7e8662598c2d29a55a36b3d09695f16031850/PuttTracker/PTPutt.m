#import "PTPutt.h"

@interface PTPutt ()

@end

@implementation PTPutt

+ (NSString *)descriptionForZone:(NSInteger)zone {
	switch (zone) {
		case 1:
			return NSLocalizedString(@"Long left", nil);
			break;
		case 2:
			return NSLocalizedString(@"Long", nil);
			break;
		case 3:
			return NSLocalizedString(@"Long right", nil);
			break;
		case 4:
			return NSLocalizedString(@"Left", nil);
			break;
		case 5:
			return NSLocalizedString(@"Holed", nil);
			break;
		case 6:
			return NSLocalizedString(@"Right", nil);
			break;
		case 7:
			return NSLocalizedString(@"Short left", nil);
			break;
		case 8:
			return NSLocalizedString(@"Short", nil);
			break;
		case 9:
			return NSLocalizedString(@"Short right", nil);
			break;
		default:
			return @"";
			break;
	}
}

+ (NSInteger)nextAvailableNumberForHole:(PTHole *)hole {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hole == %@", hole];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
	NSArray *putts = [PTPutt allObjectsWithPredicate:predicate sortDescriptor:sortDescriptor];
	
	if (putts.count > 0) {
		PTPutt *lastPutt = [putts lastObject];
		return lastPutt.numberValue + 1;
	}
	
	return 1;
}

- (NSString *)description {
	return [PTPutt descriptionForZone:self.resultValue];
}

- (NSString *)numberAsString {
	switch (self.numberValue) {
		case 1:
			return NSLocalizedString(@"First putt", nil);
			break;
		case 2:
			return NSLocalizedString(@"Second putt", nil);
			break;
		case 3:
			return NSLocalizedString(@"Third putt", nil);
			break;
		case 4:
			return NSLocalizedString(@"Fourth putt", nil);
			break;
		case 5:
			return NSLocalizedString(@"Fifth putt", nil);
			break;
		case 6:
			return NSLocalizedString(@"Sixth putt", nil);
			break;
		case 7:
			return NSLocalizedString(@"Seventh putt", nil);
			break;
		case 8:
			return NSLocalizedString(@"Eight putt", nil);
			break;
		case 9:
			return NSLocalizedString(@"Ninth putt", nil);
			break;
		case 10:
			return NSLocalizedString(@"Tenth putt", nil);
			break;
		default:
			return NSLocalizedString(@"No way! Seriously?", nil);
			break;
	}
}

@end
