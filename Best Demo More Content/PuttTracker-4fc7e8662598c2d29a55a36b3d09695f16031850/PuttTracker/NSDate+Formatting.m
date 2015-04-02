#import "NSDate+Formatting.h"

@implementation NSDate (Formatting)

- (NSString *)stringFromDate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateStyle = NSDateFormatterLongStyle;
	return [formatter stringFromDate:self];
}

+ (NSDate *)dateFromString:(NSString*)string {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"MMMM dd, yyyy";
	return [formatter dateFromString:string];
}

@end
