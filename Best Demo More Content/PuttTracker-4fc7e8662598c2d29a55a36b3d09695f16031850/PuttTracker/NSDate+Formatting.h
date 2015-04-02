@interface NSDate (Formatting)

@property (readonly) NSString *stringFromDate;

+ (NSDate*) dateFromString:(NSString*)string;

@end
