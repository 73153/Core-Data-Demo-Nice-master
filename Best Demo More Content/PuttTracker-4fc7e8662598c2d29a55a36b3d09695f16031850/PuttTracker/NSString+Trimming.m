#import "NSString+Trimming.h"

@implementation NSString (Trimming)

- (NSString *)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
